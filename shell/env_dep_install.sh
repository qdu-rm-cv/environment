#!/bin/bash

workdir=$(cd $(dirname $0)/..; pwd)

command_update(){
    sudo apt update && sudo apt upgrade
    echo -e "\n-- apt update \n"
}

command_install(){
    sudo dpkg -i ./pack/MVS-2.1.2_x86_64_20221208.deb
    echo -e "-- MVS deb has already to date.\n"
}


echo -e "\n##############################"
echo -e "#  Installing dependancy."
echo -e "##############################\n"

command_update

# base
echo -e "\n-- Installing base dependancy\n"
sudo apt-get install -y gcc g++ cmake git curl wget build-essential ninja-build python-is-python3

# oneTBB
echo -e "\n-- Installing [oneTBB] dependancy\n"
sudo apt-get install -y libtbb-dev

# BehaviourTree.CPP
echo -e "\n-- Installing [BehaviourTree.CPP] dependancy\n"
sudo apt-get install -y libzmq3-dev libboost-dev libncurses-dev

# OpenCV
echo -e "\n-- Installing [OpenCV] dependancy\n"
sudo apt-get install -y libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev  ffmpeg libavcodec-dev libavformat-dev libswscale-dev libavutil-dev

# libusbp
echo -e "\n-- Installing [libusbp] dependancy\n"
sudo apt-get install -y libudev-dev

# Ceres Solver
echo -e "\n-- Installing [Ceres Solver] dependancy\n"
sudo apt-get install -y libgoogle-glog-dev libgflags-dev libatlas-base-dev libeigen3-dev libsuitesparse-dev

command_update

echo -e "\n##############################"
echo -e "#  Linking files."
echo -e "##############################\n"

if [ ! -f ~/.cv_profile ]; then
    touch ~/.cv_profile
    echo -e "-- touch ~/.cv_profile\n"
else
    rm ~/.cv_profile
    touch ~/.cv_profile
    echo -e "-- has touched ~/.cv_profile\n"
fi

python3 $workdir/shell/file_grub.py

echo -e export PATH=$workdir:${PATH} >> ~/.cv_profile
echo -e export LD_LIBRARY_PATH=$workdir:$LD_LIBRARY_PATH >> ~/.cv_profile
sudo ldconfig

source ~/.cv_profile

echo -e "\n##############################"
echo -e "#  Installing packages."
echo -e "##############################\n"

if ! [ `dpkg -l | grep mvs | grep 2022-10-24 | wc -l` -ne 0 ]; then
    if [ `dpkg -l | grep mvs | wc -l` -ne 0 ]; then
        echo -e "-- MVS deb should update.\n"
    else
        echo -e "-- MVS deb is not installed.\n"
    fi
    command_install
fi

echo -e "##############################"
echo -e "#  ENV has been setted."
echo -e "##############################"
