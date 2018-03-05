//
//  UIScrollView+CLUpRefresh.m
//  下拉刷新框架
//
//  Created by AppleCheng on 2018/2/25.
//  Copyright © 2018年 AppleCheng. All rights reserved.
//

#import "UIScrollView+CLUpRefresh.h"
#import <objc/runtime.h>

static char UIScrollViewUpFooterView;
static float CLUpFooterV_Height = 50;
@implementation UIScrollView (CLUpRefresh)
@dynamic footerV;

-(CLUpFooterV *)cl_addUpRefreshControlWithBlock:(void(^)(void))refreshBlock{
    if (!self.footerV) {
        [self layoutIfNeeded];
        CLUpFooterV * footerV = [[CLUpFooterV alloc] initWithFrame:CGRectMake(0, self.contentSize.height, self.frame.size.width, CLUpFooterV_Height)];
        footerV.cl_UpRefreshBlock = refreshBlock;
        footerV.originnalBottomInset =  self.contentInset.bottom;
        footerV.scrollView = self;
        [footerV setDefaultMode];
        [self addSubview:footerV];
        [self setFooterV:footerV];
    }
    
    return self.footerV;
}

-(void)setFooterV:(CLUpFooterV *)footerV{
    [self willChangeValueForKey:@"footerV"];
    objc_setAssociatedObject(self, &UIScrollViewUpFooterView, footerV, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"footerV"];
}
-(CLUpFooterV *)footerV{
    return objc_getAssociatedObject(self, &UIScrollViewUpFooterView);
}
@end
