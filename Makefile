all: main 2/libf.so

1/libf.so: f.cc
	@mkdir -p $(dir $@)
	$(CXX) -DDEFAULT_VALUE=1 -shared -fpic -o $@ $< -Wl,--soname,$@

2/libf.so: f.cc
	@mkdir -p $(dir $@)
	$(CXX) -DDEFAULT_VALUE=2 -shared -fpic -o $@ $< -Wl,--soname,$@

main: main.cc 1/libf.so
	$(CXX) -o $@ main.cc -L1 -lf '-Wl,-rpath,./1'

clean:
	rm -rf main 1/ 2/
