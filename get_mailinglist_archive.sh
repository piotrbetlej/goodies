#!/bin/sh

#set -x
#set -o

DNLD_PATH=https://lists.openwrt.org/pipermail/openwrt-devel/
fdnld_path=${DNLD_PATH}

wget ${DNLD_PATH}

# String containing file list to be downloaded
dnld_list=`cat index.html | grep -o -E "\".*\.txt\.gz\"" | sed 's/"//g' | awk -v path=${fdnld_path} '{print path$1}'`
# echo ${dnld_list}


full_archive=openwrt_full_arch.txt
rm -rf ${full_archive}

for arch in ${dnld_list}
do
    # echo ${arch}
    curl ${arch} | gunzip - >> ${full_archive}
done
