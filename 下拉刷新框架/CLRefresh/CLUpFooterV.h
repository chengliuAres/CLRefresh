//
//  CLUpFooterV.h
//  下拉刷新框架
//
//  Created by AppleCheng on 2018/2/25.
//  Copyright © 2018年 AppleCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger,CLRefreshUpState) {
    CLRefreshUpStateStopped, //正常
    CLRefreshUpStateLoading, //加载中
    CLRefreshUpStateTriggered
};
@interface CLUpFooterV : UIView
@property (nonatomic,copy) void(^cl_UpRefreshBlock)(void);
@property (nonatomic,assign) CGFloat originnalBottomInset;
@property (nonatomic,weak) UIScrollView * scrollView;
@property (nonatomic,strong) UILabel * titleLab;
@property (nonatomic,strong) UIColor * tintColor;
-(void)setTitle:(NSString *)title forState:(CLRefreshUpState)state;
-(void)setDefaultMode;
-(void)setCustomModeView:(UIView *)customView forState:(CLRefreshUpState)state;
-(void)startRefresh;
-(void)endRefresh;
-(void)endRefreshWithNoMoreData:(NSString *)noMoreDataTitle;
-(BOOL)isAnimation;
@end
