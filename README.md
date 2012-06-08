puppet-splunkstorm
==================

Description
-----------

A Puppet report handler for sending logs, events and metrics to SplunkStorm.

Extracts metrics and logs from Puppet reports and POSTs them to
SplunkStorm as an event for later searching & reporting.

Requirements
------------

* `rest-client`
* `puppet` (version 2.6.5 and later)

Installation & Usage
--------------------

1. Create a Splunk Storm account: https://www.splunkstorm.com

2. Retrieve your Access Token & Project ID: http://docs.splunk.com/Documentation/Storm/latest/User/UseStormsRESTAPI

3.  Install the `rest-client` gem on your Puppet master

        $ sudo gem install rest_client

4.  Install puppet-splunk as a module in your Puppet master's module
    path.

5.  Update the `access_token` variable in the `splunkstorm.yaml` file with
    your SplunkStorm token and the `project_id` field with your project's ID.

6.  Copy `splunkstorm.yaml` to `/etc/puppet`.

7.  Enable pluginsync and reports on your master and clients in `puppet.conf`

        [master]
        report = true
        reports = splunkstorm
        pluginsync = true
        [agent]
        report = true
        pluginsync = true

8.  Run the Puppet client and sync the report as a plugin

Author
------

James Turnbull <james@lovedthanlost.net>

The posting method is copied from Greg Albrecht Kim of Splunk.

License
-------

    Author:: James Turnbull (<james@lovedthanlost.net>)
    Copyright:: Copyright (c) 2012 James Turnbull
    License:: Apache License, Version 2.0

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
