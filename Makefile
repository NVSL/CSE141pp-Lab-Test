.PHONY: default
default: benchmark.csv  cnn.csv cnn.exe #run_tests.exe regressions.out regressions.json

STUDENT_EDITABLE_FILES=opt_cnn.hpp test_file1

OPENMP=yes

OPTIMIZE=-march=x86-64 -O3
CLEANUP=trace_traceme.hdf5 trace_cnn.hdf5
COMPILER=gcc-8
include $(ARCHLAB_ROOT)/cse141.make
$(BUILD)model.s: $(BUILD)opt_cnn.hpp  $(BUILD)opt_cnn.hpp $(BUILD)canary.hpp $(BUILD)model.hpp $(BUILD)reps.hpp $(BUILD)parameters.hpp

MEMOPS?=10000000

#DEVEL_MODE=yes
ifeq ($(DEVEL_MODE),yes)
BENCHMARK_CMD_LINE=--stat runtime=ARCHLAB_WALL_TIME 
else
BENCHMARK_CMD_LINE=--stat-set L1.cfg
endif

FULL_CMD_LINE_ARGS=$(LAB_COMMAND_LINE_ARGS) $(CMD_LINE_ARGS) $(IMPL_SEL_ARGS)

.PHONY: hello
hello:
	cat test_file1
	cat test_file2

cnn.exe:  $(BUILD)parameters.o  $(BUILD)model.o  $(BUILD)canary.o  $(BUILD)reps.o
$(BUILD)model.o:  $(BUILD)opt_cnn.hpp

$(BUILD)cnn.o: $(BUILD)opt_cnn.hpp  $(BUILD)opt_cnn.hpp $(BUILD)canary.hpp $(BUILD)model.hpp $(BUILD)reps.hpp $(BUILD)parameters.hpp

OMP_NUM_THREADS=1
export OMP_NUM_THREADS
benchmark.csv: cnn.exe
	./cnn.exe --run-canary --stats-file $@ --scale 0 --batch-size 1 --function train_model $(BENCHMARK_CMD_LINE)
	pretty-csv $@

cnn.csv: copy-files cnn.exe 
	./cnn.exe --stats-file $@ $(FULL_CMD_LINE_ARGS)  --function fix_weights --test-layer 0 --scale 0
	pretty-csv $@

