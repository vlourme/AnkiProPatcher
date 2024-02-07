#!/bin/bash

echo "Start to patch the IPA file."
if [ ! -f $1 ]; then
    echo "The IPA file is not exist."
    exit 1
fi

unzip -q $1 -d temp

APP_NAME=$(ls temp/Payload)
echo "Bundle name: $APP_NAME"

if [ ! -f temp/Payload/$APP_NAME/main.jsbundle ]; then
    echo "The main.jsbundle file is not exist."
    exit 1
fi

hbctool disasm temp/Payload/$APP_NAME/main.jsbundle output
patch output/instruction.hasm premium.patch
hbctool asm output output/main.jsbundle

cp output/main.jsbundle temp/Payload/$APP_NAME/main.jsbundle

cd temp
zip -qr ../patched.ipa Payload

cd ..
rm -rf temp
rm -rf output

echo "The patched ipa file is created."
