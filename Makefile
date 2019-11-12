default: default.out

PROTECTED_OPTION=safe!

include $(BUILD)/config.env

ifeq ($(TEST_OPTION),first)
OPT_VAL=1
endif

ifeq ($(TEST_OPTION),second)
OPT_VAL=2
endif

include $(ARCHLAB_ROOT)/lab.make

ifeq ($(DEVEL_MODE),yes)
MESSAGE=Devel is set
else
MESSAGE=Devel is not set
endif

default.out:
	echo $(OPT_VAL) > $@
	echo $(MESSAGE) >> $@
	echo $(PROTECTED_OPTION) >> $@
	echo $(THE_ANSWER) >> $@

code.out: code.exe
	
include local.mk

