//
//  test.hpp
//  ObjectiveBridge
//
//  Created by Chenfy on 2019/8/28.
//  Copyright © 2019 Chenfy. All rights reserved.
//

#ifndef test_hpp
#define test_hpp

#include <stdio.h>

#pragma mark -- 命名空间
#pragma mark -- namespace KSA
namespace KSA {
class Man {
public:
    void manEat(){
        
    }
};
    void hello(){
        
    }
}
#pragma mark -- namespace KSB
namespace KSB {
    void hello(){
        
    }
}
#pragma mark -- namespace USE
using namespace KSA;
void func()
{
    hello();
    KSA::hello();
    KSB::hello();
}


class Box{
public:
    double length;
    double width;
    double height;
    
    Box();
    virtual ~Box();
public:
    double boxArea();
    
    Box operator+(const Box &b)
    {
        Box box;
        box.length = length + b.length;
        box.width = width *+ b.width;
        box.height = height  + b.height;
        
        return box;
    }
};

class BigBox:  Box
{
public:
    void test();

};


#pragma mark -- 模板

#include <iostream>
#include <string>

using namespace std;

template <typename T>
inline T const& Max (T const& a, T const& b)
{
    return a < b ? b:a;
}

int mainT ()
{
 
    int i = 39;
    int j = 20;
    cout << "Max(i, j): " << Max(i, j) << endl;
 
    double f1 = 13.5;
    double f2 = 20.7;
    cout << "Max(f1, f2): " << Max(f1, f2) << endl;
 
    string s1 = "Hello";
    string s2 = "World";
    cout << "Max(s1, s2): " << Max(s1, s2) << endl;
 
   return 0;
}






#endif /* test_hpp */
