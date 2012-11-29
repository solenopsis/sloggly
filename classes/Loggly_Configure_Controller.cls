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
	private final ApexPages.StandardController controller;
	private final LogglySettings__c record;

	public Loggly_Configure_Controller(ApexPages.StandardController stdController) {
		this.controller = stdController;
		this.record = (LogglySettings__c) stdController.getRecord();

		this.record.Name = Loggly.DEFAULT_SETTING_NAME;
	}

	public PageReference create() {
		insert record;
		return new PageReference('/' + record.Id);

	}
}