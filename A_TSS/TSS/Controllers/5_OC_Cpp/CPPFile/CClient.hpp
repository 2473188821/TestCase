//
//  CClient.hpp
//  ObjectiveBridge
//
//  Created by Chenfy on 2019/8/25.
//  Copyright © 2019 Chenfy. All rights reserved.
//

#ifndef CClient_hpp
#define CClient_hpp

#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif
    
typedef void (OEngineRender(void));

typedef struct {
    OEngineRender *Render;
    void    *userData;
}RenderWindow;

class OSystem{
    public:
        OSystem();
        virtual ~OSystem();
    public:
        static OSystem *OSystem_init();
        void exit();
        void startEngine(const char *str);
        int getChannelList(char *data);
//    private:
        RenderWindow *_renderWindow;
};

extern OSystem *osystem;

    
#ifdef __cplusplus
}
#endif


#endif /* CClient_hpp */
