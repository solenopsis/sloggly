/** A class for writing to Loggly
*
* @author Patrick Connelly (patrick@deadlypenguin.com)
*/
public with sharing class Loggly {
	private static String DEFAULT_LEVEL = 'INFO';
	private static String DATE_FORMAT = 'yyyy-MM-dd HH:mm:ss.SSSZ';

	/** This is used to determine which custom setting to fetch */
	public static String SETTING_NAME {
		get {
			if (SETTING_NAME == null) {
				SETTING_NAME = 'default';
			}

			return SETTING_NAME;
		}
		set;
	}

	/** This is our custom setting fetch based on SETTING_NAME */
	public static LogglySettings__c SETTINGS {
		get {
			if (SETTINGS == null) {
				SETTINGS = LogglySettings__c.getValues(SETTING_NAME);
			}

			return SETTINGS;
		}
		private set;
	}

	/** This gets the endpoint from the SETTINGS.
	*		NOTE: This should be a JSON endpoint in order to send multiple messages
	*/
	public static String LOGGLY_ENDPOINT {
		get {
			if (LOGGLY_ENDPOINT == null && SETTINGS != null) {
				LOGGLY_ENDPOINT = SETTINGS.Endpoint__c;
			}

			return LOGGLY_ENDPOINT;
		}
		private set;
	}

	/** This gets if the hostname should be included in the log sent to loggly */
	public static Boolean INCLUDE_HOSTNAME {
		get {
			if (INCLUDE_HOSTNAME == null) {
				return (SETTINGS == null) ? true : (SETTINGS.Include_Hostname__c == null) ? false : SETTINGS.Include_Hostname__c;
			}

			return INCLUDE_HOSTNAME;
		}
		private set;
	}

	/** This is the hostname set in the configuration */
	private static String HOSTNAME {
		get {
			if (HOSTNAME == null && SETTINGS != null) {
				HOSTNAME = SETTINGS.Hostname__c;
			}

			return HOSTNAME;
		}
		private set;
	}

	/** This is if we should batch logs.
	*	This is important for being able to use Loggly.singleLog and still
	*	capture it and send it over and only use one @future call.  If you
	*	have a known exit point (IE a webservice call) set this to true and
	*	before exiting the method call the flush() on your Loggly instance.
	*/
	public static Boolean BATCH_LOGS {
		get {
			if (BATCH_LOGS == null) {
				BATCH_LOGS = false;
			}

			return BATCH_LOGS;
		}
		set;
	}

	/** This class is a wrapper for our log information.
	*	It allows us to easily format log information internally without our
	*	clients having to know formatting scheme.
	*/
	private class Log {
		/** The text value of the message */
		public String logValue;
		/** The time in which the log occured.
		*	NOTE: Loggly does not support setting actual date the event
		*	happend, but it will be coming soon.  For the meantime, we'll just
		*	store that information as part of the message being sent over
		*/
		public DateTime logDate;

		/** The level of the log (eg ERROR, WARNING, INFO, DEBUG) */
		public String logLevel;

		/** Blank constructor */
		public Log() {}

		/** Constructor with standard values
		*
		* @param logValue The text message
		* @param logDate The date the event happened
		*/
		public Log(String logValue, DateTime logDate) {
			this();
			this.logValue = logValue;
			this.logDate = logDate;
			this.logLevel = DEFAULT_LEVEL;
		}

		/** Constructor with only a logValue
		*
		* @param logValue The text message
		*/
		public Log(String logValue) {
			this(logValue, DateTime.now());
		}

		/** Constructor with standard values
		*
		* @param logValue The text message
		* @param logDate The date the event happened
		* @param logLevel The level
		*/
		public Log(String logValue, DateTime logDate, String logLevel) {
			this(logValue, logDate);
			this.logLevel = logLevel;
		}

		/** Returns a JSON string version of the log message
		*
		* @return The JSON string
		*/
		public String toJSONString() {
			String result = '{';

			if (INCLUDE_HOSTNAME && HOSTNAME != null) {
				result = result + '"host": '+JSON.serialize(HOSTNAME)+',';
			}

			if (this.logLevel != null) {
				result = result + '"level": ' + JSON.serialize(this.logLevel) + ',';
			}

			result = result + '"datetime": ' + JSON.serialize(this.logDate.format(DATE_FORMAT)) + ',';
			result = result + '"message": ' + JSON.serialize(this.logValue) + ' }';

			return result;
		}
	}

	/**
	* A class to cache several log messages to then push to Loggly at one time
	*/
	private class LogCache {
		/** A list of all the logs */
		public List<Log> logs;

		/** Constructor to make a new empty list */
		public LogCache() {
			this.logs = new List<Log>();
		}

		/** A constructor based on a single log object
		*
		* @param log A log
		*/
		public LogCache(Log log) {
			this();
			this.logs.add(log);
		}

		/** A construtor based on a list of logs
		*
		* @param logs A list of logs
		*/
		public LogCache(List<Log> logs) {
			this();
			this.logs.addAll(logs);
		}

		/** Adds a single log to the list
		*
		* @param log A log
		*/
		public void add(Log log) {
			this.logs.add(log);
		}

		/** Flushes all of the logs and pushes them to Loggly */
		public void flushLogs() {
			Set<String> logMessages = new Set<String>();

			for (Log log: this.logs) {
				logMessages.add(log.toJSONString());
			}

			if (!logMessages.isEmpty()) {
				sendLogs(logMessages);
			}

			this.logs.clear();
		}
	}

	/** An instance variable of our log cache */
	public static LogCache cache;

	/** Constructor for use with batching logs */
	public Loggly() {
		cache = new LogCache();
	}

	/** Adds a new log to our cache
	*
	* @param logValue The text message
	* @param logDate The date the event happened
	*/
	public void add(String logValue, DateTime logDate) {
		cache.add(new Log(logValue, logDate));
	}

	public void add(String logValue, DateTime logDate, String logLevel) {
		cache.add(new Log(logValue, logDate, logLevel));
	}

	/** Flushes the logs to Loggly */
	public void flush() {
		cache.flushLogs();
	}

	/** Sends a single log to Loggly.
	*	This can be overridden by setting BATCH_LOGS to true
	*
	* @param logValue The text message
	* @param logDate The date the event happened
	* @param logLevel The level
	* @param logCache An existing logCache to add our messages to if BATCH_LOGS is true
	*/
	public static void singleLog(String logValue, DateTime logDate, String logLevel, LogCache logCache) {
		Log log = new Log(logValue, logDate, logLevel);

		//If we are batching logs we want to override single log.  All calls
		//  should then be made through a class instance of loggly
		if (!BATCH_LOGS) {
			sendLogs(new Set<String>{log.toJSONString()});
		} else if (logCache != null) {
			logCache.add(log);
		}
	}

	/** Sends a single log to Loggly.
	*	This can be overridden by setting BATCH_LOGS to true
	*
	* @param logValue The text message
	* @param logDate The date the event happened
	* @param logCache An existing logCache to add our messages to if BATCH_LOGS is true
	*/
	public static void singleLog(String logValue, DateTime logDate, LogCache logCache) {
		Log log = new Log(logValue, logDate);

		//If we are batching logs we want to override single log.  All calls
		//  should then be made through a class instance of loggly
		if (!BATCH_LOGS) {
			sendLogs(new Set<String>{log.toJSONString()});
		} else if (logCache != null) {
			logCache.add(log);
		}
	}

	/** Sends a single log to Loggly
	*
	* @param logValue The text message
	* @param logDate The date the event happened
	*/
	public static void singleLog(String logValue, DateTime logDate) {
		singleLog(logValue, logDate, cache);
	}

	/** Sends a single log to Loggly
	*
	* @param logValue The text message
	* @param logDate The date the event happened
	* @param logLevel The level
	*/
	public static void singleLog(String logValue, DateTime logDate, String logLevel) {
		singleLog(logValue, logDate, logLevel, cache);
	}

	/** Sends the logs to Loggly
	*
	* @param logs A set of log messages (in JSON format) to send to endpoint
	*/
	@future (callout=true)
	public static void sendLogs(Set<String> logs) {
		List<String> logList = new List<String>();
		logList.addAll(logs);

		HttpResponse res = new HttpResponse();
		// Build up an array of JSON messages to send to the endpoint
		String message = '[';

		for (Integer i = 0; i < logList.size(); i++) {
			message = message + logList.get(i);

			if (i < logList.size() - 1) {
				message = message + ',';
			}
		}

		message = message + ']';


		try {
			HttpRequest req = new HttpRequest();

			req.setEndpoint(LOGGLY_ENDPOINT);
			req.setMethod('POST');
			req.setHeader('content-type', 'application/json');
			req.setBody(message);

			Http http = new Http();
			res = http.send(req);
		} catch (System.CalloutException e) {
			System.debug(e);
			System.debug(res.toString());
		}
	}

	////////////////////////////////////////////////////
	//               START TEST METHODS               //
	////////////////////////////////////////////////////

	static TestMethod void settingName_default_test() {
		System.assertEquals('default', SETTING_NAME, 'Should get back "default"');
	}

	static TestMethod void settingName_set_test() {
		String settingName = '_unittest_name_';
		SETTING_NAME = settingName;
		System.assertEquals(settingName, SETTING_NAME, 'Should get back the set name');
	}

	static TestMethod void settings_test() {
		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		insert testSettings;

		SETTING_NAME = settingName;

		Test.startTest();

		LogglySettings__c result = SETTINGS;

		Test.stopTest();

		System.assertNotEquals(null, result, 'Should have got a setting back');
		System.assertEquals(endpoint, result.Endpoint__c, 'Did not get the right endpoint back');
	}

	static TestMethod void endpoint_test() {
		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		insert testSettings;

		SETTING_NAME = settingName;

		Test.startTest();

		System.assertEquals(endpoint, LOGGLY_ENDPOINT, 'Did not get the right endpoint back');

		Test.stopTest();
	}

	static TestMethod void hostname_test() {
		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';
		String hostname_val = '_unitest_hostname_';

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		testSettings.Hostname__c = hostname_val;
		insert testSettings;

		SETTING_NAME = settingName;

		Test.startTest();

		System.assertEquals(hostname_val, HOSTNAME, 'Did not get the right hostname back');

		Test.stopTest();
	}

	static TestMethod void include_hostname_true_test() {
		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		testSettings.Include_Hostname__c = true;
		insert testSettings;

		SETTING_NAME = settingName;

		Test.startTest();

		System.assert(INCLUDE_HOSTNAME, 'Hostname should be included');

		Test.stopTest();
	}

	static TestMethod void include_hostname_false_test() {
		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		testSettings.Include_Hostname__c = false;
		insert testSettings;

		SETTING_NAME = settingName;

		Test.startTest();

		System.assert(!INCLUDE_HOSTNAME, 'Hostname should not be included');

		Test.stopTest();
	}

	static TestMethod void include_hostname_null_test() {
		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		insert testSettings;

		SETTING_NAME = settingName;

		Test.startTest();

		System.assert(INCLUDE_HOSTNAME, 'Hostname should be included');

		Test.stopTest();
	}

	static TestMethod void batch_logs_true_test() {
		BATCH_LOGS = true;

		Test.startTest();

		System.assert(BATCH_LOGS, 'We should be batching logs');

		Test.stopTest();
	}

	static TestMethod void batch_logs_false_test() {
		BATCH_LOGS = false;

		Test.startTest();

		System.assert(!BATCH_LOGS, 'We should not be batching logs');

		Test.stopTest();
	}

	static TestMethod void batch_logs_null_test() {
		Test.startTest();

		System.assert(!BATCH_LOGS, 'We should not be batching logs');

		Test.stopTest();
	}

	static TestMethod void log_constructor_blank_test() {
		Test.startTest();

		Log testLog = new Log();

		Test.stopTest();

		System.assertEquals(null, testLog.logValue, 'Log value should default to null');
		System.assertEquals(null, testLog.logDate, 'Log date should default to null');
		System.assertEquals(null, testLog.logLevel, 'Log level should default to null');
	}

	static TestMethod void log_constructor_single_test() {
		String testValue = '_unittest_value_';

		Test.startTest();

		Log testLog = new Log(testValue);

		Test.stopTest();

		System.assertEquals(testValue, testLog.logValue, 'Log value does not equal');
		System.assertNotEquals(null, testLog.logDate, 'Log date should be set');
		System.assertEquals(DEFAULT_LEVEL, testLog.logLevel, 'Log level does not equal');
	}

	static TestMethod void log_constructor_double_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();

		Test.startTest();

		Log testLog = new Log(testValue, testDate);

		Test.stopTest();

		System.assertEquals(testValue, testLog.logValue, 'Log value does not equal');
		System.assertEquals(testDAte, testLog.logDate, 'Log date should does not equal');
		System.assertEquals(DEFAULT_LEVEL, testLog.logLevel, 'Log level does not equal');
	}

	static TestMethod void log_constructor_triple_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();
		String testLevel = '_unittest_level_';

		Test.startTest();

		Log testLog = new Log(testValue, testDate, testLevel);

		Test.stopTest();

		System.assertEquals(testValue, testLog.logValue, 'Log value does not equal');
		System.assertEquals(testDate, testLog.logDate, 'Log date does not equal');
		System.assertEquals(testLevel, testLog.logLevel, 'Log level does not equal');
	}

	static testMethod void log_toJSONString_noHostname_noLevel_test() {
	}

	static testMethod void log_toJSONString_noHostname_test() {
	}

	static testMethod void log_toJSONString_noLevel_test() {
	}

	static testMethod void log_toJSONString_test() {
	}

	static testMethod void logCache_constructor_empty_test() {
	}

	static testMethod void logCache_constructor_log_test() {
	}

	static testMethod void logCache_constructor_list_test() {
	}

	static testMethod void logCache_add_test() {
	}

	static testMethod void logCache_flushLogs_test() {
	}

	static testMethod void loggly_constructor_empty_test() {
	}

	static testMethod void loggly_add_double_test() {
	}

	static testMethod void loggly_add_triple_test() {
	}

	static testMethod void loggly_flush_test() {
	}

	static testMethod void loggly_singleLog_quad_noBatch_test() {
	}

	static testMethod void loggly_singleLog_quad_noCache_test() {
	}

	static testMethod void loggly_singleLog_quad_cache_test() {
	}

	static testMethod void loggly_singleLog_triple_level_noBatch_test() {
	}

	static testMethod void loggly_singleLog_triple_level_noCache_test() {
	}

	static testMethod void loggly_singleLog_triple_level_cache_test() {
	}

	static testMethod void loggly_singleLog_triple_cache_noBatch_test() {
	}

	static testMethod void loggly_singleLog_triple_cache_noCache_test() {
	}

	static testMethod void loggly_singleLog_triple_cache_cache_test() {
	}

	static testMethod void loggly_singleLog_double_noBatch_test() {
	}

	static testMethod void loggly_singleLog_double_noCache_test() {
	}

	static testMethod void loggly_singleLog_double_cache_test() {
	}
}