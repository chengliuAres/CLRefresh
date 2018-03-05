//
//  UIScrollView+CLUpRefresh.h
//  下拉刷新框架
//
//  Created by AppleCheng on 2018/2/25.
//  Copyright © 2018年 AppleCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLUpFooterV.h"
@interface UIScrollView (CLUpRefresh)
@property (nonatomic,strong) CLUpFooterV * footerV;
-(CLUpFooterV *)cl_addUpRefreshControlWithBlock:(void(^)(void))refreshBlock;

@end
