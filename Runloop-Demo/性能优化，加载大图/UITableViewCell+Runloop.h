//
//  RunloopTableViewCell+Runloop.h
//  Runloop-性能优化，加载大图
//
//  Created by 王泽龙 on 2019/5/22.
//  Copyright © 2019 pgq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (Runloop)

@property (nonatomic, strong) NSIndexPath *willShowIndexpath;

@end

NS_ASSUME_NONNULL_END
