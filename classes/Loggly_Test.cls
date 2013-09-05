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
		System.assertEquals(Loggly.DEFAULT_SETTING_NAME, Loggly.SETTING_NAME, 'Should get back "default"');
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

	static TestMethod void include_userinfo_true_test() {
		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		testSettings.Include_Userinfo__c = true;
		insert testSettings;

		Loggly.SETTING_NAME = settingName;

		Test.startTest();

		System.assert(Loggly.INCLUDE_USERINFO, 'Userinfo should be included');

		Test.stopTest();
	}

	static TestMethod void include_userinfo_false_test() {
		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		testSettings.Include_Userinfo__c = false;
		insert testSettings;

		Loggly.SETTING_NAME = settingName;

		Test.startTest();

		System.assert(!Loggly.INCLUDE_USERINFO, 'Userinfo should not be included');

		Test.stopTest();
	}

	static TestMethod void include_userinfo_null_test() {
		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		insert testSettings;

		Loggly.SETTING_NAME = settingName;

		Test.startTest();

		System.assert(!Loggly.INCLUDE_USERINFO, 'Userinfo should not be included');

		Test.stopTest();
	}

	static TestMethod void include_userinfo_override_test() {
		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		testSettings.Include_Userinfo__c = true;
		insert testSettings;

		Loggly.SETTING_NAME = settingName;
		Loggly.INCLUDE_USERINFO = false;

		Test.startTest();

		System.assert(!Loggly.INCLUDE_USERINFO, 'Userinfo should not be included');

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
		System.assertEquals(null, testLog.additionalValues, 'Additional values should be null');
	}

	static TestMethod void log_constructor_single_test() {
		String testValue = '_unittest_value_';

		Test.startTest();

		Loggly.Log testLog = new Loggly.Log(testValue);

		Test.stopTest();

		System.assertEquals(testValue, testLog.logValue, 'Log value does not equal');
		System.assertNotEquals(null, testLog.logDate, 'Log date should be set');
		System.assertEquals(Loggly.DEFAULT_LEVEL, testLog.logLevel, 'Log level does not equal');
		System.assertEquals(null, testLog.additionalValues, 'Additional values should be null');
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
		System.assertEquals(null, testLog.additionalValues, 'Additional values should be null');
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
		System.assertEquals(null, testLog.additionalValues, 'Additional values should be null');
	}

	static TestMethod void log_constructor_quad_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();
		String testLevel = '_unittest_level_';
		String testKey = '_unittest_key_';
		String testData = '_unittest_data_';

		Map<String, String> testAdditionalValues = new Map<String, String>{ testKey => testData };

		Test.startTest();

		Loggly.Log testLog = new Loggly.Log(testValue, testDate, testLevel, testAdditionalValues);

		Test.stopTest();

		System.assertEquals(testValue, testLog.logValue, 'Log value does not equal');
		System.assertEquals(testDate, testLog.logDate, 'Log date does not equal');
		System.assertEquals(testLevel, testLog.logLevel, 'Log level does not equal');
		System.assertEquals(1, testLog.additionalValues.size(), 'Incorrect number of additional values');
		System.assertEquals(testData, testLog.additionalValues.get(testKey), 'Incorrect data for key');
	}


	static testMethod void log_toJSONString_noHostname_noLevel_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();
		String testLevel = null;

		Loggly.Log testLog = new Loggly.Log(testValue, testDate, testLevel);

		Test.startTest();

		String result = testLog.toJSONString();

		Test.stopTest();

		Map<String, String> correctResponses = new Map<String, String>{
			Loggly.KEY_DATETIME => testDate.format(Loggly.DATE_FORMAT),
			Loggly.KEY_MESSAGE => testValue
		};

		Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(result);

		for (String key: correctResponses.keySet()) {
			if (!jsonMap.containsKey(key)) {
				System.assert(false, 'Did not get the ' + key + ' back in response');
			}

			System.assertEquals(correctResponses.get(key), (String) jsonMap.get(key), 'Did not get the correct value back for ' + key);
			jsonMap.remove(key);
		}

		System.assert(jsonMap.isEmpty(), 'Got additional data back [' + jsonMap.keySet() + ']');
	}

	static testMethod void log_toJSONString_noHostname_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();
		String testLevel = 'ERROR';

		Loggly.Log testLog = new Loggly.Log(testValue, testDate, testLevel);

		Test.startTest();

		String result = testLog.toJSONString();

		Test.stopTest();

		Map<String, String> correctResponses = new Map<String, String>{
			Loggly.KEY_LEVEL => testLevel,
			Loggly.KEY_DATETIME => testDate.format(Loggly.DATE_FORMAT),
			Loggly.KEY_MESSAGE => testValue
		};

		Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(result);

		for (String key: correctResponses.keySet()) {
			if (!jsonMap.containsKey(key)) {
				System.assert(false, 'Did not get the ' + key + ' back in response');
			}

			System.assertEquals(correctResponses.get(key), (String) jsonMap.get(key), 'Did not get the correct value back for ' + key);
			jsonMap.remove(key);
		}

		System.assert(jsonMap.isEmpty(), 'Got additional data back [' + jsonMap.keySet() + ']');
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

		Map<String, String> correctResponses = new Map<String, String>{
			Loggly.KEY_HOST => hostname_val,
			Loggly.KEY_DATETIME => testDate.format(Loggly.DATE_FORMAT),
			Loggly.KEY_MESSAGE => testValue
		};

		Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(result);

		for (String key: correctResponses.keySet()) {
			if (!jsonMap.containsKey(key)) {
				System.assert(false, 'Did not get the ' + key + ' back in response');
			}

			System.assertEquals(correctResponses.get(key), (String) jsonMap.get(key), 'Did not get the correct value back for ' + key);
			jsonMap.remove(key);
		}

		System.assert(jsonMap.isEmpty(), 'Got additional data back [' + jsonMap.keySet() + ']');
	}

	static testMethod void log_toJSONString_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();
		String testLevel = 'ERROR';
		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';
		String hostname_val = '_unittest_hostname_';
		String testKey = '_unittest_key_';
		String testData = '_unittest_data_';

		Map<String, String> testAdditionalValues = new Map<String, String>{ testKey => testData };

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		testSettings.Hostname__c = hostname_val;
		testSettings.Include_Hostname__c = true;
		testSettings.Include_Userinfo__c = true;
		insert testSettings;

		Loggly.SETTING_NAME = settingName;

		Loggly.Log testLog = new Loggly.Log(testValue, testDate, testLevel, testAdditionalValues);

		Test.startTest();

		String result = testLog.toJSONString();

		Test.stopTest();

		Map<String, String> correctResponses = new Map<String, String>{
			Loggly.KEY_HOST => hostname_val,
			Loggly.KEY_LEVEL => testLevel,
			Loggly.KEY_DATETIME => testDate.format(Loggly.DATE_FORMAT),
			Loggly.KEY_USERID => UserInfo.getUserId(),
			Loggly.KEY_USERNAME => UserInfo.getUserName(),
			Loggly.KEY_MESSAGE => testValue,
			testKey => testData
		};

		Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(result);

		for (String key: correctResponses.keySet()) {
			if (!jsonMap.containsKey(key)) {
				System.assert(false, 'Did not get the ' + key + ' back in response');
			}

			System.assertEquals(correctResponses.get(key), (String) jsonMap.get(key), 'Did not get the correct value back for ' + key);
			jsonMap.remove(key);
		}

		System.assert(jsonMap.isEmpty(), 'Got additional data back [' + jsonMap.keySet() + ']');
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

	static testMethod void loggly_add_quad_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();
		String testLevel = 'ERROR';
		String testKey = '_unittest_key_';
		String testData = '_unittest_data_';

		Map<String, String> testAdditionalValues = new Map<String, String>{ testKey => testData };

		Loggly testLoggly = new Loggly();

		Test.startTest();

		testLoggly.add(testValue, testDate, testLevel, testAdditionalValues);

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

	static testMethod void loggly_flush_empty_test() {
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

		Test.startTest();

		testLoggly.flush();

		Test.stopTest();

		System.assertEquals(0, Loggly.cache.logs.size(), 'Does not have the correct number of logs in the cache');
	}

	static testMethod void loggly_singleLog_quint_noBatch_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();
		String testLevel = 'ERROR';
		String testKey = '_unittest_key_';
		String testData = '_unittest_data_';

		Map<String, String> testAdditionalValues = new Map<String, String>{ testKey => testData };

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

		Loggly.singleLog(testValue, testDate, testLevel, testAdditionalValues, testCache);

		Test.stopTest();

		System.assert(testCache.logs.isEmpty(), 'Cache should still be empty since we are not batching');
	}

	static testMethod void loggly_singleLog_quint_noCache_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();
		String testLevel = 'ERROR';
		String testKey = '_unittest_key_';
		String testData = '_unittest_data_';

		Map<String, String> testAdditionalValues = new Map<String, String>{ testKey => testData };

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

		Loggly.singleLog(testValue, testDate, testLevel, testAdditionalValues);

		Test.stopTest();

		System.assert(Loggly.TEST_NOCACHE, 'Did not have a cache');
	}

	static testMethod void loggly_singleLog_quint_cache_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();
		String testLevel = 'ERROR';
		String testKey = '_unittest_key_';
		String testData = '_unittest_data_';

		Map<String, String> testAdditionalValues = new Map<String, String>{ testKey => testData };

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

		Loggly.singleLog(testValue, testDate, testLevel, testAdditionalValues, testCache);

		Test.stopTest();

		System.assertEquals(1, testCache.logs.size(), 'Log did not get added to the cache');
		System.assertEquals(testValue, testCache.logs.get(0).logValue, 'Did not get the correct log value');
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

		System.assert(Loggly.TEST_NOCACHE, 'Did not have a cache');
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

		System.assert(Loggly.TEST_NOCACHE, 'Did not have a cache');
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

		System.assert(Loggly.TEST_NOCACHE, 'Did not have a cache');
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

		System.assert(Loggly.TEST_NOCACHE, 'Did not have a cache');
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

	static testMethod void loggly_singleLog_single_noBatch_test() {
		String testValue = '_unittest_value_';

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

		Loggly.singleLog(testValue);

		Test.stopTest();

		System.assertEquals(null, Loggly.cache, 'Cache should still be empty since we are not batching');
	}

	static testMethod void loggly_singleLog_single_noCache_test() {
		String testValue = '_unittest_value_';

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

		Loggly.singleLog(testValue);

		Test.stopTest();

		System.assert(Loggly.TEST_NOCACHE, 'Did not have a cache');
	}

	static testMethod void loggly_singleLog_single_cache_test() {
		String testValue = '_unittest_value_';

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

		Loggly.singleLog(testValue);

		Test.stopTest();

		System.assertEquals(1, Loggly.cache.logs.size(), 'Log did not get added to the cache');
		System.assertEquals(testValue, Loggly.cache.logs.get(0).logValue, 'Did not get the correct log value');
	}

	static testMethod void loggly_singleLog_exception_noBatch_test() {
		String testValue = '_unittest_value_';
		Exception e = new Loggly.TestException(testValue);

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

		Loggly.singleLog(e);

		Test.stopTest();

		System.assertEquals(null, Loggly.cache, 'Cache should still be empty since we are not batching');
	}

	static testMethod void loggly_singleLog_exception_noCache_test() {
		String testValue = '_unittest_value_';
		Exception e = new Loggly.TestException(testValue);

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

		Loggly.singleLog(e);

		Test.stopTest();

		System.assert(Loggly.TEST_NOCACHE, 'Did not have a cache');
	}

	static testMethod void loggly_singleLog_exception_cache_test() {
		String testValue = '_unittest_value_';
		Exception e = new Loggly.TestException(testValue);

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

		Loggly.singleLog(e);

		Test.stopTest();

		System.assertEquals(1, Loggly.cache.logs.size(), 'Log did not get added to the cache');
		System.assertEquals(testValue, Loggly.cache.logs.get(0).logValue, 'Did not get the correct log value');
		System.assertEquals(e.getTypeName(), Loggly.cache.logs.get(0).additionalValues.get(Loggly.EXCEPTION_TYPE_NAME), 'Did not get the correct EXCEPTION_TYPE_NAME');
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

	static testMethod void gifUrl_double_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();

		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';
		String hostname_val = '_unitest_hostname_';

		Map<String, String> correctResponses = new Map<String, String>{
			Loggly.KEY_HOST => hostname_val,
			Loggly.KEY_LEVEL => Loggly.DEFAULT_LEVEL,
			Loggly.KEY_DATETIME => testDate.format(Loggly.DATE_FORMAT),
			Loggly.KEY_USERID => UserInfo.getUserId(),
			Loggly.KEY_USERNAME => UserInfo.getUserName(),
			Loggly.KEY_MESSAGE => testValue
		};

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		testSettings.Hostname__c = hostname_val;
		testSettings.Include_Hostname__c = true;
		testSettings.Include_Userinfo__c = true;
		insert testSettings;

		Loggly.SETTING_NAME = settingName;

		Test.startTest();

		String gifUrl = Loggly.gifUrl(testValue, testDate);

		Test.stopTest();

		System.assert(String.isNotBlank(gifUrl), 'Gif URL should not be null');
		System.assertEquals(endpoint+'.gif', gifUrl.substringBefore('?'), 'Did not get the right base url');

		PageReference pageRef = new PageReference(gifUrl);

		for (String key: pageRef.getParameters().keySet()) {
			if (correctResponses.containsKey(key)) {
				System.assertEquals(correctResponses.get(key), pageRef.getParameters().get(key), 'Did not get the right value back for "'+key+'"');
				correctResponses.remove(key);
			} else {
				System.assert(false, 'Got a url parameter we did not expect "'+key+'" => "'+pageRef.getParameters().get(key)+'"');
			}
		}

		System.assert(correctResponses.isEmpty(), 'Did not get url parameters back for ['+correctResponses.keySet()+']');
	}

	static testMethod void gifUrl_triple_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();
		String testLevel = 'ERROR';

		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';
		String hostname_val = '_unitest_hostname_';

		Map<String, String> correctResponses = new Map<String, String>{
			Loggly.KEY_HOST => hostname_val,
			Loggly.KEY_LEVEL => testLevel,
			Loggly.KEY_DATETIME => testDate.format(Loggly.DATE_FORMAT),
			Loggly.KEY_USERID => UserInfo.getUserId(),
			Loggly.KEY_USERNAME => UserInfo.getUserName(),
			Loggly.KEY_MESSAGE => testValue
		};

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		testSettings.Hostname__c = hostname_val;
		testSettings.Include_Hostname__c = true;
		testSettings.Include_Userinfo__c = true;
		insert testSettings;

		Loggly.SETTING_NAME = settingName;

		Test.startTest();

		String gifUrl = Loggly.gifUrl(testValue, testDate, testLevel);

		Test.stopTest();

		System.assert(String.isNotBlank(gifUrl), 'Gif URL should not be null');
		System.assertEquals(endpoint+'.gif', gifUrl.substringBefore('?'), 'Did not get the right base url');

		PageReference pageRef = new PageReference(gifUrl);

		for (String key: pageRef.getParameters().keySet()) {
			if (correctResponses.containsKey(key)) {
				System.assertEquals(correctResponses.get(key), pageRef.getParameters().get(key), 'Did not get the right value back for "'+key+'"');
				correctResponses.remove(key);
			} else {
				System.assert(false, 'Got a url parameter we did not expect "'+key+'" => "'+pageRef.getParameters().get(key)+'"');
			}
		}

		System.assert(correctResponses.isEmpty(), 'Did not get url parameters back for ['+correctResponses.keySet()+']');
	}

	static testMethod void gifUrl_quad_test() {
		String testValue = '_unittest_value_';
		DateTime testDate = DateTime.now();
		String testLevel = 'ERROR';
		String testKey = '_unittest_key_';
		String testData = '_unittest_data_';

		Map<String, String> testAdditionalValues = new Map<String, String>{ testKey => testData };

		String settingName = '_unittest_name_';
		String endpoint = 'test://myurl';
		String hostname_val = '_unitest_hostname_';

		Map<String, String> correctResponses = new Map<String, String>{
			Loggly.KEY_HOST => hostname_val,
			Loggly.KEY_LEVEL => testLevel,
			Loggly.KEY_DATETIME => testDate.format(Loggly.DATE_FORMAT),
			Loggly.KEY_USERID => UserInfo.getUserId(),
			Loggly.KEY_USERNAME => UserInfo.getUserName(),
			Loggly.KEY_MESSAGE => testValue,
			testKey => testData
		};

		LogglySettings__c testSettings = new LogglySettings__c();
		testSettings.Name = settingName;
		testSettings.Endpoint__c = endpoint;
		testSettings.Hostname__c = hostname_val;
		testSettings.Include_Hostname__c = true;
		testSettings.Include_Userinfo__c = true;
		insert testSettings;

		Loggly.SETTING_NAME = settingName;

		Test.startTest();

		String gifUrl = Loggly.gifUrl(testValue, testDate, testLevel, testAdditionalValues);

		Test.stopTest();

		System.assert(String.isNotBlank(gifUrl), 'Gif URL should not be null');
		System.assertEquals(endpoint+'.gif', gifUrl.substringBefore('?'), 'Did not get the right base url');

		PageReference pageRef = new PageReference(gifUrl);

		for (String key: pageRef.getParameters().keySet()) {
			if (correctResponses.containsKey(key)) {
				System.assertEquals(correctResponses.get(key), pageRef.getParameters().get(key), 'Did not get the right value back for "'+key+'"');
				correctResponses.remove(key);
			} else {
				System.assert(false, 'Got a url parameter we did not expect "'+key+'" => "'+pageRef.getParameters().get(key)+'"');
			}
		}

		System.assert(correctResponses.isEmpty(), 'Did not get url parameters back for ['+correctResponses.keySet()+']');
	}
}