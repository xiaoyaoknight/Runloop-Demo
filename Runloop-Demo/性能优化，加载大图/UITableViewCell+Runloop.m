//
//  RunloopTableViewCell+Runloop.m
//  Runloop-性能优化，加载大图
//
//  Created by 王泽龙 on 2019/5/22.
//  Copyright © 2019 pgq. All rights reserved.
//

#import "UITableViewCell+Runloop.h"
#import <objc/runtime.h>

@implementation UITableViewCell (Runloop)

- (NSIndexPath *)willShowIndexpath {
    NSIndexPath *indexPath = objc_getAssociatedObject(self, @selector(willShowIndexpath));
    return indexPath;
}

- (void)setWillShowIndexpath:(NSIndexPath *)willShowIndexpath{
    objc_setAssociatedObject(self, @selector(willShowIndexpath), willShowIndexpath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end



