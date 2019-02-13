//
//  testViewController.m
//  SKLeaks
//
//  Created by 赵申侃 on 2019/2/13.
//  Copyright © 2019 赵申侃. All rights reserved.
//

#import "testViewController.h"
#import <objc/message.h>
#import "SKTimerProxy.h"

@interface testViewController ()

@property (nonatomic, copy) void(^block)(void);
@property (nonatomic, strong) NSTimer *timer;


@end

@implementation testViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    self.block = ^{
        //  [self test];
    };
    
//    NSObject *target = [[NSObject alloc] init];
//    class_addMethod([target class], @selector(fire), (IMP)targetfire, "v@:");
    
    SKTimerProxy *proxy = [SKTimerProxy alloc];
    proxy.target = self;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:proxy selector:@selector(fire) userInfo:nil repeats:YES];
    [_timer fire];
}

//释放定时器 （delloc 和 viewwilldisappear 不行）
- (void)didMoveToParentViewController:(nullable UIViewController *)parent
{
//    NSLog(@"定时器释放");
//    [_timer invalidate];
//    _timer = nil;
}

- (void)removeFromParentViewController
{
    
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

void targetfire(id self,SEL _cmd) {
    NSLog(@"---new fire");
}

- (void)fire
{
    NSLog(@"----fire");
}

- (void)test
{
    NSLog(@"持有block");
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"test1 viewDidDisappear");
}





@end
