//
//  Test3ViewController.m
//  Runloop-Demo
//
//  Created by 王泽龙 on 2019/5/16.
//  Copyright © 2019 王泽龙. All rights reserved.
//

#import "Test3ViewController.h"
#import "ZLThread.h"

@interface Test3ViewController ()

@property (nonatomic,strong) ZLThread *thread;
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation Test3ViewController

- (void)viewDidLoad {
    self.title = @"Runloop和NSTimer";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    // 执行操作action
    [self performSelector:@selector(action) onThread:self.thread withObject:nil waitUntilDone:NO];
}

- (void)action {
    NSLog(@"--------------%@", [NSThread currentThread]);
    
    //Runloop-Demo[10060:265239] --------------<ZLThread: 0x6000024de3c0>{number = 3, name = AAA}
}

/**
 *  常驻子线程,用于轮询任务的子线程执行,不影响主线程操作
 */
- (ZLThread *)thread {
    
    @synchronized (self) {
        if (_thread == nil) {
            _thread = [[ZLThread alloc] initWithTarget:self selector:@selector(run:) object:nil];
            [[NSThread currentThread] setName:@"AAA"];
            [_thread start];
        }
    }
    return _thread;
}


/**
 添加runloop
 */
- (void)run:(id)__unused object {
    @autoreleasepool {
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        
        
        // 添加timer
        [self addTimerToRunLoop];

        [runLoop run];
    }
}

- (void)addTimerToRunLoop {
    
    if (self.timer ==  nil) {
        
        // scheduledTimerWithTimeInterval 这种方式
        // 创建的 Timer 会默认加入到当前的 RunLoop 的 NSDefaultRunLoopMode 中
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2
                                                      target:self
                                                    selector:@selector(runTimer)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}

- (void)runTimer {
    NSLog(@"我是Timer,一直在run方法");
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}
@end

