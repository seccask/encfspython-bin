#!/usr/bin/env bash

START=2
END=5

MANIFEST=cs_autolearn

### FUNCTION: copy_worker_log
### DESCRIPTION: Copy the worker log to the log directory
### INPUT: $1 - worker log dir
### OUTPUT: None
### RETURN: None
copy_worker_log () {
  mkdir -p $1
  cp ${HOME}/seccask-temp/*.log $1
}

clean_workspace () {
  nohup ssh ustore@localhost \
    'source $HOME/.ledgebase_profile; cd $HOME/ledgebase_release; ./bin/ustore_clean.sh; ./bin/ustore_start.sh' \
    >/dev/null 2>/dev/null &
  sleep 10

  cd ..
  ./clean_cache.sh ; ./clean_storage.sh ; ./kill_processes.sh
  cd ./test
}

### Loop experiments (SGX, FS, PAC)
# LOG_DIR=sa_nopac_torch141_fscopy
LOG_DIR=autolearn_pac_fscopy

for ((i=START;i<=END;i++)); do
  EXP_NAME="sgx-encfs-`printf "%02d\n" ${i}`"
  WORKER_LOG_DIR="${HOME}/sgx/logs/${LOG_DIR}/${EXP_NAME}"

  echo "${EXP_NAME} start"
  
  clean_workspace
  echo "${EXP_NAME} workspace cleaned"
  
  echo "SGX=1 APP_HOME=${HOME}/sgx/seccask2 PYTHONHOME=${HOME}/sgx/lib/cpython-3.9.13-install \
    PYTHONPATH=${HOME}/sgx/seccask2/pysrc \
    gramine-sgx ../gramine_manifest/seccask --coordinator --mode=tls --manifest=${MANIFEST} -k SECCASK_TEST_KEY \
    > \"${WORKER_LOG_DIR}.log\" 2>&1"
  SGX=1 APP_HOME=${HOME}/sgx/seccask2 PYTHONHOME=${HOME}/sgx/lib/cpython-3.9.13-install \
    PYTHONPATH=${HOME}/sgx/seccask2/pysrc \
    gramine-sgx ../gramine_manifest/seccask --coordinator --mode=tls --manifest=${MANIFEST} -k SECCASK_TEST_KEY \
    > "${WORKER_LOG_DIR}.log" 2>&1
  
  copy_worker_log $WORKER_LOG_DIR
  echo "${EXP_NAME} worker log copied"
  
  echo "${EXP_NAME} done"
done


### Loop experiments (Raw, PAC)
# LOG_DIR=sa_pac_torch141_02
# sed -i 's/enable_compatibility_check_on_caching = false/enable_compatibility_check_on_caching = true/g' ${HOME}/sgx/seccask2/.conf/config.ini

# for ((i=START;i<=END;i++)); do
#   EXP_NAME="raw-`printf "%02d\n" ${i}`"
#   WORKER_LOG_DIR="${HOME}/sgx/logs/${LOG_DIR}/${EXP_NAME}"

#   echo "${EXP_NAME} start"

#   clean_workspace
#   echo "${EXP_NAME} workspace cleaned"

#   echo "APP_HOME=${HOME}/sgx/seccask2 PYTHONHOME=${HOME}/sgx/lib/cpython-3.9.13-install \
#     PYTHONPATH=${HOME}/sgx/seccask2/pysrc \
#     ../build/bin/seccask --coordinator --mode=tls --manifest=${MANIFEST} > \"${WORKER_LOG_DIR}.log\" 2>&1"
#   APP_HOME=${HOME}/sgx/seccask2 PYTHONHOME=${HOME}/sgx/lib/cpython-3.9.13-install \
#     PYTHONPATH=${HOME}/sgx/seccask2/pysrc \
#     ../build/bin/seccask --coordinator --mode=tls --manifest=${MANIFEST} > "${WORKER_LOG_DIR}.log" 2>&1
  
#   copy_worker_log $WORKER_LOG_DIR
#   echo "${EXP_NAME} worker log copied"
  
#   echo "${EXP_NAME} done"
# done

### Loop experiments (Raw, FS, No PAC)
# LOG_DIR=autolearn_nopac
# sed -i 's/enable_compatibility_check_on_caching = true/enable_compatibility_check_on_caching = false/g' ${HOME}/sgx/seccask2/.conf/config.ini

# for ((i=START;i<=END;i++)); do
#   EXP_NAME="raw-`printf "%02d\n" ${i}`"
#   WORKER_LOG_DIR="${HOME}/sgx/logs/${LOG_DIR}/${EXP_NAME}"

#   echo "${EXP_NAME} start"

#   clean_workspace
#   echo "${EXP_NAME} workspace cleaned"

#   echo "APP_HOME=${HOME}/sgx/seccask2 PYTHONHOME=${HOME}/sgx/lib/cpython-3.9.13-install \
#     PYTHONPATH=${HOME}/sgx/seccask2/pysrc \
#     ../build/bin/seccask --coordinator --mode=tls --manifest=${MANIFEST} > \"${WORKER_LOG_DIR}.log\" 2>&1"
#   APP_HOME=${HOME}/sgx/seccask2 PYTHONHOME=${HOME}/sgx/lib/cpython-3.9.13-install \
#     PYTHONPATH=${HOME}/sgx/seccask2/pysrc \
#     ../build/bin/seccask --coordinator --mode=tls --manifest=${MANIFEST} > "${WORKER_LOG_DIR}.log" 2>&1
  
#   copy_worker_log $WORKER_LOG_DIR
#   echo "${EXP_NAME} worker log copied"
  
#   echo "${EXP_NAME} done"
# done
