# Environment

## Description

[QDU-RM-AI](https://github.com/qdu-rm-cv/qdu-rm-ai) Environment in `Ubuntu20.04 LTS`, which is used to `CI/CD`, *without CUDA*.

- Untested:
  - *Mini PC*
- Passed:
  - *PC*
  - *WSL2*

## How to use

```sh
git clone https://github.com/qdu-rm-cv/environment.git
cd environment
sudo chmod 777 ./shell/*
./shell/env_dep_install.sh

# if you are a member of qdu-rm(weilai), you should run next command,
# which is used to install some coding and formatting tools.

# ./shell/code_dep_install.sh
```

## Packages version

| Package name                                                                                    | Version                   |
| :---------------------------------------------------------------------------------------------- | :------------------------ |
| [OpenCV](https://docs.opencv.org/4.5.4/d7/d9f/tutorial_linux_install.html)                      | 4.5.4                     |
| [BehavoirTree.CPP](https://github.com/BehaviorTree/BehaviorTree.CPP)                            | 3.8.1                     |
| [Spdlog](https://github.com/gabime/spdlog)                                                      | 1.11.0                    |
| [Google Test](https://github.com/google/googletest)                                             | 1.10.0                    |
| [oneTBB](https://github.com/oneapi-src/oneTBB) or `libtbb-dev`                                  | 2020.1                    |
| [libusbp](https://github.com/pololu/libusbp)                                                    | 1.2.0                     |
| [Eigen](https://eigen.tuxfamily.org/index.php?title=Main_Page) or `libeigen3-dev`               | 3.3.7                     |
| [Ceres-Solver](http://ceres-solver.org/)                                                        | 2.1.0                     |
| [MVS SDK from HIKROBOT](https://www.hikrobotics.com/cn/machinevision/service/download?module=0) | MVS-2.1.2_x86_64_20221208 |

## Build dependancy

> ***Wrote in `./shell/env_dep_install.sh`***

```sh
# base
sudo apt-get install gcc g++ cmake git curl wget build-essential ninja-build

# oneTBB
sudo apt-get install libtbb-dev

# BehaviourTree.CPP
sudo apt-get install libzmq3-dev libboost-dev libncurses-dev

# OpenCV
sudo apt-get install libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev  ffmpeg libavcodec-dev libavformat-dev libswscale-dev libavutil-dev

# libusbp
sudo apt-get install libudev-dev

# Ceres Solver
sudo apt-get install libgoogle-glog-dev libgflags-dev libatlas-base-dev libeigen3-dev libsuitesparse-dev
```

## Version

*0.1.3* : 2023.2.3

> Read `Release.txt` for more details.
