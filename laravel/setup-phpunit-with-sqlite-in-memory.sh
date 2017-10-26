#!/bin/bash


#/<env name="APP_ENV" value="testing"/>
#        <env name="DB_CONNECTION" value="sqlite"/>
#        <env name="DB_DATABASE" value=":memory:"/>

sed '
/<env name="APP_ENV" value="testing"\/>/ a\
        <env name="DB_CONNECTION" value="sqlite"/>\
        <env name="DB_DATABASE" value=":memory:"/>
' -i phpunit.xml

#sed 's/<env name="APP_ENV" value="testing"\/>/lol/g' phpunit.xml
