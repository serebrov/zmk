#!/bin/bash

SCRIPT_PATH=`dirname $0`
ROOT_PATH=$SCRIPT_PATH/..

source zephyr/zephyr-env.sh
cd app
python -m west build -d build/left -b nice_nano -- -DSHIELD=microdox_left -DZMK_CONFIG=$ROOT_PATH/../zmk-config/config
python -m west build -d build/right -b nice_nano -- -DSHIELD=microdox_right -DZMK_CONFIG=$ROOT_PATH/../zmk-config/config
