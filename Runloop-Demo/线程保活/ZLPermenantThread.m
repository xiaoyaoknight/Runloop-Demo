//
//  ZLPermenantThread.m
//  Runloop-Demo
//
//  Created by 王泽龙 on 2019/5/15.
//  Copyright © 2019 王泽龙. All rights reserved.
//

#import "ZLPermenantThread.h"
#import "ZLThread.h"

@interface ZLPermenantThread ()

@property (nonatomic, strong) ZLThread *innerThread;
@property (nonatomic, assign) BOOL stoped;
@end

@implementation ZLPermenantThread

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.stoped = NO;
        __weak typeof(self) weakSelf = self;
        self.innerThread = [[ZLThread alloc] initWithBlock:^{
           
            NSLog(@"------------beigin----------");
            
             // 方式一
//            [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
//            while (weakSelf && !weakSelf.stoped) {
//                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//            }
            
            
            
             // 方式二
            //创建一个Source 上下文
            CFRunLoopSourceContext context = {0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL};
            
            CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
            
            //创建RunLoop，同时向RunLoop的defaultMode下面添加Source
            CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
            
            //如果可以运行
            while (weakSelf && !weakSelf.stoped) {
                @autoreleasepool {
                    //令当前RunLoop运行在defaultMode下
                    //第三个参数true, 代表执行完source后当前函数就会返回
                    CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, true);
                }
            }
            
            //某一时机，静态变量runAlways变为NO时，保证跳出RunLoop，线程推出
            CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
            CFRelease(source);
            
            NSLog(@"------------end----------");
        }];
    }
    return self;
}

/**
 开启一个线程
 */
- (void)run {
    if (!self.innerThread) return;
    [self.innerThread start];
}

/**
 执行任务
 */
- (void)excuteTask:(ZLblock)block {
    if (!self.innerThread || !block) return;
    
    [self performSelector:@selector(task:) onThread:self.innerThread withObject:block waitUntilDone:NO];
}

- (void)task:(ZLblock)block {
    block();
}

/**
 结束一个线程
 */
- (void)stop {
    if (!self.innerThread) return;
    [self performSelector:@selector(__stop) onThread:self.innerThread withObject:nil waitUntilDone:YES];
}

- (void)__stop {
    self.stoped = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.innerThread = nil;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    [self stop];
}
@end
