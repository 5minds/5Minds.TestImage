#!/bin/sh

echo "Waiting portal to launch on 8082..."

while ! echo exit | nc -z localhost 8082; do sleep 1; done

echo "portal launched"

HOME=${ROBOT_WORK_DIR}

xvfb-run -a \
    --server-args="-screen 0 1920x1080x24 -ac" \
robot --variable Resolution:1920x1080 --outputdir $ROBOT_REPORTS_DIR $ROBOT_TESTS_DIR

rm -rf $ROBOT_WORK_DIR

exit 0
