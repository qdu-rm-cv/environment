#! /usr/bin/bash

sudo apt install -y python-is-python3 python3-pip clang-format

sudo python -m pip install pylint cpplint autopep8 yapf

echo -e "\n##############################"
echo "#  Coding ENV has been setted."
echo "##############################"