#!/bin/bash

if ps -p $PID > /dev/null
then
   exit 0
fi

exit 1