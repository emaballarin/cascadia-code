#!/usr/bin/env bash

REDEPLOY_VENV=true

if $REDEPLOY_VENV; then
    rm -R -f ./venv
fi

rm -R -f ./previous_build

if [ -d build ]; then
    mv build previous_build
fi

if [ ! -d venv ]; then
    virtualenv venv
    source venv/bin/activate
    pip install -r requirements.txt
fi

export PRE_PATH="$PATH"
export PATH="./venv/bin/:$PATH"
ufolint sources/*.ufo
python ./build.py -S -W
zip -r ../out/CascadiaCode.zip ttf otf woff2
export PATH="$PRE_PATH"
unset PRE_PATH

