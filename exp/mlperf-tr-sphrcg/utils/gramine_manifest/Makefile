# Use one of these commands to build the manifest for Bash:
#
# - make
# - make DEBUG=1
# - make SGX=1
# - make SGX=1 DEBUG=1
#
# Use `make clean` to remove Gramine-generated files.

ARCH_LIBDIR ?= /lib/$(shell gcc -dumpmachine)

APP_BINARY_PATH ?= /home/mlcask/sgx/encfspython/build/bin/encfspython

# Relative path to Gramine root and key for enclave signing
SGX_SIGNER_KEY ?= $(HOME)/.config/gramine/enclave-key.pem

EXEC_DIR = /bin

ifeq ($(DEBUG),1)
GRAMINE_LOG_LEVEL = trace
else
GRAMINE_LOG_LEVEL = error 
endif

.PHONY: all
all: encfspython.manifest # python.manifest
ifeq ($(SGX),1)
all: encfspython.manifest.sgx encfspython.sig encfspython.token # python.manifest.sgx python.sig python.token
endif

encfspython.manifest: encfspython.manifest.py39.toml
	gramine-manifest \
		-Dlog_level=$(GRAMINE_LOG_LEVEL) \
		-Darch_libdir=$(ARCH_LIBDIR) \
		-Dexecdir=$(EXEC_DIR) \
		-Dentrypoint=$(APP_BINARY_PATH) \
		-Dhome=$(HOME) \
		$< >$@

encfspython.manifest.sgx: encfspython.manifest
	@test -s $(SGX_SIGNER_KEY) || \
	    { echo "SGX signer private key was not found, please specify SGX_SIGNER_KEY!"; exit 1; }
	gramine-sgx-sign \
		--key $(SGX_SIGNER_KEY) \
		--manifest $< \
		--output $@

encfspython.sig: encfspython.manifest.sgx

encfspython.token: encfspython.sig
	gramine-sgx-get-token --output $@ --sig $<


ifeq ($(SGX),)
GRAMINE = gramine-direct
else
GRAMINE = gramine-sgx
endif

.PHONY: clean
clean:
	$(RM) *.manifest *.manifest.sgx *.token *.sig

.PHONY: distclean
distclean: clean
