# sensible default
default: all


# load lab preliminaries
include $(ARCHLAB_ROOT)/lab.make

USER_CFLAGS=-I$(CANELA_ROOT)/googletest/googletest/include

# this should not be alterable, because it's not allowed by lab.py
PROTECTED_OPTION=safe!

# load user config
include $(BUILD)config.env

# Implement an configuration option before loading build infrastructure
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

# Targets defined by the lab creator

all: opt_val.out message.out protected.out answer.out 1.out code.out regression.out out.png

run_tests.exe: run_tests.o
	$(CXX) $^ $(LDFLAGS) -L$(CANELA_ROOT)/googletest/lib -lgtest -lgtest_main  -o $@

regression.out: run_tests.exe
	./run_tests.exe > $@ || true

out.png: in.png
	cp $< $@

opt_val.out: 
	echo $(OPT_VAL) > $@
message.out: 
	echo $(MESSAGE) >> $@
protected.out: 
	echo $(PROTECTED_OPTION) >> $@
answer.out: 
	echo $(THE_ANSWER) >> $@

# consume an input
1.out:$(BUILD)1.inp
	cp $^ $@

# wierd command to test make target filtering
1@.out:$(BUILD)1.inp
	cp $^ $@

# build something
%.exe : $(BULID)%.o 
	$(CXX) $^ $(LDFLAGS) -o $@

# clean up
clean: lab-clean
lab-clean:
	rm -rf *.out run_tests.exe

#  lab test suite.
test: test.bats Makefile
	bats test.bats
