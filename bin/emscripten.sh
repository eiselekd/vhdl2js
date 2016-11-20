#!/bin/bash
# from https://kripken.github.io/emscripten-site/docs/getting_started/downloads.html
wget https://s3.amazonaws.com/mozilla-games/emscripten/releases/emsdk-portable.tar.gz
tar xvf emsdk-portable.tar.gz
cd emsdk-portable
./emsdk install latest
./emsdk activate latest
