//
//  SKTimerProxy.h
//  SKLeaks
//
//  Created by 赵申侃 on 2019/2/13.
//  Copyright © 2019 赵申侃. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKTimerProxy : NSProxy

@property (nonatomic, weak) id target;

@end

NS_ASSUME_NONNULL_END
