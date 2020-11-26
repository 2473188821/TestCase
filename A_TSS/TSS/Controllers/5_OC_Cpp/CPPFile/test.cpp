//
//  test.cpp
//  ObjectiveBridge
//
//  Created by Chenfy on 2019/8/28.
//  Copyright © 2019 Chenfy. All rights reserved.
//

#include "test.hpp"

#include <iostream>

Box::Box()
{
    
}

Box::~Box()
{
    
}

double Box::boxArea()
{
    return length * width * height;
}

void BigBox::test()
{
    length = 1;
    width = 3.0;
    height = 5.2;
}

void testBoxx(){
    Box *box = new Box();
    box->boxArea();
    
    
    Box box1;
    box1.boxArea();
    
    Box *boxArray = new Box[4];
    boxArray[0] = box1;
}
