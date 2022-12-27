#!/bin/bash

for i in {1..2}; do
  echo "rm -rf /mnt/ramdisk/encfs/*.npz"
  rm -rf /mnt/ramdisk/encfs/*.npz
  echo "{ time env SECCASK_PROFILE_IO=1 gramine-sgx gramine_manifest/encfspython --key ENCFSPYTHON --input data_utils.py --args --data-set=terabyte,--raw-data-file=/mnt/ramdisk/encfs/day,--processed-data-file=/mnt/ramdisk/encfs/out; } > /data1/mlcask/logs/io_size/mlperf-tr-recomm/sgx-encfs_minfa-aes256gcm-iosize-${i}.log 2>&1"
  { time env SECCASK_PROFILE_IO=1 gramine-sgx gramine_manifest/encfspython --key ENCFSPYTHON --input data_utils.py --args --data-set=terabyte,--raw-data-file=/mnt/ramdisk/encfs/day,--processed-data-file=/mnt/ramdisk/encfs/out; } > /data1/mlcask/logs/io_size/mlperf-tr-recomm/sgx-encfs_minfa-aes256gcm-iosize-${i}.log 2>&1
done

# for i in {1..1}; do
#   echo "rm -rf /mnt/ramdisk/raw/*.npz"
#   rm -rf /mnt/ramdisk/raw/*.npz
#   echo "{ time env SECCASK_PROFILE_IO=1 gramine-sgx gramine_manifest/encfspython --input data_utils.py --args --data-set=terabyte,--raw-data-file=/mnt/ramdisk/raw/day,--processed-data-file=/mnt/ramdisk/raw/out; } > sgx-raw-io-${i}.log 2>&1"
#   { time env SECCASK_PROFILE_IO=1 gramine-sgx gramine_manifest/encfspython --input data_utils.py --args --data-set=terabyte,--raw-data-file=/mnt/ramdisk/raw/day,--processed-data-file=/mnt/ramdisk/raw/out; } > sgx-raw-io-${i}.log 2>&1
# done

# for i in {1..1}; do
#   echo "rm -rf /mnt/ramdisk/protectedfs/*.npz"
#   rm -rf /mnt/ramdisk/protectedfs/*.npz
#   echo "{ time env SECCASK_PROFILE_IO=1 gramine-sgx gramine_manifest/encfspython --input data_utils.py --args --data-set=terabyte,--raw-data-file=/mnt/ramdisk/protectedfs/day,--processed-data-file=/mnt/ramdisk/protectedfs/out; } > sgx-pfs-io-${i}.log 2>&1"
#   { time env SECCASK_PROFILE_IO=1 gramine-sgx gramine_manifest/encfspython --input data_utils.py --args --data-set=terabyte,--raw-data-file=/mnt/ramdisk/protectedfs/day,--processed-data-file=/mnt/ramdisk/protectedfs/out; } > sgx-pfs-io-${i}.log 2>&1
# done

# taskset -c 16-23 gramine-sgx gramine_manifest/encfspython --input data_utils.py --args --data-set=terabyte,--raw-data-file=/mnt/ramdisk/raw/day,--processed-data-file=/mnt/ramdisk/raw/out > sgx-raw.log 2>&1
# gramine-sgx gramine_manifest/encfspython --key ENCFSPYTHON --input data_utils.py --args --data-set=terabyte,--raw-data-file=/mnt/ramdisk/encfs/day,--processed-data-file=/mnt/ramdisk/encfs/out > sgx-encfs_minfa-aes256gcm.log 2>&1
# taskset -c 8-15 gramine-sgx gramine_manifest/encfspython --input data_utils.py --args --data-set=terabyte,--raw-data-file=/mnt/ramdisk/protectedfs/day,--processed-data-file=/mnt/ramdisk/protectedfs/out > sgx-pfs.log 2>&1