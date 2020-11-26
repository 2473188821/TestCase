//
//  CAgent.m
//  ObjectiveBridge
//
//  Created by Chenfy on 2019/8/25.
//  Copyright © 2019 Chenfy. All rights reserved.
//

#import "CAgent.h"
#include "CClient.hpp"

id agent;
static void callbackTest(){
    [agent callbackInner];
}

@implementation CAgent

- (instancetype)init
{
    self = [super init];
    if (self) {
        agent = self;
    }
    return self;
}

- (void)callbackInner
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(renderComplete:)])
    {
        [self.delegate renderComplete:@"operate c++ call back!"];
    }
}

- (void)initEngine
{
    if (!osystem) {
        osystem->OSystem_init();
    }
    if (osystem) {
        osystem->_renderWindow->Render = callbackTest;
    }
}

- (void)startEngine:(NSString *)str
{
    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    osystem->startEngine(cstr);
}

- (int)getChannelList
{
    int length = sizeof(char) * 1024;
    NSMutableData *data = [NSMutableData dataWithLength:length];
    char *ptr = (char *)[data mutableBytes];

    int result = osystem->getChannelList(ptr);
    return result;
}

- (void)dealloc
{
    osystem->exit();
}
@end
