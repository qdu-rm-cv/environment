#! /usr/bin/python
import os

det_dir = "/usr/local"
paths = ['bin', 'include', 'lib', 'share']

root = os.path.dirname(os.path.abspath(__file__))[0:-5]

for p in paths:
    cur_path = os.path.join(root, p)
    des_path = os.path.join(det_dir, p)
    print(f"-- Refreshing {des_path}")
    for filename in os.listdir(cur_path):
        os.system(f"sudo rm {des_path}/{filename}")
        os.system(f"sudo ln -s {cur_path}/{filename} {des_path}")
