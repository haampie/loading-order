#include <iostream>

class Example
{
public:
    int val;
    Example(int val) : val(val) { std::cout << "init with " << val << '\n'; }
};

Example dep(DEFAULT_VALUE);
