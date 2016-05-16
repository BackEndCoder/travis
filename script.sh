#!/bin/bash

if [ "$PHPCS" == 1 ]; then
    ../Vendor/bin/phpcs --config-set installed_paths ../Vendor/cakephp/cakephp-codesniffer;

    ARGS="-p --extensions=php --standard=CakePHP --ignore=../Vendor/ .";
    if [ -n "$PHPCS_IGNORE" ]; then
        ARGS="$ARGS --ignore='$PHPCS_IGNORE'"
    fi
    if [ -n "$PHPCS_ARGS" ]; then
        ARGS="$PHPCS_ARGS"
    fi
    eval "../Vendor/bin/phpcs" $ARGS
    exit $?
fi

# Move to APP
cd ../app

EXIT_CODE=0

if [ "$CODECOVERAGE" == 1 ]; then
    ./Console/cake test $PLUGIN_NAME All$PLUGIN_NAME --stderr --coverage-clover clover.xml
    EXIT_CODE="$?"
elif [ -z "$FOC_VALIDATE" ]; then
    ./Console/cake test $PLUGIN_NAME All$PLUGIN_NAME --stderr
    EXIT_CODE="$?"
fi

if [ "$EXIT_CODE" -gt 0 ]; then
    exit 1
fi
exit 0
