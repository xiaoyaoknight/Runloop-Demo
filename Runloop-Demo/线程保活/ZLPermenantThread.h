//
//  ZLPermenantThread.h
//  Runloop-Demo
//
//  Created by 王泽龙 on 2019/5/15.
//  Copyright © 2019 王泽龙. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 常驻线程
typedef void(^ZLblock)(void);
@interface ZLPermenantThread : NSObject

/**
 开启一个线程
 */
- (void)run;

/**
 执行任务
 */
- (void)excuteTask:(ZLblock)block;

/**
 结束一个线程
 */
- (void)stop;
@end

