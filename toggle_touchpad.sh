#! /bin/bash

value=`synclient -l | grep TouchpadOff | awk {'print $3'}`

if [ $value = 0 ]
then
    synclient TouchpadOff=1
else
    synclient TouchpadOff=0
fi
