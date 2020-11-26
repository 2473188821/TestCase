//
//  CClient.cpp
//  ObjectiveBridge
//
//  Created by Chenfy on 2019/8/25.
//  Copyright © 2019 Chenfy. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <assert.h>

#include "CClient.hpp"
#include <iostream>

using namespace std;

OSystem *osystem = NULL;

OSystem::OSystem(){
    _renderWindow = (RenderWindow *)malloc(sizeof(RenderWindow));
}

OSystem::~OSystem(){
    std::cout <<  "hello";
    cout  <<  "world!";
    free(_renderWindow);
}

void OSystem::exit(){
    if (osystem) {
        delete osystem;
        osystem = NULL;
    }
}

OSystem *OSystem_init(){
    if (!osystem)
        osystem = new OSystem();
    return osystem;
}

OSystem *OSystem::OSystem_init(){
    if (!osystem)
        osystem = new OSystem();
    return osystem;
}

void OSystem::startEngine(const char *str){
    printf("\n--%s--\n",str);
}

int OSystem::getChannelList(char *data){
    if (data) {
        strcpy(data, "string from c++");
    }
    if (_renderWindow->Render) {
        _renderWindow->Render();
    }
    return 1;
}
