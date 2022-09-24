When replacing the soname of a library with its absolute path, the init order
can be different than expected.

Given main <- libf.so <- libg.so, normally libg.so initializes first, then
libf.so, but if we replace the soname of libg.so with an absolute path, and
then preload another libg.so, the latter gets loaded after libf.so.

```
$ make clean && make USE_PATH_AS_SONAME=0 test
rm -rf main 1/ 2/
g++ -DDEFAULT_VALUE=1 -shared -fpic -o 1/libg.so g.cc -Wl,--soname,libg.so
g++ -shared -fpic -o libf.so f.cc -Wl,--soname,libf.so -L1 -lg -Wl,-rpath,1
g++ -o main main.cc -L. -lf -Wl,-rpath,.
g++ -DDEFAULT_VALUE=2 -shared -fpic -o 2/libg.so g.cc -Wl,--soname,libg.so
Without LD_PRELOAD
./main
init with 1
init with 1
init with 1
got 1
With LD_PRELOAD:
LD_PRELOAD=2/libg.so ./main
init with 2
init with 2
init with 2
got 2
```

vs

```
$ make clean && make USE_PATH_AS_SONAME=1 test
rm -rf main 1/ 2/
g++ -DDEFAULT_VALUE=1 -shared -fpic -o 1/libg.so g.cc -Wl,--soname,1/libg.so
g++ -shared -fpic -o libf.so f.cc -Wl,--soname,libf.so -L1 -lg -Wl,-rpath,1
g++ -o main main.cc -L. -lf -Wl,-rpath,.
g++ -DDEFAULT_VALUE=2 -shared -fpic -o 2/libg.so g.cc -Wl,--soname,libg.so
Without LD_PRELOAD
./main
init with 1
init with 1
init with 1
got 1
With LD_PRELOAD:
LD_PRELOAD=2/libg.so ./main
init with 1
init with 1
init with 2
init with 1
got 1
```
