#!/bin/bash

for i in {1..2}; do
  echo "rm -rf /mnt/ramdisk/encfs/out/*"
  rm -rf /mnt/ramdisk/encfs/out/*
  echo "{ time env SECCASK_PROFILE_IO=1 taskset -c 0-7 gramine-sgx gramine_manifest/encfspython --key ENCFSPYTHON --input create_pretraining_data.py --args --input_file=/mnt/ramdisk/encfs/wiki,--output_file=/mnt/ramdisk/encfs/out,--vocab_file=/mnt/ramdisk/encfs/wiki_vocab.txt,--do_lower_case=True,--max_seq_length=512,--max_predictions_per_seq=76,--masked_lm_prob=0.15,--random_seed=12345,--dupe_factor=10; } > sgx-encfs_minfa-aes256gcm-iosize-${i}.log 2>&1"
  { time env SECCASK_PROFILE_IO=1 taskset -c 0-7 gramine-sgx gramine_manifest/encfspython --key ENCFSPYTHON --input create_pretraining_data.py --args --input_file=/mnt/ramdisk/encfs/wiki,--output_file=/mnt/ramdisk/encfs/out,--vocab_file=/mnt/ramdisk/encfs/wiki_vocab.txt,--do_lower_case=True,--max_seq_length=512,--max_predictions_per_seq=76,--masked_lm_prob=0.15,--random_seed=12345,--dupe_factor=10; } > sgx-encfs_minfa-aes256gcm-iosize-${i}.log 2>&1
done