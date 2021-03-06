#
# Copyright (c) 2019 Nutanix Inc. All rights reserved.
#
# Authors: Thanos Makatos <thanos@nutanix.com>
#          Swapnil Ingle <swapnil.ingle@nutanix.com>
#          Felipe Franciosi <felipe@nutanix.com>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of Nutanix nor the names of its contributors may be
#       used to endorse or promote products derived from this software without
#       specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

BUILD_TYPE ?= dbg

ifeq ($(BUILD_TYPE), dbg)
	CMAKE_BUILD_TYPE = Debug
    CFLAGS += -DDEBUG
else
	CMAKE_BUILD_TYPE = Release
	CFLAGS += -DNDEBUG
endif

ifeq ($(VERBOSE),)
	MAKEFLAGS += -s
endif

BUILD_DIR_BASE = $(CURDIR)/build
BUILD_DIR = $(BUILD_DIR_BASE)/$(BUILD_TYPE)

KDIR ?= "/lib/modules/$(shell uname -r)/build"

PHONY_TARGETS := all realclean buildclean force_cmake export install-export tags

.PHONY: $(PHONY_TARGETS)

all $(filter-out $(PHONY_TARGETS), $(MAKECMDGOALS)): $(BUILD_DIR)/Makefile
	+$(MAKE) -C $(BUILD_DIR) $@

realclean:
	rm -rf $(BUILD_DIR_BASE)

buildclean:
	rm -rf $(BUILD_DIR)

force_cmake: $(BUILD_DIR)/Makefile

$(BUILD_DIR)/Makefile:
	mkdir -p $(BUILD_DIR)
	cd $(BUILD_DIR); cmake \
		-D "CMAKE_C_FLAGS:STRING=$(CFLAGS)" \
		-D "CMAKE_BUILD_TYPE:STRING=$(CMAKE_BUILD_TYPE)" \
		-D "KDIR=$(KDIR)" \
		$(CURDIR)

tags:
	ctags -R --exclude=$(BUILD_DIR)
