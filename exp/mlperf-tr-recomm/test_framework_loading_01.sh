#!/bin/bash
SETUP=framework_raw_with_heap_size

mkdir -p ~/sgx/logs/${SETUP}

for i in {1..5}; do
  FRAMEWORK=sklearn
  MAX_HEAP_MB=32768
  echo "env PYTHONHOME=~/sgx/lib/cpython-3.9.13-install PYTHONPATH=~/scvenv-autolearn/lib/python3.9/site-packages ~/sgx/encfspython/build/bin/encfspython --key ENCFSPYTHON --input ./test_framework_loading.py > ~/sgx/logs/${SETUP}/${FRAMEWORK}-${MAX_HEAP_MB}MB-${i}.log 2>&1"
  env PYTHONHOME=~/sgx/lib/cpython-3.9.13-install PYTHONPATH=~/scvenv-autolearn/lib/python3.9/site-packages ~/sgx/encfspython/build/bin/encfspython --key ENCFSPYTHON --input ./test_framework_loading.py > ~/sgx/logs/${SETUP}/${FRAMEWORK}-${MAX_HEAP_MB}MB-${i}.log 2>&1

  # echo "gramine-sgx gramine_manifest/encfspython --key ENCFSPYTHON --input ./test_framework_loading.py > ~/sgx/logs/${SETUP}/${FRAMEWORK}-${i}.log 2>&1"
  # gramine-sgx gramine_manifest/encfspython --key ENCFSPYTHON --input ./test_framework_loading.py > ~/sgx/logs/${SETUP}/${FRAMEWORK}-${i}.log 2>&1
done