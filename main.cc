#include <iostream>
#include "example.h"
extern Example global_f;
Example global_main(global_f.val);

int main() {
    std::cout << "got " << global_main.val << '\n';
}
