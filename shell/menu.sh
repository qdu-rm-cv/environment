#! /bin/bash

DET_DIR="/usr/local"

ROOT_DIR=$(
  cd "$(dirname "$0")/.."
  pwd
)

LIB="/lib/"
INCLUDE="/include/"
BIN="/bin/"
SHARE="/share/"
CMAKE="/lib/cmake/"
PKG="/lib/pkgconfig/"

MODE=1 # 0: debug 1: release

# oneTBB
oneTBB_dirs=("/lib/oneTBB/")
function oneTBB_dep() {
  echo -e "\n-- Installing [oneTBB] dependancy\n"
  if [ "$MODE" == 1 ]; then
    sudo apt-get install -y libtbb-dev
  fi
}

# BehaviourTree.CPP
BehaviourTree_dirs=("/bin/behaviortree_cpp_v3/" "/include/behaviortree_cpp_v3/" "/lib/behaviortree_cpp_v3/" "/lib/cmake/behaviortree_cpp_v3/")
function BehaviourTree_dep() {
  echo -e "\n-- Installing [BehaviorTree] dependancy\n"
  if [ "$MODE" == 1 ]; then
    sudo apt-get install -y libzmq3-dev libboost-dev libncurses-dev
  fi
}

# OpenCV
OpenCV_dirs=("/bin/opencv4/" "/include/opencv4/" "/lib/opencv4/" "/lib/cmake/opencv4/" "/share/licenses/opencv4/" "/share/opencv4/")
function OpenCV_dep() {
  echo -e "\n-- Installing [OpenCV] dependancy\n"
  if [ "$MODE" == 1 ]; then
    sudo apt-get install -y libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev ffmpeg libavcodec-dev libavformat-dev libswscale-dev libavutil-dev
  fi
}

# libusbp
libusbp_dirs=("/include/libusbp-1/" "/lib/libusbp-1/" "/lib/pkgconfig/libusbp-1/")
function libusbp_dep() {
  echo -e "\n-- Installing [libusbp] dependancy\n"
  if [ "$MODE" == 1 ]; then
    sudo apt-get install -y libudev-dev
  fi
}

# Ceres Solver
Ceres_dirs=("/include/ceres/" "/lib/ceres/" "/lib/cmake/Ceres/")
function Ceres_dep() {
  echo -e "\n-- Installing [Ceres Solver] dependancy\n"
  if [ "$MODE" == 1 ]; then
    sudo apt-get install -y libgoogle-glog-dev libgflags-dev libatlas-base-dev libeigen3-dev libsuitesparse-dev
  fi
}
function file_fix() {
  var="$(dpkg -l | grep eigen | awk '{print $3}')"
  sed -i "194c set(CERES_EIGEN_VERSION ${var%-*})" ${ROOT_DIR}/lib/cmake/Ceres/CeresConfig.cmake
}

# Spdlog
Spdlog_dirs=("/include/spdlog/" "/lib/spdlog/" "/lib/cmake/spdlog/" "/lib/pkgconfig/spdlog/")
function Spdlog_dep() {
  echo -e "\n-- Installing [Spdlog] dependancy\n"
}

# GTest
GoogleTest_dirs=("/include/gmock/" "/include/gtest/" "/lib/gmock/" "/lib/gtest/" "/lib/cmake/GTest/" "/lib/pkgconfig/gtest/")
function GoogleTest_dep() {
  echo -e "\n-- Installing [Google Test] dependancy\n"
}

# MVS
function MVS_install() {
  if [ "$MODE" == 1 ]; then
    sudo dpkg -i $ROOT_DIR/pack/MVS-2.1.2_x86_64_20221208.deb
  fi
  echo -e "\n-- Installed MVS\n"
}

function link_lib() {
  echo -e "-- Linking [$1] files"
  target_dir=$2

  for file_dir in ${target_dir[@]}; do
    if [[ $file_dir =~ $CMAKE ]]; then
      choice=$CMAKE
    elif [[ $file_dir =~ $PKG ]]; then
      choice=$PKG
    elif [[ $file_dir =~ $BIN ]]; then
      choice=$BIN
    elif [[ $file_dir =~ $INCLUDE ]]; then
      choice=$INCLUDE
    elif [[ $file_dir =~ $LIB ]]; then
      choice=$LIB
    elif [[ $file_dir =~ $SHARE ]]; then
      choice=$SHARE
    else
      continue
    fi

    echo -e "\n-- Linking [$1] $choice dir files\n"
    if [[ $choice == $INCLUDE || $choice == $CMAKE ]]; then
      cur_file=${ROOT_DIR}${file_dir}
      dest_file=${DET_DIR}${choice}
      del_dir=${DET_DIR}${file_dir}
      echo "RUN: sudo rm -rf ${del_dir:0:${#del_dir}-1} && sudo ln -s ${cur_file:0:${#cur_file}-1} ${dest_file} "

      if [ "$MODE" == 1 ]; then
        sudo rm -rf ${del_dir:0:${#del_dir}-1} && sudo ln -s ${cur_file:0:${#cur_file}-1} ${dest_file}
      fi

    else
      for file in $(ls ${ROOT_DIR}${file_dir}); do
        cur_file=${ROOT_DIR}${file_dir}${file}
        del_dir=${DET_DIR}${choice}${file}
        dest_file=${DET_DIR}${choice}${file}
        echo "RUN: sudo rm -rf ${del_dir} && sudo ln -s ${cur_file} ${dest_file} "

        if [ "$MODE" == 1 ]; then
          sudo rm -rf ${del_dir} && sudo ln -s ${cur_file} ${dest_file}
        fi
      done
    fi
  done
  echo -e "\n-- Link [$1] files done\n"

}

function menu() {
  echo -e "\n-- Menu $1"
  case "$1" in
  "Opencv" | "OpenCV" | "opencv" | "opencv4" | "OpenCV4")
    OpenCV_dep
    link_lib "OpenCV" "${OpenCV_dirs[*]}"
    ;;
  "behaviortree" | "BehaviorTree" | "BT" | "BT3" | "BehaviourTree" | "behaviourtree" | "behaviortree_cpp_v3")
    BehaviourTree_dep
    link_lib "BehaviorTree" "${BehaviourTree_dirs[*]}"
    ;;
  "spdlog" | "Spdlog")
    Spdlog_dep
    link_lib "Spdlog" "${Spdlog_dirs[*]}"
    ;;
  "googletest" | "GoogleTest" | "GTest" | "gtest" | "Gtest")
    GoogleTest_dep
    link_lib "GoogleTest" "${GoogleTest_dirs[*]}"
    ;;
  "libusbp" | "libusbp-1")
    libusbp_dep
    link_lib libusbp "${libusbp_dirs[*]}"
    ;;
  "ceres" | "Ceres" | "Ceres Solver" | "Ceres-Solver" | "ceres solver")
    Ceres_dep
    link_lib "Ceres Solver" "${Ceres_dirs[*]}"
    ;;
  "onetbb" | "oneTBB" | "TBB" | "tbb")
    oneTBB_dep
    link_lib "oneTBB" "${oneTBB_dirs[*]}"
    ;;
  esac
}

if (whiptail --title "QDU-RM-CV-ENV installation" --yes-button "With ROS" --no-button "Without ROS" --yesno "Whether you need ROS" 10 60); then
  whiptail --title "QDU-RM-CV-ENV installation" --msgbox " Not supported now.\n Choose Ok to continue." 10 60
else
  packages=$(
    whiptail --title "QDU-RM-CV-ENV installation" --checklist \
      "Choose preferred packages" 15 60 8 \
      "All" "All packages below [expect MVS]" ON \
      "OpenCV" "4.5.4" OFF \
      "BehaviorTree" "3.8.1" OFF \
      "Spdlog" "1.11.0" OFF \
      "GoogleTest" "1.10.0" OFF \
      "libusbp" "1.2.0" OFF \
      "Ceres" "2.1.0" OFF \
      "MVS" "2.1.2_x86_64_20221208" ON 3>&1 1>&2 2>&3
  )
  exitstatus=$?
  if [ $exitstatus = 0 ]; then
    if [[ "${packages[@]}" =~ "MVS" ]]; then
      echo -e "\n##############################"
      echo -e "#  Installing packages."
      echo -e "##############################\n"

      if [ $(dpkg -l | grep mvs | wc -l) != 0 ]; then
        if [ $(dpkg -l | grep mvs | grep 2022-10-24 | wc -l) == 0 ]; then
          echo -e "-- MVS deb should update.\n"
          MVS_install
        fi
      else
        echo -e "-- MVS deb is not installed.\n"
      fi
      echo -e "-- MVS deb has already to date.\n"
    fi

    echo -e "\n##############################"
    echo -e "#  Linking packages."
    echo -e "##############################"
    echo -e "\n-- apt update"
    if [ "$MODE" == 1 ]; then
      sudo apt update && sudo apt upgrade -y
    fi

    echo -e "\n-- Installing base dependancy\n"
    if [ "$MODE" == 1 ]; then
      sudo apt-get install -y gcc g++ cmake git curl wget build-essential ninja-build python-is-python3
    fi

    if [ ! -d ${DET_DIR}${PKG} ]; then
      sudo mkdir ${DET_DIR}${PKG}
    fi
    if [ ! -d ${DET_DIR}${CMAKE} ]; then
      sudo mkdir ${DET_DIR}${CMAKE}
    fi

    if [[ "${packages[@]}" =~ "All" ]]; then
      menu oneTBB
      menu BehaviorTree
      menu OpenCV
      menu libusbp
      menu Ceres
      menu Spdlog
      menu GoogleTest
      file_fix
    else
      if [[ "${packages[@]}" =~ "Ceres" ]]; then
        file_fix
      fi
      for package in ${packages[@]}; do
        menu ${package}
      done
    fi
    sudo ldconfig

  else
    echo "You chose Cancel."
  fi

  echo -e "\n##############################"
  echo -e "#  All is done."
  echo -e "##############################\n"
fi

exit 0
