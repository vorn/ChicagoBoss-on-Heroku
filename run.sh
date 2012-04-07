#!/bin/sh
cd ChicagoBoss
make
cd ../myapp
./init.sh start-standalone
while true; do
	sleep 10
done

