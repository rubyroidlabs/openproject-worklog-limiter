# OpenProject Worklog Limiter Plugin

This plugin restricts time log only for current week, but users can be allowed to log time for any date by admin.

Requirements
------------

The OpenProject Costs plug-in requires the [OpenProject Core](https://github.com/opf/openproject/).

Installation
------------

For OpenProject Costs itself you need to add the following line to the `Gemfile.plugins` of OpenProject:

`gem "openproject-worklog_limiter", git: "https://github.com/rubyroidlabs/openproject-worklog-limiter"`

Afterwards, run:

`bundle install`

This plugin contains migrations. To migrate the database, run:

`rake db:migrate`

Usage
------------

By default, every user is allowed to log time only for current week and for previous week if time entry is created at Monday before 12:00.

If you want to make an exception for user, go to `Edit user page / Custom fields` and check `Allow log time for any date` checkbox. After that user will be allowed to log time for any date for one day.

By default, all roles are allowed to log time for any date. If you want to remove this ability or create another role and add ability, go to `Roles and permissions / Edit role / Time tracking` and check/uncheck `Log time for any date` checkbox.

Deinstallation
--------------

Remove the line

`gem "openproject-worklog_limiter", git: "https://github.com/rubyroidlabs/openproject-worklog-limiter"` from the file `Gemfile.plugins` and run `bundle install`

Please note that this leaves plugin data in the database. Currently, we do not support full uninstall of the plugin.

Tests
--------------

To run plugin's tests run `bundle exec rake spec:plugins` in OpenProject core directory
