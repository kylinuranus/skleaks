//
//  UINavigationController+SKLeaks.m
//  SKLeaks
//
//  Created by 赵申侃 on 2019/2/12.
//  Copyright © 2019 赵申侃. All rights reserved.
//

#import "UINavigationController+SKLeaks.h"
#import <objc/message.h>
#import "UIViewController+SKLeaks.h"

@implementation UINavigationController (SKLeaks)

+ (void)load
{
    [self sk_exchangeOriginSel:@selector(popViewControllerAnimated:) swizzSel:@selector(sk_popViewControllerAnimated:)];
}

+ (void)sk_exchangeOriginSel:(SEL)originSel swizzSel:(SEL)swizzSel{
    
    Method fromMethod = class_getInstanceMethod([self class], originSel);
    Method toMethod = class_getInstanceMethod([self class], swizzSel);
    method_exchangeImplementations(fromMethod, toMethod);
}

//还有多个pop和dismiss要做吃力 此处略过
- (UIViewController *)sk_popViewControllerAnimated:(BOOL)animated
{
    extern const NSString *flag;
    UIViewController *popVc = [self sk_popViewControllerAnimated:animated];
    objc_setAssociatedObject(popVc, &flag, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return popVc;
}



@end
