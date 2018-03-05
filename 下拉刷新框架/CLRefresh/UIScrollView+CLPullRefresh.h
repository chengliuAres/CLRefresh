//
//  UIScrollView+CLPullRefresh.h
//  下拉刷新框架
//
//  Created by AppleCheng on 2018/2/25.
//  Copyright © 2018年 AppleCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLPullHeaderV.h"
@interface UIScrollView (CLPullRefresh)
@property (nonatomic,strong) CLPullHeaderV * pullHeaderV;

-(CLPullHeaderV *)cl_addPullRefreshControlWithBlock:(void(^)(void))refreshBlock;

@end
