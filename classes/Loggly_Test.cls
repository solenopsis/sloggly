/** A class for writing to Loggly (Tests)
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

@isTest
public class Loggly_Test {
	static TestMethod void settingName_default_test() {
		System.assertEquals('default', Loggly.SETTING_NAME, 'Should get back "default"');
	}

	static TestMethod void settingName_set_test() {
		String settingName = '_unittest_name_';
		Loggly.SETTING_NAME = settingName;
		System.assertEquals(settingName, Loggly.SETTING_NAME, 'Should get back the set name');
	}

	static TestMethod void settings_test() {
		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		insert testSettings;

		Loggly.SETTING_NAME = settingName;

		Test.startTest();

		LogglySettings__c result = Loggly.SETTINGS;

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

		Loggly.SETTING_NAME = settingName;

		Test.startTest();

		System.assertEquals(endpoint, Loggly.LOGGLY_ENDPOINT, 'Did not get the right endpoint back');

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

		Loggly.SETTING_NAME = settingName;

		Test.startTest();

		System.assertEquals(hostname_val, Loggly.HOSTNAME, 'Did not get the right hostname back');

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

		Loggly.SETTING_NAME = settingName;

		Test.startTest();

		System.assert(Loggly.INCLUDE_HOSTNAME, 'Hostname should be included');

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

		Loggly.SETTING_NAME = settingName;

		Test.startTest();

		System.assert(!Loggly.INCLUDE_HOSTNAME, 'Hostname should not be included');

		Test.stopTest();
	}

	static TestMethod void include_hostname_null_test() {
		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		insert testSettings;

		Loggly.SETTING_NAME = settingName;

		Test.startTest();

		System.assert(!Loggly.INCLUDE_HOSTNAME, 'Hostname should not be included');

		Test.stopTest();
	}

	static TestMethod void include_hostname_override_test() {
		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		testSettings.Include_Hostname__c = true;
		insert testSettings;

		Loggly.SETTING_NAME = settingName;
		Loggly.INCLUDE_HOSTNAME = false;

		Test.startTest();

		System.assert(!Loggly.INCLUDE_HOSTNAME, 'Hostname should not be included');

		Test.stopTest();
	}

	static TestMethod void batch_logs_true_test() {
		Loggly.BATCH_LOGS = true;

		Test.startTest();

		System.assert(Loggly.BATCH_LOGS, 'We should be batching logs');

		Test.stopTest();
	}

	static TestMethod void batch_logs_false_test() {
		Loggly.BATCH_LOGS = false;

		Test.startTest();

		System.assert(!Loggly.BATCH_LOGS, 'We should not be batching logs');

		Test.stopTest();
	}

	static TestMethod void batch_logs_null_test() {
		Test.startTest();

		System.assert(!Loggly.BATCH_LOGS, 'We should not be batching logs');

		Test.stopTest();
	}

	static TestMethod void log_constructor_blank_test() {
		Test.startTest();

		Loggly.Log testLog = new Loggly.Log();

		Test.stopTest();

		System.assertEquals(null, testLog.logValue, 'Log value should default to null');
		System.assertEquals(null, testLog.logDate, 'Log date should default to null');
		System.assertEquals(null, testLog.logLevel, 'Log level should default to null');
	}

	static TestMethod void log_constructor_single_test() {
		String testValue = '_unittest_value_';

		Test.startTest();

		Loggly.Log testLog = new Loggly.Log(testValue);

		Test.stopTest();

		System.assertEquals(testValue, testLog.logValue, 'Log value does not equal');
		System.assertNotEquals(null, testLog.logDate, 'Log date should be set');
		System.assertEquals(Loggly.DEFAULT_LEVEL, testLog.logLevel, 'Log level does not equal');
	}

	static TestMethod void log_constructor_double_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();

		Test.startTest();

		Loggly.Log testLog = new Loggly.Log(testValue, testDate);

		Test.stopTest();

		System.assertEquals(testValue, testLog.logValue, 'Log value does not equal');
		System.assertEquals(testDAte, testLog.logDate, 'Log date should does not equal');
		System.assertEquals(Loggly.DEFAULT_LEVEL, testLog.logLevel, 'Log level does not equal');
	}

	static TestMethod void log_constructor_triple_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();
		String testLevel = '_unittest_level_';

		Test.startTest();

		Loggly.Log testLog = new Loggly.Log(testValue, testDate, testLevel);

		Test.stopTest();

		System.assertEquals(testValue, testLog.logValue, 'Log value does not equal');
		System.assertEquals(testDate, testLog.logDate, 'Log date does not equal');
		System.assertEquals(testLevel, testLog.logLevel, 'Log level does not equal');
	}

	static testMethod void log_toJSONString_noHostname_noLevel_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();
		String testLevel = null;

		Loggly.Log testLog = new Loggly.Log(testValue, testDate, testLevel);

		Test.startTest();

		String result = testLog.toJSONString();

		Test.stopTest();

		String host = null;
		Boolean gotHost = false;
		String level = null;
		Boolean gotLevel = false;
		String formattedDatetime = null;
		Boolean gotDatetime = false;
		String message = null;
		Boolean gotMessage = false;

		JSONParser parser = JSON.createParser(result);

		while (parser.nextToken() != null) {
			if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
				if (parser.getText() == 'host') {
					gotHost = true;
					parser.nextToken();
					host = parser.getText();
				} else if (parser.getText() == 'level') {
					gotLevel = true;
					parser.nextToken();
					level = parser.getText();
				} else if (parser.getText() == 'datetime') {
					gotDatetime = true;
					parser.nextToken();
					formattedDatetime = parser.getText();
					System.assertEquals(testDate.format(Loggly.DATE_FORMAT), formattedDatetime, 'Did not get the correct date back');
				} else if (parser.getText() == 'message') {
					gotMessage = true;
					parser.nextToken();
					message = parser.getText();
					System.assertEquals(testValue, message, 'Did not get the correct message back');
				}
			}
		}

		System.assert(!gotHost, 'Got hostname back in response ['+host+']');
		System.assert(!gotLevel, 'Got level back in response ['+level+']');
		System.assert(gotDatetime, 'Did not get the datetime back in response ['+formattedDatetime+']');
		System.assert(gotMessage, 'Did not get the message back in response ['+message+']');
	}

	static testMethod void log_toJSONString_noHostname_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();
		String testLevel = 'ERROR';

		Loggly.Log testLog = new Loggly.Log(testValue, testDate, testLevel);

		Test.startTest();

		String result = testLog.toJSONString();

		Test.stopTest();

		String host = null;
		Boolean gotHost = false;
		String level = null;
		Boolean gotLevel = false;
		String formattedDatetime = null;
		Boolean gotDatetime = false;
		String message = null;
		Boolean gotMessage = false;

		JSONParser parser = JSON.createParser(result);

		while (parser.nextToken() != null) {
			if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
				if (parser.getText() == 'host') {
					gotHost = true;
					parser.nextToken();
					host = parser.getText();
				} else if (parser.getText() == 'level') {
					gotLevel = true;
					parser.nextToken();
					level = parser.getText();
					System.assertEquals(testLevel, level, 'Did not get the correct level back');
				} else if (parser.getText() == 'datetime') {
					gotDatetime = true;
					parser.nextToken();
					formattedDatetime = parser.getText();
					System.assertEquals(testDate.format(Loggly.DATE_FORMAT), formattedDatetime, 'Did not get the correct date back');
				} else if (parser.getText() == 'message') {
					gotMessage = true;
					parser.nextToken();
					message = parser.getText();
					System.assertEquals(testValue, message, 'Did not get the correct message back');
				}
			}
		}

		System.assert(!gotHost, 'Got hostname back in response ['+host+']');
		System.assert(gotLevel, 'Did not get the level back in response ['+level+']');
		System.assert(gotDatetime, 'Did not get the datetime back in response ['+formattedDatetime+']');
		System.assert(gotMessage, 'Did not get the message back in response ['+message+']');
	}

	static testMethod void log_toJSONString_noLevel_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();
		String testLevel = null;
		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';
		String hostname_val = '_unitest_hostname_';

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		testSettings.Hostname__c = hostname_val;
		testSettings.Include_Hostname__c = true;
		insert testSettings;

		Loggly.SETTING_NAME = settingName;

		Loggly.Log testLog = new Loggly.Log(testValue, testDate, testLevel);

		Test.startTest();

		String result = testLog.toJSONString();

		Test.stopTest();

		String host = null;
		Boolean gotHost = false;
		String level = null;
		Boolean gotLevel = false;
		String formattedDatetime = null;
		Boolean gotDatetime = false;
		String message = null;
		Boolean gotMessage = false;

		JSONParser parser = JSON.createParser(result);

		while (parser.nextToken() != null) {
			if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
				if (parser.getText() == 'host') {
					gotHost = true;
					parser.nextToken();
					host = parser.getText();
					System.assertEquals(hostname_val, host, 'Did not get the correct hostname back');
				} else if (parser.getText() == 'level') {
					gotLevel = true;
					parser.nextToken();
					level = parser.getText();
				} else if (parser.getText() == 'datetime') {
					gotDatetime = true;
					parser.nextToken();
					formattedDatetime = parser.getText();
					System.assertEquals(testDate.format(Loggly.DATE_FORMAT), formattedDatetime, 'Did not get the correct date back');
				} else if (parser.getText() == 'message') {
					gotMessage = true;
					parser.nextToken();
					message = parser.getText();
					System.assertEquals(testValue, message, 'Did not get the correct message back');
				}
			}
		}

		System.assert(gotHost, 'Did not get the hostname back in response ['+host+']');
		System.assert(!gotLevel, 'Got level back in response ['+level+']');
		System.assert(gotDatetime, 'Did not get the datetime back in response ['+formattedDatetime+']');
		System.assert(gotMessage, 'Did not get the message back in response ['+message+']');
	}

	static testMethod void log_toJSONString_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();
		String testLevel = 'ERROR';
		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';
		String hostname_val = '_unitest_hostname_';

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		testSettings.Hostname__c = hostname_val;
		testSettings.Include_Hostname__c = true;
		insert testSettings;

		Loggly.SETTING_NAME = settingName;

		Loggly.Log testLog = new Loggly.Log(testValue, testDate, testLevel);

		Test.startTest();

		String result = testLog.toJSONString();

		Test.stopTest();

		String host = null;
		Boolean gotHost = false;
		String level = null;
		Boolean gotLevel = false;
		String formattedDatetime = null;
		Boolean gotDatetime = false;
		String message = null;
		Boolean gotMessage = false;

		JSONParser parser = JSON.createParser(result);

		while (parser.nextToken() != null) {
			if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
				if (parser.getText() == 'host') {
					gotHost = true;
					parser.nextToken();
					host = parser.getText();
					System.assertEquals(hostname_val, host, 'Did not get the correct hostname back');
				} else if (parser.getText() == 'level') {
					gotLevel = true;
					parser.nextToken();
					level = parser.getText();
					System.assertEquals(testLevel, level, 'Did not get the correct level back');
				} else if (parser.getText() == 'datetime') {
					gotDatetime = true;
					parser.nextToken();
					formattedDatetime = parser.getText();
					System.assertEquals(testDate.format(Loggly.DATE_FORMAT), formattedDatetime, 'Did not get the correct date back');
				} else if (parser.getText() == 'message') {
					gotMessage = true;
					parser.nextToken();
					message = parser.getText();
					System.assertEquals(testValue, message, 'Did not get the correct message back');
				}
			}
		}

		System.assert(gotHost, 'Did not get the hostname back in response ['+host+']');
		System.assert(gotLevel, 'Did not get level back in response ['+level+']');
		System.assert(gotDatetime, 'Did not get the datetime back in response ['+formattedDatetime+']');
		System.assert(gotMessage, 'Did not get the message back in response ['+message+']');
	}

	static testMethod void logCache_constructor_empty_test() {
		Test.startTest();

		Loggly.LogCache result = new Loggly.LogCache();

		Test.stopTest();

		System.assert(result.logs.isEmpty(), 'The initial cache should be empty');
	}

	static testMethod void logCache_constructor_log_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();
		String testLevel = 'ERROR';

		Loggly.Log testLog = new Loggly.Log(testValue, testDate, testLevel);

		Test.startTest();

		Loggly.LogCache result = new Loggly.LogCache(testLog);

		Test.stopTest();

		System.assertEquals(1, result.logs.size(), 'The initial cache should contain a log');
		System.assertEquals(testValue, result.logs.get(0).logValue, 'Did not get the expect log back');
	}

	static testMethod void logCache_constructor_list_test() {
		String testValue1 = '_unittest_value_1';
		Loggly.Log testLog1 = new Loggly.Log(testValue1);

		String testValue2 = '_unittest_value_2';
		Loggly.Log testLog2 = new Loggly.Log(testValue2);

		List<Loggly.Log> testLogs = new List<Loggly.Log>{testLog1, testLog2};

		Test.startTest();

		Loggly.LogCache result = new Loggly.LogCache(testLogs);

		Test.stopTest();

		System.assertEquals(testLogs.size(), result.logs.size(), 'Did not get the expected number of logs back');

		Boolean gotLog1 = false;
		Boolean gotLog2 = false;

		for (Loggly.Log l: result.logs) {
			if (l.logValue == testValue1) {
				gotLog1 = true;
			} else if (l.logValue == testValue2) {
				gotLog2 = true;
			} else {
				System.assert(false, 'Got a log we did not expect ['+l.logValue+']');
			}
		}

		System.assert(gotLog1, 'Did not get the first log back');
		System.assert(gotLog2, 'Did not get the second log back');
	}

	static testMethod void logCache_add_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();
		String testLevel = 'ERROR';

		Loggly.Log testLog = new Loggly.Log(testValue, testDate, testLevel);
		Loggly.LogCache testCache = new Loggly.LogCache();

		Test.startTest();

		testCache.add(testLog);

		Test.stopTest();

		System.assertEquals(1, testCache.logs.size(), 'The cache should contain a log');
		System.assertEquals(testValue, testCache.logs.get(0).logValue, 'Did not get the expect log back');
	}

	static testMethod void logCache_flushLogs_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();
		String testLevel = 'ERROR';
		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';
		String hostname_val = '_unitest_hostname_';

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		testSettings.Hostname__c = hostname_val;
		insert testSettings;

		Loggly.SETTING_NAME = settingName;

		Loggly.Log testLog = new Loggly.Log(testValue, testDate, testLevel);
		Loggly.LogCache testCache = new Loggly.LogCache(testLog);

		Test.startTest();

		// Don't have a good way to really test this outside of checking to make
		//  sure it doesn't throw exceptions and that it clears out the log list
		testCache.flushLogs();

		Test.stopTest();

		System.assert(testCache.logs.isEmpty(), 'The cache should be empty by now');
	}

	static testMethod void logCache_flushLogs_multi_test() {
		String testValue1 = '_unittest_value_: 001';
		DateTime testDate1 = DateTime.now();

		String testValue2 = '_unittest_value_: 002';
		DateTime testDate2 = DateTime.now();

		String testLevel = 'ERROR';
		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';
		String hostname_val = '_unitest_hostname_';

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		testSettings.Hostname__c = hostname_val;
		insert testSettings;

		Loggly.SETTING_NAME = settingName;

		Loggly.Log testLog1 = new Loggly.Log(testValue1, testDate1, testLevel);
		Loggly.Log testLog2 = new Loggly.Log(testValue2, testDate2, testLevel);
		Loggly.LogCache testCache = new Loggly.LogCache(new List<Loggly.Log>{testLog1, testLog2});

		Test.startTest();

		// Don't have a good way to really test this outside of checking to make
		//  sure it doesn't throw exceptions and that it clears out the log list
		testCache.flushLogs();

		Test.stopTest();

		System.assert(testCache.logs.isEmpty(), 'The cache should be empty by now');
	}

	static testMethod void loggly_constructor_empty_test() {
		Test.startTest();

		Loggly testLoggly = new Loggly();

		Test.stopTest();

		System.assertNotEquals(null, Loggly.cache, 'Inital cache should not be null');
	}

	static testMethod void loggly_add_double_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();

		Loggly testLoggly = new Loggly();

		Test.startTest();

		testLoggly.add(testValue, testDate);

		Test.stopTest();

		System.assertEquals(1, Loggly.cache.logs.size(), 'Does not have the correct number of logs in the cache');
		System.assertEquals(testValue, Loggly.cache.logs.get(0).logValue, 'Did not get the right log back');
	}

	static testMethod void loggly_add_triple_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();
		String testLevel = 'ERROR';

		Loggly testLoggly = new Loggly();

		Test.startTest();

		testLoggly.add(testValue, testDate, testLevel);

		Test.stopTest();

		System.assertEquals(1, Loggly.cache.logs.size(), 'Does not have the correct number of logs in the cache');
		System.assertEquals(testValue, Loggly.cache.logs.get(0).logValue, 'Did not get the right log back');
	}

	static testMethod void loggly_flush_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();

		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';
		String hostname_val = '_unitest_hostname_';

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		testSettings.Hostname__c = hostname_val;
		insert testSettings;

		Loggly.SETTING_NAME = settingName;

		Loggly testLoggly = new Loggly();
		testLoggly.add(testValue, testDate);

		Test.startTest();

		testLoggly.flush();

		Test.stopTest();

		System.assertEquals(0, Loggly.cache.logs.size(), 'Does not have the correct number of logs in the cache');
	}

	static testMethod void loggly_singleLog_quad_noBatch_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();
		String testLevel = 'ERROR';

		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';
		String hostname_val = '_unitest_hostname_';

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		testSettings.Hostname__c = hostname_val;
		insert testSettings;

		Loggly.SETTING_NAME = settingName;

		Loggly.LogCache testCache = new Loggly.LogCache();

		Test.startTest();

		Loggly.singleLog(testValue, testDate, testLevel, testCache);

		Test.stopTest();

		System.assert(testCache.logs.isEmpty(), 'Cache should still be empty since we are not batching');
	}

	static testMethod void loggly_singleLog_quad_noCache_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();
		String testLevel = 'ERROR';

		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';
		String hostname_val = '_unitest_hostname_';

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		testSettings.Hostname__c = hostname_val;
		insert testSettings;

		Loggly.SETTING_NAME = settingName;
		Loggly.BATCH_LOGS = true;

		Loggly.LogCache testCache = null; 

		Test.startTest();

		Loggly.singleLog(testValue, testDate, testLevel, testCache);

		Test.stopTest();
	}

	static testMethod void loggly_singleLog_quad_cache_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();
		String testLevel = 'ERROR';

		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';
		String hostname_val = '_unitest_hostname_';

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		testSettings.Hostname__c = hostname_val;
		insert testSettings;

		Loggly.SETTING_NAME = settingName;
		Loggly.BATCH_LOGS = true;

		Loggly.LogCache testCache = new Loggly.LogCache(); 

		Test.startTest();

		Loggly.singleLog(testValue, testDate, testLevel, testCache);

		Test.stopTest();

		System.assertEquals(1, testCache.logs.size(), 'Log did not get added to the cache');
		System.assertEquals(testValue, testCache.logs.get(0).logValue, 'Did not get the correct log value');
	}

	static testMethod void loggly_singleLog_triple_level_noBatch_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();
		String testLevel = 'ERROR';

		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';
		String hostname_val = '_unitest_hostname_';

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		testSettings.Hostname__c = hostname_val;
		insert testSettings;

		Loggly.SETTING_NAME = settingName;

		Test.startTest();

		Loggly.singleLog(testValue, testDate, testLevel);

		Test.stopTest();

		System.assertEquals(null, Loggly.cache, 'Cache should still be empty since we are not batching');
	}

	static testMethod void loggly_singleLog_triple_level_noCache_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();
		String testLevel = 'ERROR';

		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';
		String hostname_val = '_unitest_hostname_';

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		testSettings.Hostname__c = hostname_val;
		insert testSettings;

		Loggly.SETTING_NAME = settingName;
		Loggly.BATCH_LOGS = true;

		Test.startTest();

		Loggly.singleLog(testValue, testDate, testLevel);

		Test.stopTest();
	}

	static testMethod void loggly_singleLog_triple_level_cache_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();
		String testLevel = 'ERROR';

		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';
		String hostname_val = '_unitest_hostname_';

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		testSettings.Hostname__c = hostname_val;
		insert testSettings;

		Loggly.SETTING_NAME = settingName;
		Loggly.BATCH_LOGS = true;

		Loggly testLoggly = new Loggly();

		Test.startTest();

		Loggly.singleLog(testValue, testDate, testLevel);

		Test.stopTest();

		System.assertEquals(1, Loggly.cache.logs.size(), 'Log did not get added to the cache');
		System.assertEquals(testValue, Loggly.cache.logs.get(0).logValue, 'Did not get the correct log value');
	}

	static testMethod void loggly_singleLog_triple_cache_noBatch_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();

		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';
		String hostname_val = '_unitest_hostname_';

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		testSettings.Hostname__c = hostname_val;
		insert testSettings;

		Loggly.SETTING_NAME = settingName;

		Loggly.LogCache testCache = new Loggly.LogCache();

		Test.startTest();

		Loggly.singleLog(testValue, testDate, testCache);

		Test.stopTest();

		System.assert(testCache.logs.isEmpty(), 'Cache should still be empty since we are not batching');
	}

	static testMethod void loggly_singleLog_triple_cache_noCache_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();

		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';
		String hostname_val = '_unitest_hostname_';

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		testSettings.Hostname__c = hostname_val;
		insert testSettings;

		Loggly.SETTING_NAME = settingName;
		Loggly.BATCH_LOGS = true;

		Loggly.LogCache testCache = null; 

		Test.startTest();

		Loggly.singleLog(testValue, testDate, testCache);

		Test.stopTest();
	}

	static testMethod void loggly_singleLog_triple_cache_cache_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();

		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';
		String hostname_val = '_unitest_hostname_';

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		testSettings.Hostname__c = hostname_val;
		insert testSettings;

		Loggly.SETTING_NAME = settingName;
		Loggly.BATCH_LOGS = true;

		Loggly.LogCache testCache = new Loggly.LogCache(); 

		Test.startTest();

		Loggly.singleLog(testValue, testDate, testCache);

		Test.stopTest();

		System.assertEquals(1, testCache.logs.size(), 'Log did not get added to the cache');
		System.assertEquals(testValue, testCache.logs.get(0).logValue, 'Did not get the correct log value');
	}

	static testMethod void loggly_singleLog_double_noBatch_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();

		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';
		String hostname_val = '_unitest_hostname_';

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		testSettings.Hostname__c = hostname_val;
		insert testSettings;

		Loggly.SETTING_NAME = settingName;

		Test.startTest();

		Loggly.singleLog(testValue, testDate);

		Test.stopTest();

		System.assertEquals(null, Loggly.cache, 'Cache should still be empty since we are not batching');
	}

	static testMethod void loggly_singleLog_double_noCache_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();

		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';
		String hostname_val = '_unitest_hostname_';

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		testSettings.Hostname__c = hostname_val;
		insert testSettings;

		Loggly.SETTING_NAME = settingName;
		Loggly.BATCH_LOGS = true;

		Test.startTest();

		Loggly.singleLog(testValue, testDate);

		Test.stopTest();
	}

	static testMethod void loggly_singleLog_double_cache_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();

		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';
		String hostname_val = '_unitest_hostname_';

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		testSettings.Hostname__c = hostname_val;
		insert testSettings;

		Loggly.SETTING_NAME = settingName;
		Loggly.BATCH_LOGS = true;

		Loggly testLoggly = new Loggly();

		Test.startTest();

		Loggly.singleLog(testValue, testDate);

		Test.stopTest();

		System.assertEquals(1, Loggly.cache.logs.size(), 'Log did not get added to the cache');
		System.assertEquals(testValue, Loggly.cache.logs.get(0).logValue, 'Did not get the correct log value');
	}

	static testMethod void loggly_singleLog_exception_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();
		String testLevel = 'ERROR';

		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';
		String hostname_val = '_unitest_hostname_';

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		testSettings.Hostname__c = hostname_val;
		insert testSettings;

		Loggly.SETTING_NAME = settingName;
		Loggly.THROW_TEST_EXCEPTION = true;

		Test.startTest();

		Loggly.singleLog(testValue, testDate, testLevel);

		Test.stopTest();

		System.assertEquals(null, Loggly.cache, 'Cache should still be empty since we are not batching');
	}

	static testMethod void controller_setters_test() {
		String newDefault = '_default_loggly_';
		String endpoint = 'test://myurl';
		String hostname_val = '_unitest_hostname_';

		Test.startTest();

		Loggly.DEFAULT_SETTING_NAME = newDefault;

		PageReference p = Page.Loggly_Configure;
		Test.setCurrentPage(p);
		Loggly_Configure_Controller controller = new Loggly_Configure_Controller();

		controller.setEndpoint(endpoint);
		controller.setHostname(hostname_val);
		controller.setIncludeHostname(true);

		System.assertEquals(newDefault, controller.getRecordName(), 'Did not get the right name back');
		System.assertEquals(endpoint, controller.getEndpoint(), 'Did not get the same endpoint back');
		System.assertEquals(hostname_val, controller.getHostname(), 'Did not get the same hostname back');
		System.assert(controller.getIncludeHostname(), 'Did not get the same include hostname back');

		Test.stopTest();
	}

	static testMethod void controller_test() {
		String newDefault = '_default_loggly_';
		String endpoint = 'test://myurl';
		String hostname_val = '_unitest_hostname_';

		//This is kind of lame, but we have to do this to make sure that it
		//  does not fail because the default has already been created
		Loggly.DEFAULT_SETTING_NAME = newDefault;

		Test.startTest();

		PageReference p = Page.Loggly_Configure;
		Test.setCurrentPage(p);
		Loggly_Configure_Controller controller = new Loggly_Configure_Controller();

		controller.setEndpoint(endpoint);
		controller.setHostname(hostname_val);
		controller.setIncludeHostname(true);

		controller.create();

		Test.stopTest();

		LogglySettings__c result = [
			select Endpoint__c,
				Hostname__c,
				Include_Hostname__c,
				Name
			from LogglySettings__c
			where Name = :newDefault
		];

		System.assertEquals(newDefault, result.Name, 'Did not get the right name back');
		System.assertEquals(endpoint, result.Endpoint__c, 'Did not get the right endpoint');
		System.assertEquals(hostname_val, result.Hostname__c, 'Did not get the right hostname');
		System.assert(result.Include_Hostname__c, 'Did not get the right include hostname');
	}

	static testMethod void controller_nohostname_test() {
		String newDefault = '_default_loggly_';
		String endpoint = 'test://myurl';
		String hostname_val = '_unitest_hostname_';

		//This is kind of lame, but we have to do this to make sure that it
		//  does not fail because the default has already been created
		Loggly.DEFAULT_SETTING_NAME = newDefault;

		Test.startTest();

		PageReference p = Page.Loggly_Configure;
		Test.setCurrentPage(p);
		Loggly_Configure_Controller controller = new Loggly_Configure_Controller();

		controller.setEndpoint(endpoint);
		controller.setIncludeHostname(true);

		controller.create();

		Test.stopTest();

		List<ApexPages.Message> messages = ApexPages.getMessages();

		System.assertEquals(1, messages.size(), 'Did not get the right number of messages');
		System.assertEquals(Loggly_Configure_Controller.MESSAGE_INCLUDE_HOSTNAME, messages.get(0).getSummary(), 'Did not get the right summary');

		try {
			LogglySettings__c result = [
				select Endpoint__c,
					Hostname__c,
					Include_Hostname__c,
					Name
				from LogglySettings__c
				where Name = :newDefault
			];
			System.assert(false, 'We should not have gotten this far.');
		} catch (System.QueryException e) {
			System.assert(true, 'Got the exception we expected');
		} catch (Exception e) {
			System.assert(false, 'Got an exception we did not expect [' + e.getTypeName() + ': ' + e.getMessage() + ']');
		}
	}
}