#!/bin/zsh

echo "\n##############################"
echo "#  Installing dependancy."
echo "##############################\n"

sudo apt install -y gcc g++ cmake git curl wget build-essential ninja-build \
    libzmq3-dev libboost-dev libudev-dev libgoogle-glog-dev libgflags-dev libatlas-base-dev libeigen3-dev libsuitesparse-dev \
    libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev python-numpy libtbb2 libtbb-dev libjpeg-dev \
    libpng-dev libtiff-dev libdc1394-22-dev ffmpeg libavcodec-dev libavformat-dev libswscale-dev libavutil-dev


echo "\n##############################"
echo "#  Link files."
echo "##############################\n"

if [ ! -f ~/.cv_profile ]; then
    touch ~/.cv_profile
    echo "-- touch ~/.cv_profile\n"
else
    rm ~/.cv_profile
    touch ~/.cv_profile
    echo "-- has touched ~/.cv_profile\n"
fi

sudo ln -s $PWD/include/** /usr/local/include
echo export PATH=$PWD:${PATH} >> ~/.cv_profile
echo export LD_LIBRARY_PATH=$PWD:$LD_LIBRARY_PATH >> ~/.cv_profile
sudo ldconfig

source ~/.cv_profile

echo "\n##############################"
echo "#  Installing packages."
echo "##############################\n"

pack_info=$(dpkg -l | grep mvs)
pack_install=$pack_info | grep '2022-10-24'
if ! [ $pack_install  -eq ""]; then
    sudo dpkg -i ./pack/MVS-2.1.2_x86_64_20221208.deb
    echo "-- MVS deb is not installed.\n"
else
    echo "-- MVS deb has been installed.\n"
fi

echo "##############################"
echo "#  ENV has been setted."
echo "##############################"
