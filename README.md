[![Gem Version](https://badge.fury.io/rb/libis-workflow-activerecord.svg)](http://badge.fury.io/rb/libis-workflow-activerecord)
[![Build Status](https://travis-ci.org/Kris-LIBIS/workflow-activerecord.svg?branch=master)](https://travis-ci.org/Kris-LIBIS/workflow-activerecord)
[![Coverage Status](https://coveralls.io/repos/Kris-LIBIS/workflow-activerecord/badge.png)](https://coveralls.io/r/Kris-LIBIS/workflow-activerecord)
[![Dependency Status](https://gemnasium.com/Kris-LIBIS/workflow-activerecord.svg)](https://gemnasium.com/Kris-LIBIS/workflow-activerecord)

workflow-activerecord
=====================

ActiveRecord persistence for the workflow framework.

Note: This gem only supports Postgres and MySql as it needs support for json data type in the DB.
When - and if - the sqlite3 adapter adds support for the sqlite JSON1 extension, this gem
is expected to support sqlite as well.
