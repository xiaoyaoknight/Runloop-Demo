//
//  Test2ViewController.m
//  Runloop-Demo
//
//  Created by 王泽龙 on 2019/5/15.
//  Copyright © 2019 王泽龙. All rights reserved.
//

#import "Test2ViewController.h"
#import "ZLThread.h"

@interface Test2ViewController ()

@property (nonatomic,strong) ZLThread *thread;

@end

@implementation Test2ViewController

- (void)viewDidLoad {
    self.title = @"常驻线程";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];

    // 执行操作action
    [self performSelector:@selector(action) onThread:self.thread withObject:nil waitUntilDone:NO];

}

/**
 *  常驻子线程,用于轮询任务的子线程执行,不影响主线程操作
 */
- (ZLThread *)thread {
   
    @synchronized (self) {
        if (_thread == nil) {
            _thread = [[ZLThread alloc] initWithTarget:self selector:@selector(run:) object:nil];
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
        [[NSThread currentThread] setName:@"AAA"];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
        // 指定runloop在指定模式下，设置开始时间,开启成功会返回YES
//        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
    }
}

- (void)action {
    NSLog(@"--------------%@", [NSThread currentThread]);
    
    //Runloop-Demo[10060:265239] --------------<ZLThread: 0x6000024de3c0>{number = 3, name = AAA}
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}
@end
