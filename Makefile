default: all

# load lab preliminaries
include $(ARCHLAB_ROOT)/lab.make

# this should not be alterable, because it's not allowed by lab.py
PROTECTED_OPTION=safe!

# load user config
include $(BUILD)config.env

# Implement an configuration option
ifeq ($(TEST_OPTION),first)
OPT_VAL=1
endif
ifeq ($(TEST_OPTION),second)
OPT_VAL=2
endif
OPT_VAL?=0

# Build infrastructure
include $(ARCHLAB_ROOT)/compile.make

# Handle devel mode
ifeq ($(DEVEL_MODE),yes)
CMD_LINE_ARGS=--calc double=magic*2 
MESSAGE=yes devel
else
CMD_LINE_ARGS=--calc double=magic*2 --engine PAPI --stat inst_count=PAPI_TOT_INS
MESSAGE=no devel
endif

all: opt_val.out message.out protected.out answer.out 1.out code.out 

opt_val.out: 
	echo $(OPT_VAL) > $@
message.out: 
	echo $(MESSAGE) >> $@
protected.out: 
	echo $(PROTECTED_OPTION) >> $@
answer.out: 
	echo $(THE_ANSWER) >> $@

1.out:$(BUILD)1.inp
	cp $^ $@

%.exe : $(BULID)%.o 
	$(CXX) $^ $(LDFLAGS) -o $@

clean: lab-clean
lab-clean:
	rm -rf *.out

# include other rules
include local.mk


test: test.bats Makefile
	bats test.bats
