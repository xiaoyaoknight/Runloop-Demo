//
//  Test4ViewController.m
//  Runloop-Demo
//
//  Created by 王泽龙 on 2019/5/22.
//  Copyright © 2019 王泽龙. All rights reserved.
//

#import "Test4ViewController.h"
#import "PQRunloop.h"
#import "Utils.h"
#import "UITableViewCell+Runloop.h"

@interface Test4ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@end

@implementation Test4ViewController


- (void)viewDidLoad {
    self.title = @"Runloop加载大图";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableview];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.rowHeight = 44;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
}

#pragma MARK - Talbeview Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    //先赋值将要显示的indexPath
    cell.willShowIndexpath = indexPath;
    
    //先移除
    for (NSInteger i = 1; i <= 5; i++) {
        [[cell.contentView viewWithTag:i] removeFromSuperview];
    }
    //添加文字
    [Test4ViewController addLabel:cell indexPath:indexPath];
    
    #if 0 //是否开启Runloop优化
    
    // 使用优化
    [[PQRunloop shareInstance] addTask:^BOOL{
        if (![cell.willShowIndexpath isEqual:indexPath]) {
            return NO;
        }
        [Test4ViewController addCenterImg:cell];
        return YES;
    } withId:indexPath];
    
    [[PQRunloop shareInstance] addTask:^BOOL{
        if (![cell.willShowIndexpath isEqual:indexPath]) {
            return NO;
        }
        [Test4ViewController addRightImg:cell];
        return YES;
    } withId:indexPath];
    
    [[PQRunloop shareInstance] addTask:^BOOL{
        if (![cell.willShowIndexpath isEqual:indexPath]) {
            return NO;
        }
        [Test4ViewController addLeftImg:cell indexPath:indexPath];
        return YES;
    } withId:indexPath];
    #else
        // 不使用优化
        [Test4ViewController addCenterImg:cell];
        [Test4ViewController addRightImg:cell];
        [Test4ViewController addLeftImg:cell indexPath:indexPath];
    
    #endif
    return cell;
}


/**
 添加View到ContentView中，使用CoreAnimation动画
 
 @param cell cell
 @param view 需要加入的View
 */
+ (void)addViewWith:(UITableViewCell *)cell view:(UIView *)view{
    [UIView transitionWithView:cell.contentView duration:0.3 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [cell.contentView addSubview:view];
    } completion:^(BOOL finished) {
    }];
}


/**
 创建一个Label
 
 @param cell cell
 @param indexPath 用来拼接
 */
+ (void)addLabel:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    NSString * text = [NSString stringWithFormat:@"%zd - Runloop性能优化：一次绘制一张图片。", indexPath.row];
    UILabel *label = [Utils createLabelWithFrame:CGRectMake(5, 5, 300, 25) tag:1 text:text textColor:[UIColor orangeColor]];
    
    [cell.contentView addSubview:label];
}


/**
 添加中间图片
 
 @param cell cell
 */
+ (void)addCenterImg:(UITableViewCell *)cell{
    UIImageView *imageView = [Utils createImageWithFrame:CGRectMake(105, 20, 85, 85) tag:2];
    [self addViewWith:cell view:imageView];
}


/**
 添加右边图片
 
 @param cell cell
 */
+ (void)addRightImg:(UITableViewCell *)cell{
    UIImageView *imageView = [Utils createImageWithFrame:CGRectMake(200, 20, 85, 85) tag:3];
    [self addViewWith:cell view:imageView];
}


/**
 添加左边图片和 label
 
 @param cell cell
 @param indexPath 用来拼接字符串使用
 */
+ (void)addLeftImg:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath  {
    NSString *text = [NSString stringWithFormat:@"%zd - 在Runloop中一次循环绘制所有的点，这里显示加载大图，使得绘制的点增多，从而导致Runloop的点一次循环时间增长，从而导致UI卡顿。", indexPath.row];
    
    UILabel *label = [Utils createLabelWithFrame:CGRectMake(5, 99, [UIScreen mainScreen].bounds.size.width - 10, 50) tag:4 text:text textColor:[UIColor colorWithRed:0.2 green:100.f/255.f blue:0 alpha:1]];
    
    UIImageView *imageView = [Utils createImageWithFrame:CGRectMake(5, 20, 85, 85) tag:5];
    [self addViewWith:cell view:label];
    [self addViewWith:cell view:imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[PQRunloop shareInstance] removeAllTasks];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
