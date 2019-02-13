//
//  UIViewController+SKLeaks.m
//  SKLeaks
//
//  Created by 赵申侃 on 2019/2/12.
//  Copyright © 2019 赵申侃. All rights reserved.
//

#import "UIViewController+SKLeaks.h"
#import <objc/message.h>
const NSString *flag;

@implementation UIViewController (SKLeaks)

+ (void)load
{
    [self sk_exchangeOriginSel:@selector(viewWillAppear:) swizzSel:@selector(sk_viewWillAppear:)];
    [self sk_exchangeOriginSel:@selector(viewDidDisappear:) swizzSel:@selector(sk_viewDidDisappear:)];
}

+ (void)sk_exchangeOriginSel:(SEL)originSel swizzSel:(SEL)swizzSel{
    
    Method fromMethod = class_getInstanceMethod([self class], originSel);
    Method toMethod = class_getInstanceMethod([self class], swizzSel);
    method_exchangeImplementations(fromMethod, toMethod);
}

- (void)sk_viewWillAppear:(BOOL)animated
{
    [self sk_viewWillAppear:animated];
    objc_setAssociatedObject(self, &flag, @(NO), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)sk_viewDidDisappear:(BOOL)animated
{
    [self sk_viewDidDisappear:animated];
    if ([objc_getAssociatedObject(self, &flag) boolValue]) {
        [self sk_delloc];
    }
}

- (void)sk_delloc
{
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __weak typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            NSLog(@"%@ 没有释放",strongSelf);
        }
    });
}

@end
