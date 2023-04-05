# -*- coding:utf-8 -*-
# ! /usr/bin/python3

import os

DET_DIR = "/usr/local"

root = os.path.dirname(os.path.abspath(__file__))[0:-5]


def link(src, dst):
    if os.path.exists(dst):
        os.system(f"sudo rm -rf {dst}")
    os.system(f"sudo ln -s {src} {dst}")


# share and include
for p in ['share', 'include']:
    work_dir = os.path.join(root, p)
    for path in os.listdir(work_dir):
        cur_file = os.path.join(work_dir, path)
        des_file = os.path.join(DET_DIR, p, path)
        link(cur_file, des_file)

# bin
work_dir = os.path.join(root, 'bin')
for filepath, dirnames, filenames in os.walk(work_dir):
    for filename in filenames:
        cur_file = os.path.join(filepath, filename)
        des_file = os.path.join(DET_DIR+'/bin', filename)
        link(cur_file, des_file)


# lib
work_dir = os.path.join(root, 'lib')
for path in os.listdir(work_dir):
    if path not in ['cmake', 'pkgconfig']:
        cur_dir = os.path.join(work_dir, path)
        for filename in os.listdir(cur_dir):
            cur_file = os.path.join(cur_dir, filename)
            des_file = os.path.join(DET_DIR+'/lib', filename)
            link(cur_file, des_file)

    elif path == 'cmake':
        cur_dir = os.path.join(work_dir, path)
        for filename in os.listdir(cur_dir):
            cur_file = os.path.join(cur_dir, filename)
            des_file = os.path.join(DET_DIR+'/lib/cmake', filename)
            link(cur_file, des_file)

    else:
        cur_dir = os.path.join(work_dir, path)
        for filepath, dirnames, filenames in os.walk(cur_dir):
            for filename in filenames:
                cur_file = os.path.join(filepath, filename)
                des_file = os.path.join(DET_DIR+'/lib/pkgconfig', filename)
                link(cur_file, des_file)
