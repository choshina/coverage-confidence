SH=$(wildcard test/benchmark/*)
CSV=$(SH:test/benchmark/%=results/%.csv)
DIRS=results output

.PHONY: all scalac

all: $(DIRS) $(CSV)
	# git commit -m "new benchmark results"

results:
	mkdir -p $@

output:
	mkdir -p $@

results/%.csv: test/benchmark/%
	./run $* $< $@
	# git add $@
	
results/at-breach-cmaes.csv: src/test/matlab/AT.m

scalac:
	scalac -d bin -cp lib/engine.jar `find src/main/scala src/test/scala/hybrid/benchmarks -iname "*.scala"`

benchmarks.jar: Manifest.txt
	jar cfm $@ Manifest.txt -C bin .
clean:
	rm *.dat *.mat *.slxc *mex*
