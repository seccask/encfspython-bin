#!/bin/bash

for i in {1..2}; do
  echo "rm -rf /mnt/ramdisk/encfs/*"
  rm -rf /mnt/ramdisk/encfs/*
  echo "{ time env taskset -c 16 gramine-sgx gramine_manifest/encfspython --key ENCFSPYTHON --input imagenet_to_gcs.py --args --raw_data_dir=/data0/mlcask/ILSVRC/Data/CLS-LOC,--local_scratch_dir=/mnt/ramdisk/encfs,--nogcs_upload; } > ~/sgx/logs/io_size/mlperf-tr-imgcls/sgx-encfs_minfa-aes256gcm-iosize-${i}.log 2>&1"
  { time env taskset -c 16 gramine-sgx gramine_manifest/encfspython --key ENCFSPYTHON --input imagenet_to_gcs.py --args --raw_data_dir=/data0/mlcask/ILSVRC/Data/CLS-LOC,--local_scratch_dir=/mnt/ramdisk/encfs,--nogcs_upload; } > ~/sgx/logs/io_size/mlperf-tr-imgcls/sgx-encfs_minfa-aes256gcm-iosize-${i}.log 2>&1
done

# /home/mlcask/sgx/encfspython/build/bin/encfspython --input imagenet_to_gcs.py --args --raw_data_dir=/data0/mlcask/ILSVRC/Data/CLS-LOC,--local_scratch_dir=/data0/mlcask/out,--nogcs_upload
# exit 0

# python imagenet_to_gcs.py --raw_data_dir=/data0/mlcask/ILSVRC/Data/CLS-LOC --local_scratch_dir=/data0/mlcask/out --nogcs_upload
# exit 0

# sleep 100
# taskset -c 16 gramine-sgx gramine_manifest/encfspython --key ENCFSPYTHON --input create_pretraining_data.py --args --input_file=/mnt/ramdisk/encfs/wiki,--output_file=/mnt/ramdisk/encfs/out,--vocab_file=/mnt/ramdisk/encfs/wiki_vocab.txt,--do_lower_case=True,--max_seq_length=512,--max_predictions_per_seq=76,--masked_lm_prob=0.15,--random_seed=12345,--dupe_factor=10 > sgx-encfs_minfa-aes256sha256_avx2-io.log 2>&1 &
# sleep 100
# taskset -c 16 gramine-sgx gramine_manifest/encfspython --input create_pretraining_data.py --args --input_file=/mnt/ramdisk/protectedfs/wiki,--output_file=/mnt/ramdisk/protectedfs/out,--vocab_file=/mnt/ramdisk/protectedfs/wiki_vocab.txt,--do_lower_case=True,--max_seq_length=512,--max_predictions_per_seq=76,--masked_lm_prob=0.15,--random_seed=12345,--dupe_factor=10 > sgx-pfs-io.log 2>&1 &
