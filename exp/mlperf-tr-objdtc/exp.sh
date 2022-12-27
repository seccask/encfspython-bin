#!/bin/bash

for i in {1..2}; do
  echo "rm -rf /mnt/ramdisk/encfs/out/*"
  rm -rf /mnt/ramdisk/encfs/out/*
  echo "{ time env SECCASK_PROFILE_IO=1 gramine-sgx gramine_manifest/encfspython --key ENCFSPYTHON --input convert_cityscapes_to_coco.py --args --dataset=cityscapes_instance_only,--datadir=/mnt/ramdisk/encfs/cityscapes,--outdir=/mnt/ramdisk/encfs/out; } > /data1/mlcask/logs/io_size/mlperf-tr-objdtct/sgx-encfs_minfa-aes256gcm-iosize-${i}.log 2>&1"
  { time env SECCASK_PROFILE_IO=1 gramine-sgx gramine_manifest/encfspython --key ENCFSPYTHON --input convert_cityscapes_to_coco.py --args --dataset=cityscapes_instance_only,--datadir=/mnt/ramdisk/encfs/cityscapes,--outdir=/mnt/ramdisk/encfs/out; } > /data1/mlcask/logs/io_size/mlperf-tr-objdtct/sgx-encfs_minfa-aes256gcm-iosize-${i}.log 2>&1
done

# echo 'taskset -c 0 gramine-sgx gramine_manifest/encfspython --key ENCFSPYTHON --input create_pretraining_data.py --args --input_file=/data0/mlcask/wiki,--output_file=/mnt/ramdisk/encfs,--vocab_file=/data0/mlcask/wiki_vocab.txt,--do_lower_case=True,--max_seq_length=512,--max_predictions_per_seq=76,--masked_lm_prob=0.15,--random_seed=12345,--dupe_factor=1 > sgx-encfs_minfa-aes256sha256_avx2.log 2>&1'
# taskset -c 0 gramine-sgx gramine_manifest/encfspython --key ENCFSPYTHON --input create_pretraining_data.py --args --input_file=/data0/mlcask/wiki,--output_file=/mnt/ramdisk/encfs,--vocab_file=/data0/mlcask/wiki_vocab.txt,--do_lower_case=True,--max_seq_length=512,--max_predictions_per_seq=76,--masked_lm_prob=0.15,--random_seed=12345,--dupe_factor=1 > sgx-encfs_minfa-aes256sha256_avx2.log 2>&1
# echo 'rm -rf /mnt/ramdisk/encfs/*'
# rm -rf /mnt/ramdisk/encfs/*
# echo 'taskset -c 0 gramine-sgx gramine_manifest/encfspython --input create_pretraining_data.py --args --input_file=/data0/mlcask/wiki,--output_file=/mnt/ramdisk/raw,--vocab_file=/data0/mlcask/wiki_vocab.txt,--do_lower_case=True,--max_seq_length=512,--max_predictions_per_seq=76,--masked_lm_prob=0.15,--random_seed=12345,--dupe_factor=1 > sgx-raw.log 2>&1'
# taskset -c 0 gramine-sgx gramine_manifest/encfspython --input create_pretraining_data.py --args --input_file=/data0/mlcask/wiki,--output_file=/mnt/ramdisk/raw,--vocab_file=/data0/mlcask/wiki_vocab.txt,--do_lower_case=True,--max_seq_length=512,--max_predictions_per_seq=76,--masked_lm_prob=0.15,--random_seed=12345,--dupe_factor=1 > sgx-raw.log 2>&1
# echo 'rm -rf /mnt/ramdisk/raw/*'
# rm -rf /mnt/ramdisk/raw/*
# echo 'taskset -c 0 gramine-sgx gramine_manifest/encfspython --input create_pretraining_data.py --args --input_file=/data0/mlcask/wiki,--output_file=/mnt/ramdisk/protectedfs,--vocab_file=/data0/mlcask/wiki_vocab.txt,--do_lower_case=True,--max_seq_length=512,--max_predictions_per_seq=76,--masked_lm_prob=0.15,--random_seed=12345,--dupe_factor=1 > sgx-pfs-2.log 2>&1'
# taskset -c 0 gramine-sgx gramine_manifest/encfspython --input create_pretraining_data.py --args --input_file=/data0/mlcask/wiki,--output_file=/mnt/ramdisk/protectedfs,--vocab_file=/data0/mlcask/wiki_vocab.txt,--do_lower_case=True,--max_seq_length=512,--max_predictions_per_seq=76,--masked_lm_prob=0.15,--random_seed=12345,--dupe_factor=1 > sgx-pfs-2.log 2>&1
# echo 'rm -rf /mnt/ramdisk/raw/*'
# rm -rf /mnt/ramdisk/protectedfs/*

# taskset -c 16-23 gramine-sgx gramine_manifest/encfspython --input convert_cityscapes_to_coco.py --args --dataset=cityscapes_instance_only,--datadir=/mnt/ramdisk/raw,--outdir=/mnt/ramdisk/raw > sgx-raw-x.log 2>&1 &
# taskset -c 0-7 gramine-sgx gramine_manifest/encfspython --key ENCFSPYTHON --input convert_cityscapes_to_coco.py --args --dataset=cityscapes_instance_only,--datadir=/mnt/ramdisk/encfs,--outdir=/mnt/ramdisk/encfs > sgx-encfs_minfa-aes256gcm-x.log 2>&1 &
# taskset -c 8-15 gramine-sgx gramine_manifest/encfspython --input convert_cityscapes_to_coco.py --args --dataset=cityscapes_instance_only,--datadir=/mnt/ramdisk/protectedfs,--outdir=/mnt/ramdisk/protectedfs > sgx-pfs-x.log 2>&1 &