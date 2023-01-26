# Environment

## Description

[QDU-RM-AI](https://github.com/qdu-rm-cv/qdu-rm-ai) Environment in `Ubuntu20.04 LTS`, which is used to `CI/CD`, *without CUDA*.

- **Haven't tested in PC or MiniPC**

## Packages version

- [OpenCV (4.5.4)](https://docs.opencv.org/4.5.4/d7/d9f/tutorial_linux_install.html)
- [BehavoirTree.CPP (3.8.1)](https://github.com/BehaviorTree/BehaviorTree.CPP)
- [MVS SDK from HIKROBOT (MVS-2.1.2_x86_64_20221208)](https://www.hikrobotics.com/cn/machinevision/service/download?module=0)
- [spdlog (1.11.0)](https://github.com/gabime/spdlog)
- [Google Test (1.10.0)](https://github.com/google/googletest)
- [oneTBB (2020.1)](https://github.com/oneapi-src/oneTBB) or `libtbb-dev`
- [libusbp (1.2.0)](https://github.com/pololu/libusbp)
- [Eigen (3.3.7)](https://eigen.tuxfamily.org/index.php?title=Main_Page)
- [Ceres-Solver (2.1.0)](http://ceres-solver.org/)

## Build dependancy

```sh
# base
sudo apt-get install gcc g++ cmake git curl wget build-essential ninja-build

# oneTBB
sudo apt-get install libtbb-dev

# BehaviourTree.CPP
sudo apt-get install libzmq3-dev libboost-dev

# OpenCV
sudo apt-get install libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev  ffmpeg libavcodec-dev libavformat-dev libswscale-dev libavutil-dev

# libusbp
sudo apt-get install libudev-dev

# Ceres Solver
sudo apt-get install libgoogle-glog-dev libgflags-dev libatlas-base-dev libeigen3-dev libsuitesparse-dev
```

## Version

*0.1.0* : 2023.1.27
