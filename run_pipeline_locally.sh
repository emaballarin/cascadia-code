#!/usr/bin/env bash

REDEPLOY_VENV=true
REGENERATE_REQUIREMENTS=true

if $REDEPLOY_VENV; then
    rm -R -f ./venv
fi

rm -R -f ./previous_build
if [ -d build ]; then
    mv build previous_build
fi

rm -R -f ./previous_release
if [ -d release ]; then
    mv release previous_release
fi
mkdir -p release

if [ ! -d venv ]; then

    if $REGENERATE_REQUIREMENTS; then
        echo "" > ./requirements.txt
        pip install --upgrade git+https://github.com/jazzband/pip-tools.git
        pip-compile -U requirements.in
    fi

    virtualenv venv
    source venv/bin/activate

    pip install -r requirements.txt
fi

export PRE_PATH="$PATH"
export PATH="./venv/bin/:$PATH"
ufolint sources/*.ufo
python ./build.py -S -W
cd ./build
zip -r ../release/CascadiaCode.zip ./otf ./ttf ./woff2
export PATH="$PRE_PATH"
unset PRE_PATH
