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
	private class TestException extends Exception {}

	global static String DEFAULT_LEVEL = 'INFO';
	global static String DATE_FORMAT = 'yyyy-MM-dd HH:mm:ss.SSSZ';
	global static String DEFAULT_SETTING_NAME = 'default';

	global static Boolean TEST_NOCACHE= false;

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
			Map<String, String> result = new Map<String, String>();

			if (INCLUDE_HOSTNAME && HOSTNAME != null) {
				result.put('host', HOSTNAME);
			}

			if (INCLUDE_USERINFO) {
				result.put('userid', UserInfo.getUserId());
				result.put('username', UserInfo.getUserName());
			}

			if (this.logLevel != null) {
				result.put('level', this.logLevel);
			}

			result.put('datetime', this.logDate.format(DATE_FORMAT));
			result.put('message', this.logValue);

			return JSON.serialize(result);
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

	global void add(String logValue, DateTime logDate, String logLevel) {
		cache.add(new Log(logValue, logDate, logLevel));
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
	* @param logCache An existing logCache to add our messages to if BATCH_LOGS is true
	*/
	global static void singleLog(String logValue, DateTime logDate, String logLevel, LogCache logCache) {
		Log log = new Log(logValue, logDate, logLevel);

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
	* @param logCache An existing logCache to add our messages to if BATCH_LOGS is true
	*/
	global static void singleLog(String logValue, DateTime logDate, LogCache logCache) {
		Log log = new Log(logValue, logDate);

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

	/** Sends the logs to Loggly
	*
	* @param logs A set of log messages (in JSON format) to send to endpoint
	*/
	@future (callout=true)
	global static void sendLogs(Set<String> logs) {
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
}