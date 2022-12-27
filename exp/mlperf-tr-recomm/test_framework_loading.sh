#!/bin/bash

# SETUP=framework_raw_02
# mkdir -p ~/sgx/logs/${SETUP}

# for i in {1..5}; do
#   for FRAMEWORK in sklearn tensorflow pytorch; do
#     echo "{ taskset -c 48 /usr/bin/time -p env PYTHONHOME=~/sgx/lib/cpython-3.9.13-install PYTHONPATH=~/scvenv-autolearn/lib/python3.9/site-packages ~/sgx/encfspython/build/bin/encfspython --key ENCFSPYTHON --input ./test_framework_loading_${FRAMEWORK}.py ; } > ~/sgx/logs/${SETUP}/${FRAMEWORK}-${i}.log 2>&1"
#     { taskset -c 48 /usr/bin/time -p env PYTHONHOME=~/sgx/lib/cpython-3.9.13-install PYTHONPATH=~/scvenv-autolearn/lib/python3.9/site-packages ~/sgx/encfspython/build/bin/encfspython --key ENCFSPYTHON --input ./test_framework_loading_${FRAMEWORK}.py ; } > ~/sgx/logs/${SETUP}/${FRAMEWORK}-${i}.log 2>&1
#   done
# done

SETUP=framework_sgx_with_heap_size
mkdir -p ~/sgx/logs/${SETUP}

for MAX_HEAP_MB in 262144 131072 65536; do\
  sed -i "s/sgx.enclave_size = .*/sgx.enclave_size = \"${MAX_HEAP_MB}M\"/" ./gramine_manifest/encfspython.manifest.py39.toml
  cd ./gramine_manifest && make clean && make && make SGX=1 && cd ..
  for FRAMEWORK in sklearn tensorflow pytorch; do
    for i in {1..5}; do
      echo "{ taskset -c 48 /usr/bin/time -p gramine-sgx gramine_manifest/encfspython --key ENCFSPYTHON --input ./test_framework_loading_${FRAMEWORK}.py ; } > ~/sgx/logs/${SETUP}/${FRAMEWORK}-${MAX_HEAP_MB}MB-${i}.log 2>&1"
      { taskset -c 48 /usr/bin/time -p gramine-sgx gramine_manifest/encfspython --key ENCFSPYTHON --input ./test_framework_loading_${FRAMEWORK}.py ; } > ~/sgx/logs/${SETUP}/${FRAMEWORK}-${MAX_HEAP_MB}MB-${i}.log 2>&1
    done
  done
done
