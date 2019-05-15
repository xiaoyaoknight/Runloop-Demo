//
//  Test1ViewController.m
//  Runtime-Demo
//
//  Created by 王泽龙 on 2019/4/28.
//  Copyright © 2019 王泽龙. All rights reserved.
//

#import "Test1ViewController.h"
#import "ZLPermenantThread.h"

@interface Test1ViewController ()

@property (nonatomic, strong) ZLPermenantThread *thread;

@end

@implementation Test1ViewController

- (void)viewDidLoad {
    self.title = @"线程保活";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    button.frame = CGRectMake(100, 400, 200, 100);
    [button setTitle:@"停止" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor greenColor];
    [button addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.thread = [[ZLPermenantThread alloc] init];
    [self.thread run];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    __weak __typeof__(self) weakSelf = self;
    [self.thread excuteTask:^{
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        [strongSelf test];
    }];
}

- (void)test {
   
    NSLog(@"%@, %s", [NSThread currentThread], __func__);
}

- (void)stop {
    [self.thread stop];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.thread stop];
    }];
}
@end
