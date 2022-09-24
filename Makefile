.PHONY: all test

all: main 2/libg.so

USE_PATH_AS_SONAME = 1

ifeq ($(USE_PATH_AS_SONAME),1)
SONAME = $@
else
SONAME = $(notdir $@)
endif

1/libg.so: g.cc
	@mkdir -p $(dir $@)
	$(CXX) -DDEFAULT_VALUE=1 -shared -fpic -o $@ $< -Wl,--soname,$(SONAME)

2/libg.so: g.cc
	@mkdir -p $(dir $@)
	$(CXX) -DDEFAULT_VALUE=2 -shared -fpic -o $@ $< -Wl,--soname,$(notdir $@)

libf.so: f.cc 1/libg.so
	$(CXX) -shared -fpic -o $@ $< -Wl,--soname,libf.so -L1 -lg -Wl,-rpath,1

main: main.cc libf.so
	$(CXX) -o $@ main.cc -L. -lf -Wl,-rpath,.

test: main 2/libg.so
	@echo "Without LD_PRELOAD"
	./main
	@echo "With LD_PRELOAD:"
	LD_PRELOAD=2/libg.so ./main

clean:
	rm -rf main 1/ 2/
