/** A class for writing to Loggly
*
* @author Patrick Connelly (patrick@deadlypenguin.com)
*/

// Copyright 2012 Patrick Connelly.
//
// This file is part of SLoggly
//
// Sloggly is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA

global with sharing class Loggly {
	global class TestException extends Exception {}

	global static String DEFAULT_LEVEL = 'INFO';
	global static String DATE_FORMAT = 'yyyy-MM-dd HH:mm:ss.SSSZ';
	global static String DEFAULT_SETTING_NAME = 'default';

	global static String EXCEPTION_LEVEL = 'ERROR';
	global static String EXCEPTION_TYPE_NAME = 'exceptionTypeName';
	global static String EXCEPTION_STACK_TRACE = 'exceptionStackTrace';

	global static Boolean TEST_NOCACHE= false;

	global static String KEY_HOST = 'host';
	global static String KEY_USERID = 'userid';
	global static String KEY_USERNAME = 'username';
	global static String KEY_LEVEL = 'level';
	global static String KEY_DATETIME = 'datetime';
	global static String KEY_MESSAGE = 'message';

	/** This is used to determine which custom setting to fetch */
	global static String SETTING_NAME {
		get {
			if (SETTING_NAME == null) {
				SETTING_NAME = DEFAULT_SETTING_NAME;
			}

			return SETTING_NAME;
		}
		set;
	}

	/** This is our custom setting fetch based on SETTING_NAME */
	global static LogglySettings__c SETTINGS {
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
	global static String LOGGLY_ENDPOINT {
		get {
			if (LOGGLY_ENDPOINT == null && SETTINGS != null) {
				LOGGLY_ENDPOINT = SETTINGS.Endpoint__c;
			}

			return LOGGLY_ENDPOINT;
		}
		private set;
	}

	/** This gets if the hostname should be included in the log sent to loggly */
	global static Boolean INCLUDE_HOSTNAME {
		get {
			if (INCLUDE_HOSTNAME == null) {
				if (SETTINGS == null) {
					return false;
				}

				return (SETTINGS.Include_Hostname__c == null) ? false : SETTINGS.Include_Hostname__c;
			}

			return INCLUDE_HOSTNAME;
		}
		private set;
	}

	/** This is the hostname set in the configuration */
	global static String HOSTNAME {
		get {
			if (HOSTNAME == null && SETTINGS != null) {
				HOSTNAME = SETTINGS.Hostname__c;
			}

			return HOSTNAME;
		}
		private set;
	}

	global static Boolean INCLUDE_USERINFO {
		get {
			if (INCLUDE_USERINFO == null) {
				if (SETTINGS == null) {
					return false;
				}

				return (SETTINGS.Include_Userinfo__c == null) ? false : SETTINGS.Include_Userinfo__c;
			}

			return INCLUDE_USERINFO;
		}
		private set;
	}

	/** This is if we should batch logs.
	*	This is important for being able to use Loggly.singleLog and still
	*	capture it and send it over and only use one @future call.  If you
	*	have a known exit point (IE a webservice call) set this to true and
	*	before exiting the method call the flush() on your Loggly instance.
	*/
	global static Boolean BATCH_LOGS {
		get {
			if (BATCH_LOGS == null) {
				BATCH_LOGS = false;
			}

			return BATCH_LOGS;
		}
		set;
	}

	global static Boolean THROW_TEST_EXCEPTION {
		get {
			if (THROW_TEST_EXCEPTION == null) {
				THROW_TEST_EXCEPTION = false;
			}

			return Test.isRunningTest() ? THROW_TEST_EXCEPTION : false;
		}
		set;
	}

	/** This class is a wrapper for our log information.
	*	It allows us to easily format log information internally without our
	*	clients having to know formatting scheme.
	*/
	global class Log {
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

		public Map<String, String> additionalValues;

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

		/** Constructor with additional values
		*
		* @param logValue The text message
		* @param logDate The date the event happened
		* @param logLevel The level
		* @param additionalValues A map of key values for additional data
		*/
		public Log(String logValue, DateTime logDate, String logLevel, Map<String, String> additionalValues) {
			this(logValue, logDate, logLevel);
			this.additionalValues = additionalValues;
		}

		/** Generates a map of key to log data
		*
		* @return A map of key to data value
		*/
		public Map<String, String> toKeyValueMap() {
			Map<String, String> result = new Map<String, String>();

			if (INCLUDE_HOSTNAME && HOSTNAME != null) {
				result.put(KEY_HOST, HOSTNAME);
			}

			if (INCLUDE_USERINFO) {
				result.put(KEY_USERID, UserInfo.getUserId());
				result.put(KEY_USERNAME, UserInfo.getUserName());
			}

			if (this.logLevel != null) {
				result.put(KEY_LEVEL, this.logLevel);
			}

			result.put(KEY_DATETIME, this.logDate.format(DATE_FORMAT));
			result.put(KEY_MESSAGE, this.logValue);

			if (this.additionalValues != null) {
				result.putAll(this.additionalValues);
			}

			return result;
		}

		/** Returns a JSON string version of the log message
		*
		* @return The JSON string
		*/
		public String toJSONString() {
			return JSON.serialize(this.toKeyValueMap());
		}
	}

	/**
	* A class to cache several log messages to then push to Loggly at one time
	*/
	global class LogCache {
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
			if (this.logs.isEmpty()) {
				return;
			}

			Set<String> logMessages = new Set<String>();

			for (Log log: this.logs) {
				logMessages.add(log.toJSONString());
			}

			sendLogs(logMessages);

			this.logs.clear();
		}
	}

	/** An instance variable of our log cache */
	global static LogCache cache;

	/** Constructor for use with batching logs */
	global Loggly() {
		cache = new LogCache();
	}

	/** Adds a new log to our cache
	*
	* @param logValue The text message
	* @param logDate The date the event happened
	*/
	global void add(String logValue, DateTime logDate) {
		cache.add(new Log(logValue, logDate));
	}

	/** Adds a new log to our cache
	*
	* @param logValue The text message
	* @param logDate The date the event happened
	* @param logLevel The level of the log
	*/
	global void add(String logValue, DateTime logDate, String logLevel) {
		cache.add(new Log(logValue, logDate, logLevel));
	}

	/** Adds a new log to our cache
	*
	* @param logValue The text message
	* @param logDate The date the event happened
	* @param logLevel The level of the log
	* @param additionalValues Additional values to pass to loggly
	*/
	global void add(String logValue, DateTime logDate, String logLevel, Map<String, String> additionalValues) {
		cache.add(new Log(logValue, logDate, logLevel, additionalValues));
	}

	/** Flushes the logs to Loggly */
	global void flush() {
		cache.flushLogs();
	}

	/** Sends a single log to Loggly.
	*	This can be overridden by setting BATCH_LOGS to true
	*
	* @param logValue The text message
	* @param logDate The date the event happened
	* @param logLevel The level
	* @param additionalValues A map of key to values
	* @param logCache An existing logCache to add our messages to if BATCH_LOGS is true
	*/
	global static void singleLog(String logValue, DateTime logDate, String logLevel, Map<String, String> additionalValues, LogCache logCache) {
		Log log = new Log(logValue, logDate, logLevel, additionalValues);

		//If we are batching logs we want to override single log.  All calls
		//  should then be made through a class instance of loggly
		if (!BATCH_LOGS) {
			sendLogs(new Set<String>{log.toJSONString()});
		} else if (logCache != null) {
			logCache.add(log);
		} else if (Test.isRunningTest()) {
			TEST_NOCACHE = true;
		}
	}

	/** Sends a single log to Loggly.
	*	This can be overridden by setting BATCH_LOGS to true
	*
	* @param logValue The text message
	* @param logDate The date the event happened
	* @param logLevel The level
	* @param logCache An existing logCache to add our messages to if BATCH_LOGS is true
	*/
	global static void singleLog(String logValue, DateTime logDate, String logLevel, LogCache logCache) {
		singleLog(logValue, logDate, logLevel, null, logCache);
	}

	/** Sends a single log to Loggly.
	*	This can be overridden by setting BATCH_LOGS to true
	*
	* @param logValue The text message
	* @param logDate The date the event happened
	* @param logCache An existing logCache to add our messages to if BATCH_LOGS is true
	*/
	global static void singleLog(String logValue, DateTime logDate, LogCache logCache) {
		singleLog(logValue, logDate, null, null, logCache);
	}

	/** Sends a single log to Loggly
	*
	* @param logValue The text message
	*/
	global static void singleLog(String logValue) {
		singleLog(logValue, DateTime.now());
	}

	/** Sends a single log to Loggly
	*
	* @param logValue The text message
	* @param logDate The date the event happened
	*/
	global static void singleLog(String logValue, DateTime logDate) {
		singleLog(logValue, logDate, cache);
	}

	/** Sends a single log to Loggly
	*
	* @param logValue The text message
	* @param logDate The date the event happened
	* @param logLevel The level
	*/
	global static void singleLog(String logValue, DateTime logDate, String logLevel) {
		singleLog(logValue, logDate, logLevel, cache);
	}

	/** Sends a single log to Loggly
	*
	* @param logValue The text message
	* @param logDate The date the event happened
	* @param logLevel The level
	* @param additionalValues A map of key to values
	*/
	global static void singleLog(String logValue, DateTime logDate, String logLevel, Map<String, String> additionalValues) {
		singleLog(logValue, logDate, logLevel, additionalValues, cache);
	}

	/** Creates a log based on an exception to send to loggly
	*
	* @param except The exception to log
	*/
	global static void singleLog(Exception except) {
		singleLog(except, DateTime.now(), EXCEPTION_LEVEL);
	}

	/** Creates a log based on an exception to send to loggly
	*
	* @param except The exception to log
	* @param logDate The date teh event happened
	* @param logLevel The level
	*/
	global static void singleLog(Exception except, DateTime logDate, String logLevel) {
		Map<String, String> additionalValues = new Map<String, String>();
		additionalValues.put(EXCEPTION_TYPE_NAME, except.getTypeName());
		additionalValues.put(EXCEPTION_STACK_TRACE, except.getStackTraceString());
		singleLog(except.getMessage(), logDate, logLevel, additionalValues);
	}

	/** Sends the logs to Loggly
	*
	* @param logs A set of log messages (in JSON format) to send to endpoint
	*/
	@future (callout=true)
	global static void sendLogs(Set<String> logs) {
		List<String> logList = new List<String>();
		logList.addAll(logs);

		HttpResponse res = new HttpResponse();
		// Build up a newline-separated list of JSON messages to send to the endpoint
		String message = String.join(logList, '\n');

		try {
			HttpRequest req = new HttpRequest();

			if (THROW_TEST_EXCEPTION) {
				throw new TestException('Test exception');
			}

			req.setEndpoint(LOGGLY_ENDPOINT);
			req.setMethod('POST');
			req.setHeader('content-type', 'application/json');
			req.setBody(message);

			Http http = new Http();
			res = http.send(req);
		} catch (Exception e) {
			System.debug(e);
			System.debug(res.toString());
		}
	}

	/** Gets a url for the gif place holder image
	*
	* @param logValue The text message
	* @param logDate The date the event happened
	*/
	global static String gifUrl(String logValue, DateTime logDate) {
		return gifUrl(logValue, logDate, DEFAULT_LEVEL);
	}

	/** Gets a url for the gif place holder image
	*
	* @param logValue The text message
	* @param logDate The date the event happened
	* @param logLevel The level
	*/
	global static String gifUrl(String logValue, DateTime logDate, String logLevel) {
		return gifUrl(logValue, logDate, logLevel, null);
	}

	/** Gets a url for the gif place holder image
	*
	* @param logValue The text message
	* @param logDate The date the event happened
	* @param logLevel The level
	* @param additionalValues A map of keys to values to also be passed as json data
	*/
	global static String gifUrl(String logValue, DateTime logDate, String logLevel, Map<String, String> additionalValues) {
		Log log = new Log(logValue, logDate, logLevel, additionalValues);
		Map<String, String> keyValueMap = log.toKeyValueMap();

		PageReference pageRef = new PageReference(LOGGLY_ENDPOINT + '.gif');
		pageRef.getParameters().putAll(keyValueMap);

		return pageRef.getUrl();
	}
}