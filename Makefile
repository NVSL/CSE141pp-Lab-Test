# sensible default
default: all run_tests.exe
# this should not be alterable, because it's not allowed by lab.py
PROTECTED_OPTION=safe!

CLEANUP=*.out run_tests.exe out.png

include $(ARCHLAB_ROOT)/cse141.make
include $(BUILD)config.env

# Implement an configuration option before loading build infrastructure
ifeq ($(TEST_OPTION),first)
OPT_VAL=1
endif
ifeq ($(TEST_OPTION),second)
OPT_VAL=2
endif
OPT_VAL?=0

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

out.png: in.png
	cp $< $@

opt_val.out: 
	echo $(OPT_VAL) > $@
message.out: 
	echo $(MESSAGE) >> $@
protected.out: 
	echo $(PROTECTED_OPTION) >> $@
answer.out:  $(BUILD)config.env
	(. $<; echo $$THE_ANSWER) >> $@

# consume an input
1.out:$(BUILD)1.inp
	cp $^ $@

# wierd command to test make target filtering
1@.out:$(BUILD)1.inp
	cp $^ $@


