//
//  CLUpFooterV.m
//  下拉刷新框架
//
//  Created by AppleCheng on 2018/2/25.
//  Copyright © 2018年 AppleCheng. All rights reserved.
//

#import "CLUpFooterV.h"
@interface CLUpFooterV()
{
    CGFloat trigglePointY;
}
@property (nonatomic,assign) BOOL isObserved; //是否有监听
@property (nonatomic,assign) CLRefreshUpState upState; //刷新控件所处状态
@property (nonatomic,copy) NSMutableArray<NSString *> * labelTitleArr;
@property (nonatomic,copy) NSMutableArray<UIView *> * customStateViewArr;
@property (nonatomic,assign) BOOL isCustum; //是否用户自定义显示
@property (nonatomic,assign) BOOL finishRefreshControl; //结束该控件后续的运行

@end
@implementation CLUpFooterV
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor cyanColor];
        trigglePointY = frame.size.height;
        _labelTitleArr = [@[@"上拉获取更多",@"数据加载中...",@"triggered"] mutableCopy];
    }
    return self;
}
-(void)setTitle:(NSString *)title forState:(CLRefreshUpState)state{
    if (!title) {
        title = @"";
    }else{
        [_labelTitleArr replaceObjectAtIndex:state withObject:title];
    }
    if (state == 0) {
        _titleLab.text = _labelTitleArr[0];
    }
    [self setNeedsLayout];
}
-(void)setDefaultMode{
    if (!_titleLab) {
        self.titleLab.text = _labelTitleArr[0];
    }
}
-(void)removeDefaultView{
    if (_titleLab) {
        [_titleLab removeFromSuperview];
    }
}
-(void)setCustomModeView:(UIView *)customView forState:(CLRefreshUpState)state{
    [self removeDefaultView];
    _isCustum = YES;
    if (!_customStateViewArr) {
        _customStateViewArr = [@[[UIView new],[UIView new],[UIView new]] mutableCopy];
    }
    [self addSubview:customView];
    [self.customStateViewArr replaceObjectAtIndex:state withObject:customView];
    if (state == CLRefreshUpStateStopped) {
        customView.hidden = NO;
    }else{
        customView.hidden = YES;
    }
}
-(void)startRefresh{
    if (_isCustum) {
        [self showCustomeViewWithIndex:1];
    }else{
        _titleLab.text = _labelTitleArr[1];
    }
}
-(void)endRefresh{
    if (_isCustum) {
        [self showCustomeViewWithIndex:0];
    }else{
        _titleLab.text = _labelTitleArr[0];
    }
}
-(void)endRefreshWithNoMoreData:(NSString *)noMoreDataTitle{
    _titleLab.text = noMoreDataTitle;
    self.finishRefreshControl = YES;
}
-(BOOL)isAnimation{
    if (_upState == CLRefreshUpStateLoading) {
        return YES;
    }
    return NO;
}

-(void)setScrollView:(UIScrollView *)scrollView{
    _scrollView = scrollView;
    _scrollView.contentInset = UIEdgeInsetsMake(_scrollView.contentInset.top, 0, trigglePointY, 0);
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew) context:nil];
    [_scrollView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:nil];
    _isObserved = YES;
}
-(void)willMoveToSuperview:(UIView *)newSuperview{
    if (self.superview && newSuperview == nil) {
        if (_isObserved) {
            [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
            [_scrollView removeObserver:self forKeyPath:@"contentSize"];
            _isObserved = NO;
        }
    }
}
-(void)showCustomeViewWithIndex:(int)index{
    for (int i =0; i<_customStateViewArr.count; i++) {
        UIView * v = _customStateViewArr[i];
        if (i == index) {
            v.hidden = NO;
        }else{
            v.hidden = YES;
        }
    }
}
#pragma mark- 监听
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    }else if ([keyPath isEqualToString:@"contentSize"]){
        [self layoutSubviews];
        self.frame = CGRectMake(0, self.scrollView.contentSize.height, self.bounds.size.width, self.frame.size.height);
        if (_finishRefreshControl) {
            [_scrollView removeObserver:self forKeyPath:@"contentSize"];
        }
    }
}
-(void)scrollViewDidScroll:(CGPoint)contentOffset{
    CGFloat y = contentOffset.y;
    if (self.upState != CLRefreshUpStateLoading) {
        CGFloat scrollViewContentHeight = self.scrollView.contentSize.height;
        CGFloat scrollOffesetThreshold = scrollViewContentHeight - self.scrollView.bounds.size.height;
        if (!self.scrollView.isDragging && self.upState == CLRefreshUpStateTriggered) {
            self.upState = CLRefreshUpStateLoading;
        }else if(y > scrollOffesetThreshold && self.upState == CLRefreshUpStateStopped && self.scrollView.isDragging){
            self.upState = CLRefreshUpStateTriggered;
        }else if(y < scrollOffesetThreshold && self.upState != CLRefreshUpStateStopped){
            self.upState  = CLRefreshUpStateStopped;
        }
    }
}

-(void)setUpState:(CLRefreshUpState)upState{
    if (_upState == upState) {
        return;
    }
    CLRefreshUpState previousState = _upState;
    _upState = upState;
    switch (upState) {
        case CLRefreshUpStateStopped:
            [self endRefresh];
            break;
        case CLRefreshUpStateTriggered:
            
            break;
        case CLRefreshUpStateLoading:
            [self startRefresh];
            break;
    }
    if (previousState == CLRefreshUpStateTriggered && upState == CLRefreshUpStateLoading && self.cl_UpRefreshBlock) {
        self.cl_UpRefreshBlock();
        _upState = CLRefreshUpStateStopped;
    }
}
-(void)setFinishRefreshControl:(BOOL)finishRefreshControl{
    if (finishRefreshControl && _isObserved) {
        [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
        _isObserved = NO;
    }
}
#pragma makr- lazy
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _titleLab.textColor = _tintColor? _tintColor:[UIColor grayColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLab];
    }
    return _titleLab;
}
@end
