
## 内存泄漏检测 
 [github参考代码](https://github.com/kylinuranus)
 
 基本思路:通过hook viewController的 viewVillappear 和 viewDidDisappear ,当viewController释放后，向一个nil发送消息看是否能接收到
 
 关键代码
 
```

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

```

```
//还有多个pop和dismiss要做吃力 此处略过
- (UIViewController *)sk_popViewControllerAnimated:(BOOL)animated
{
    extern const NSString *flag;
    UIViewController *popVc = [self sk_popViewControllerAnimated:animated];
    objc_setAssociatedObject(popVc, &flag, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return popVc;
}

```
## NSTimer定时器的内存泄漏方案
 
 要点:在delloc和viewWillDisappear 中不能释放。前者走不到,后者业务需求可能会遇到问题
 
### 方案1
  
  初始化一个临时对象作为timer的强引用,runTime动态增加一个方法

```
NSObject *target = [[NSObject alloc] init];
class_addMethod([target class], @selector(fire), (IMP)targetfire, "v@:");
    
_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:target selector:@selector(fire) userInfo:nil repeats:YES];
[_timer fire];
```

```
void targetfire(id self,SEL _cmd) {
    NSLog(@"---new fire");
}

```

### 方案2
 
  新建一个代理类,继承于NSProxy,property一个weak的target,做消息转发
  
```
 SKTimerProxy *proxy = [SKTimerProxy alloc];
 proxy.target = self;
  _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:proxy selector:@selector(fire) userInfo:nil repeats:YES];
 [_timer fire];

```


```
@interface SKTimerProxy : NSProxy

@property (nonatomic, weak) id target;

@end

```

```
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

```

## 关于NSProxy

  代理，与nsobject同类，做消息转发，主要作用
- 防循环引用，如上nstimer
- 多继承

[网上参考链接](https://blog.csdn.net/shubinniu/article/details/80895450) 


