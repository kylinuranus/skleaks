//
//  SKTimerProxy.m
//  SKLeaks
//
//  Created by 赵申侃 on 2019/2/13.
//  Copyright © 2019 赵申侃. All rights reserved.
//

#import "SKTimerProxy.h"

@implementation SKTimerProxy

- (nullable NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation setTarget:self.target];
    [invocation invoke];
}



@end
