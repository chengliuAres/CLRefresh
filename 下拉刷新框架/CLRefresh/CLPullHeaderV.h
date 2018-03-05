//
//  CLPullHeaderV.h
//  下拉刷新框架
//
//  Created by AppleCheng on 2018/2/25.
//  Copyright © 2018年 AppleCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
///下拉刷新状态
typedef NS_ENUM(NSUInteger,CLRefreshState){
    CLRefreshStateNormal, //正常
    CLRefreshStatePulling, //释放即可刷新
    CLRefreshStateLoading, //加载中
};

@interface CLPullHeaderV : UIView

@property (nonatomic,copy) void(^cl_PullRefreshHandler)(void);
@property (nonatomic,assign) CGFloat originalTopInset;
@property (nonatomic,weak) UIScrollView * scrollView;
@property (nonatomic,strong) UILabel * titleLab;
@property (nonatomic,strong) UIActivityIndicatorView * indicatorView;
@property (nonatomic,strong) UIColor * tintColor;
-(void)setTitle:(NSString *)title forState:(CLRefreshState)state;
-(void)setDefaultMode;
-(void)setCustomModeView:(UIView *)customView forState:(CLRefreshState)state;
-(void)startRefresh;
-(void)endRefresh;
-(BOOL)isAnimation;
@end
