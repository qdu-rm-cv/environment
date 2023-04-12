#! /bin/bash

# ----------------------------------------------------------------
### Constant Variables
# ----------------------------------------------------------------
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

# ------------------------------------------------------------------------------------------------
### Package options
#              notice:  modify code below if package changes
#
#     each lib format:  directory
#                       functions
# ------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------
## oneTBB
oneTBB_dirs=("/lib/oneTBB/")
function oneTBB_dep() {
  echo -e "\n-- Installing [oneTBB] dependancy\n"
  # COMMAND OCCURS IN [RELEASE MODE]
  if [ "$MODE" == 1 ]; then
    sudo apt-get install -y libtbb-dev
  fi
}
# -------------------------------------------------------------------------

# -------------------------------------------------------------------------
## BehaviourTree.CPP
BehaviourTree_dirs=("/bin/behaviortree_cpp_v3/" "/include/behaviortree_cpp_v3/" "/lib/behaviortree_cpp_v3/" "/lib/cmake/behaviortree_cpp_v3/")
function BehaviourTree_dep() {
  echo -e "\n-- Installing [BehaviorTree] dependancy\n"
  # COMMAND OCCURS IN [RELEASE MODE]
  if [ "$MODE" == 1 ]; then
    sudo apt-get install -y libzmq3-dev libboost-dev libncurses-dev
  fi
}
# -------------------------------------------------------------------------

# -------------------------------------------------------------------------
## OpenCV
OpenCV_dirs=("/bin/opencv4/" "/include/opencv4/" "/lib/opencv4/" "/lib/cmake/opencv4/" "/share/licenses/opencv4/" "/share/opencv4/")
function OpenCV_dep() {
  echo -e "\n-- Installing [OpenCV] dependancy\n"
  # COMMAND OCCURS IN [RELEASE MODE]
  if [ "$MODE" == 1 ]; then
    sudo apt-get install -y libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev ffmpeg libavcodec-dev libavformat-dev libswscale-dev libavutil-dev
  fi
}
# -------------------------------------------------------------------------

# -------------------------------------------------------------------------
## libusbp
libusbp_dirs=("/include/libusbp-1/" "/lib/libusbp-1/" "/lib/pkgconfig/libusbp-1/")
function libusbp_dep() {
  echo -e "\n-- Installing [libusbp] dependancy\n"
  # COMMAND OCCURS IN [RELEASE MODE]
  if [ "$MODE" == 1 ]; then
    sudo apt-get install -y libudev-dev
  fi
}
# -------------------------------------------------------------------------

# -------------------------------------------------------------------------
## Ceres Solver
Ceres_dirs=("/include/ceres/" "/lib/ceres/" "/lib/cmake/Ceres/")
function Ceres_dep() {
  echo -e "\n-- Installing [Ceres Solver] dependancy\n"
  # COMMAND OCCURS IN [RELEASE MODE]
  if [ "$MODE" == 1 ]; then
    sudo apt-get install -y libgoogle-glog-dev libgflags-dev libatlas-base-dev libeigen3-dev libsuitesparse-dev
  fi
}

#   function name:  file_fix
#           param:  None
#          return:  None
#
#            note:  This function is used to correct libeigen3-dev version in '../lib/cmake/Ceres/CeresConfig.cmake'
#                   There is a conflict between ROS-CERES and CERES, so correct it with [SED] command
#           usage:  file_fix
#           wrote:  Eric Liu
#  last edit time:  2023/4/5
#
function file_fix() {
  var="$(dpkg -l | grep eigen | awk '{print $3}')"
  sed -i "194c set(CERES_EIGEN_VERSION ${var%-*})" ${ROOT_DIR}/lib/cmake/Ceres/CeresConfig.cmake
}
# -------------------------------------------------------------------------

# -------------------------------------------------------------------------
## Spdlog
Spdlog_dirs=("/include/spdlog/" "/lib/spdlog/" "/lib/cmake/spdlog/" "/lib/pkgconfig/spdlog/")
function Spdlog_dep() {
  echo -e "\n-- Installing [Spdlog] dependancy\n"
}
# -------------------------------------------------------------------------

# -------------------------------------------------------------------------
## GTest
GoogleTest_dirs=("/include/gmock/" "/include/gtest/" "/lib/gmock/" "/lib/gtest/" "/lib/cmake/GTest/" "/lib/pkgconfig/gtest/")
function GoogleTest_dep() {
  echo -e "\n-- Installing [Google Test] dependancy\n"
}
# -------------------------------------------------------------------------

# -------------------------------------------------------------------------
## MVS
function MVS_install() {
  # COMMAND OCCURS IN [RELEASE MODE]
  if [ "$MODE" == 1 ]; then
    sudo dpkg -i $ROOT_DIR/pack/MVS-2.1.2_x86_64_20221208.deb
  fi
  echo -e "\n-- Installed MVS\n"
}
# -------------------------------------------------------------------------

# ------------------------------------------------------------------------------------------------
### Functions
# ------------------------------------------------------------------------------------------------

#   function name:  update_file
#           param:  $1     The update file
#          return:  None
#
#            note:  This function is used instead of REMOVE function.
#           usage:  update_file "/usr/local/lib/*"
#           wrote:  Eric Liu
#  last edit time:  2023/4/7
#
function update_file() {
  DST=$1
  echo -e "RUN: sudo rm -rf ${DST}"
  # COMMAND OCCURS IN [RELEASE MODE]
  if [ "$MODE" == 1 ]; then
    if [[ -e "${DST}" ]]; then
      if [[ -e "${DST}.old" ]]; then
        sudo rm -rf ${DST}.old
      fi
      sudo mv ${DST} ${DST}.old
    fi
  fi
}
#   function name:  link_file
#           param:  $1     The source file
#                   $2     The destination file
#          return:  None
#
#            note:  This function is used instead of 'ls -n' command.
#           usage:  link_file a b
#           wrote:  Eric Liu
#  last edit time:  2023/4/7
#
function link_file() {
  SRC=$1
  DST=$2
  echo "RUN: sudo ln -s ${SRC} ${DST}"
  # COMMAND OCCURS IN [RELEASE MODE]
  if [ "$MODE" == 1 ]; then
    sudo ln -s ${SRC} ${DST}
  fi
}

#   function name:  link_lib
#           param:  $1     The text which is used to show [the stage]
#                   $2     The array includes directory the lib which should be processed
#          return:  None
#
#            note:  This function is used to link(remove then link) the specified library you given.
#           usage:  link_lib "oneTBB" "${oneTBB_dirs[*]}"
#           wrote:  Eric Liu
#  last edit time:  2023/4/5
#
function link_lib() {
  echo -e "-- Linking [$1] files" # [param-$1] first appears
  target_dir=$2                   # [param-$2] first appears

  for file_dir in ${target_dir[@]}; do
    # 1. To get which type => var:choice
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

    # 2. Link files.
    echo -e "\n-- Linking [$1] $choice dir files\n"

    # 2.1 Type a) INCLUDE / CMAKE
    if [[ $choice == $INCLUDE || $choice == $CMAKE ]]; then
      cur_file=${ROOT_DIR}${file_dir}
      dest_file=${DET_DIR}${choice}
      del_dir=${DET_DIR}${file_dir}
      update_file ${del_dir:0:${#del_dir}-1}
      link_file ${cur_file:0:${#cur_file}-1} ${dest_file}

    # 2.2 Type b) others
    else
      for file in $(ls ${ROOT_DIR}${file_dir}); do
        cur_file=${ROOT_DIR}${file_dir}${file}
        del_dir=${DET_DIR}${choice}${file}
        dest_file=${DET_DIR}${choice}${file}
        update_file ${del_dir}
        link_file ${cur_file} ${dest_file}
      done
    fi
  done
  echo -e "\n-- Link [$1] files done\n"
}

#   function name:  choose
#           param:  $1     The chosen options
#          return:  None
#
#            note:  This function is a decorating function, used to call 'link_lib' function.
#           usage:  choose oneTBB
#           wrote:  Eric Liu
#  last edit time:  2023/4/6
#
function choose() {
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

#   function name:  menu
#           param:  None
#          return:  packages   the packages you want to link
#
#            note:  This function is used to generate a page of ui(whiptail), and
#                   and return thhe packages you choose.
#           usage:  menu
#           wrote:  Eric Liu
#  last edit time:  2023/4/7
#
function menu() {
  OPTION=$(whiptail --title "QDU-RM-CV-ENV installation" --menu "Whether you need ROS(noetic)" 15 60 4 \
    "1" "Withous ROS" \
    "2" "With ROS" 3>&1 1>&2 2>&3)
  exitstatus=$?

  if [ $exitstatus = 0 ]; then
    if [[ $OPTION == "1" ]]; then
      packages=$( # [return value] first appears
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
        echo "$packages"
      else
        echo "You chose Cancel."
      fi

    else
      # TODO(CV-GROUP): To be continue ...
      # Nowadays I think it's hard to be completed and apply.
      # whiptail --title "QDU-RM-CV-ENV installation" --msgbox " Not supported now.\n Choose Ok to exit." 10 60
      echo "Not support yet."
    fi
  else
    echo "You chose Cancel."
  fi
}

#   function name:  install
#           param:  $1    the packages you want to link(using a string)
#          return:  None
#
#            note:  This function is the MAIN function.
#           usage:  install "All MVS"
#           wrote:  Eric Liu
#  last edit time:  2023/4/7
#
function install() {
  install_packages=$1
  echo

  # 1. Install MVS
  if [[ "${install_packages[@]}" =~ "MVS" ]]; then
    echo -e "\n##############################"
    echo -e "#  Installing install_packages."
    echo -e "##############################\n"

    if [ $(dpkg -l | grep mvs | wc -l) != 0 ]; then
      if [ $(dpkg -l | grep mvs | grep 2022-10-24 | wc -l) == 0 ]; then
        echo -e "-- MVS deb should update.\n"
      else
        echo -e "-- MVS deb is not installed.\n"
      fi
      MVS_install
    fi
    echo -e "-- MVS deb has already to date.\n"
  fi

  # 2. Install install_packages
  echo -e "\n##############################"
  echo -e "#  Linking install_packages."
  echo -e "##############################"
  # 2.1 Update APT
  echo -e "\n-- apt update"
  if [ "$MODE" == 1 ]; then
    sudo apt update && sudo apt upgrade -y
  fi

  # 2.2 Install essential apps
  echo -e "\n-- Installing base dependancy\n"
  if [ "$MODE" == 1 ]; then
    sudo apt-get install -y gcc g++ cmake git curl wget build-essential ninja-build python-is-python3
  fi

  # 2.3 Refreshing directories '/usr/local/lib/pkgconfig' and '/usr/local/lib/cmake'
  if [[ $(readlink ${DET_DIR}${PKG}) == ${ROOT_DIR}${PKG} ]]; then
    echo -e "FALSE soft link [$(readlink ${DET_DIR}${PKG})->${ROOT_DIR}${PKG}], so REMOVE it.\n"
    update_file ${DET_DIR}${PKG}
  fi
  if [ ! -d ${DET_DIR}${PKG} ]; then
    echo -e "DON'T HAVE directory ${DET_DIR}${PKG}, so NEW it.\n"
    echo -e "RUN: sudo mkdir ${DET_DIR}${PKG}"
    sudo mkdir ${DET_DIR}${PKG}
  fi
  if [[ $(readlink ${DET_DIR}${CMAKE}) == ${ROOT_DIR}${CMAKE} ]]; then
    echo -e "FALSE soft link [$(readlink ${DET_DIR}${CMAKE})->${ROOT_DIR}${CMAKE}], so REMOVE it.\n"
    update_file ${DET_DIR}${CMAKE}
  fi
  if [ ! -d ${DET_DIR}${CMAKE} ]; then
    echo -e "DON'T HAVE directory ${DET_DIR}${CMAKE}, so NEW it.\n"
    echo -e "RUN: sudo mkdir ${DET_DIR}${CMAKE}"
    sudo mkdir ${DET_DIR}${CMAKE}
  fi

  # 2.4 Call functions above
  if [[ "${install_packages[@]}" =~ "All" ]]; then
    choose oneTBB
    choose BehaviorTree
    choose OpenCV
    choose libusbp
    choose Ceres
    choose Spdlog
    choose GoogleTest
    file_fix
  else
    if [[ "${install_packages[@]}" =~ "Ceres" ]]; then
      file_fix
    fi
    for package in ${install_packages[@]}; do
      choose ${package}
    done
  fi

  # 3. ldconfig
  sudo ldconfig
  echo -e "\n##############################"
  echo -e "#  All is done."
  echo -e "##############################\n"
}
