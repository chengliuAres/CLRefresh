//
//  UIScrollView+CLPullRefresh.m
//  下拉刷新框架
//
//  Created by AppleCheng on 2018/2/25.
//  Copyright © 2018年 AppleCheng. All rights reserved.
//

#import "UIScrollView+CLPullRefresh.h"
#import <objc/runtime.h>

static char UIScrollViewPullHeaderView;
static float CLPullHeaderV_Height = 70;

@implementation UIScrollView (CLPullRefresh)

@dynamic pullHeaderV;

-(CLPullHeaderV *)cl_addPullRefreshControlWithBlock:(void(^)(void))refreshBlock{
    if (!self.pullHeaderV) {
        CLPullHeaderV * pullHeadv = [[CLPullHeaderV alloc] initWithFrame:CGRectMake(0, -CLPullHeaderV_Height, self.bounds.size.width, CLPullHeaderV_Height)];
        pullHeadv.cl_PullRefreshHandler = refreshBlock;
        pullHeadv.originalTopInset = self.contentInset.top;
        pullHeadv.scrollView = self;
        [pullHeadv setDefaultMode];
        [self insertSubview:pullHeadv atIndex:0];
        [self setPullHeaderV:pullHeadv];
    }
    
    return self.pullHeaderV;
}
-(void)setPullHeaderV:(CLPullHeaderV *)pullHeaderV{
    [self willChangeValueForKey:@"pullHeaderV"];
    objc_setAssociatedObject(self, &UIScrollViewPullHeaderView, pullHeaderV, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"pullHeaderV"];
}
-(CLPullHeaderV *)pullHeaderV{
    return objc_getAssociatedObject(self, &UIScrollViewPullHeaderView);
}

@end
