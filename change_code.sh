#!/bin/sh
set -x

ROOT_DIR=.
PATTERN="std::thread\(.*\,.*\);"
MATCHES=`grep -E -R -n "${PATTERN}" ${ROOT_DIR} | awk 'BEGIN {FS=":";OFS=","}{ print$1,$2}'`
for m in ${MATCHES}; do
    ln=`echo ${m} | cut -d ',' -f 2`
    fname=`echo ${m} | cut -d ',' -f 1`
    l=`sed -n "${ln}p" ${fname}`
    parenth_cont=`echo ${l} | grep -o -E "\(.*\)" | tr -d "()"`
    fieldnum=`echo ${parenth_cont} | awk 'BEGIN {FS=","}{ print NF}'`
    if (( fieldnum > 2 )); then continue; fi
    func=`echo ${parenth_cont} | cut -d ',' -f 2`
    sed -i -e "s/$func/wrap($func)/g" ${fname}
done
