/**The Controller for the configuration page for SLoggly
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

public with sharing class Loggly_Configure_Controller {
	public static String MESSAGE_INCLUDE_HOSTNAME = 'Error: Hostname must be included if include hostname is checked';
	private LogglySettings__c record;
	public String recordName;
	public String endpoint;
	public String hostname;
	public Boolean includeHostname;

	/** Gets the endpoint
	*
	* @return The endpoint
	*/
	public String getEndpoint() {
		return this.endpoint;
	}

	/** Sets the endpoint
	*
	* @param val The endpoint
	*/
	public void setEndpoint(String val) {
		this.endpoint = val;
	}

	/** Gets the hostname
	*
	* @return The hostname
	*/
	public String getHostname() {
		return this.hostname;
	}

	/** Sets the hostname
	*
	* @param val The hostname
	*/
	public void setHostname(String val) {
		this.hostname = val;
	}

	/** Gets the include hostname flag
	*
	* @return The include hostname flag
	*/
	public Boolean getIncludeHostname() {
		return (this.includeHostname == null) ? false : this.includeHostname;
	}

	/** Sets the include hostname flag
	*
	* @param val The include hostname flag
	*/
	public void setIncludeHostname(Boolean val) {
		this.includeHostname = val;
	}

	/** Gets the record name
	* Defaults to the default name if not set
	*
	* @return The record name
	*/
	public String getRecordName() {
		if (recordName == null) {
			recordName = Loggly.DEFAULT_SETTING_NAME;
		}

		return recordName;
	}

	/** The empty construtor */
	public Loggly_Configure_Controller() {}

	/** Creates a new loggly setting */
	public PageReference create() {
		if (
			this.includeHostname &&
			(
				this.hostname == null ||
				this.hostname.trim() == ''
			)
		) {
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, MESSAGE_INCLUDE_HOSTNAME);
			ApexPages.addMessage(myMsg);
			return null;
		}


		this.record = new LogglySettings__c();
		this.record.Name = getRecordName();
		this.record.Endpoint__c = getEndpoint();
		this.record.Hostname__c = getHostname();
		this.record.Include_Hostname__c = getIncludeHostname();

		insert this.record;

		return new PageReference('/' + this.record.Id);

	}
}