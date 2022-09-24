#include <iostream>

class Example;

extern Example dep;

class Example
{
public:
    int val;
    Example() : val(dep.val) {}
};

Example my_global;

int main() {
    std::cout << my_global.val << '\n';
}
