//
//  CLPullHeaderV.m
//  下拉刷新框架
//
//  Created by AppleCheng on 2018/2/25.
//  Copyright © 2018年 AppleCheng. All rights reserved.
//

#import "CLPullHeaderV.h"
@interface CLPullHeaderV()
{
    CGFloat trigglePointY;
}
@property (nonatomic,assign) BOOL isObserved; //是否有监听
@property (nonatomic,assign) CLRefreshState pullState; //刷新控件所处状态
@property (nonatomic,copy) NSMutableArray<NSString *> * labelTitleArr;
@property (nonatomic,copy) NSMutableArray<UIView *> * customStateViewArr;
@property (nonatomic,assign) BOOL isCustum; //是否用户自定义显示
@end
@implementation CLPullHeaderV

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        trigglePointY = frame.size.height;
        _labelTitleArr = [@[@"下拉刷新",@"松开即可刷新",@"正在刷新..."] mutableCopy];
    }
    return self;
}
-(void)setScrollView:(UIScrollView *)scrollView{
    _scrollView = scrollView;
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew) context:nil];
    [_scrollView addObserver:self forKeyPath:@"frame" options:(NSKeyValueObservingOptionNew) context:nil];
    _isObserved = YES;
}
-(void)willMoveToSuperview:(UIView *)newSuperview{
    if (self.superview && newSuperview == nil) {
        if (_isObserved) {
            [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
            [_scrollView removeObserver:self forKeyPath:@"frame"];
            _isObserved = NO;
        }
    }
}
-(void)setTitle:(NSString *)title forState:(CLRefreshState)state{
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
-(void)setTintColor:(UIColor *)tintColor{
    _tintColor = tintColor;
    if (_titleLab) {
        _titleLab.textColor = tintColor;
    }
    if (_indicatorView) {
        _indicatorView.color = tintColor;
    }
}
-(void)setDefaultMode{
    if (!_titleLab) {
        self.titleLab.text = _labelTitleArr[0];
    }
    if (!_indicatorView) {
        self.indicatorView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2-10);
    }
    _isCustum = NO;
}
-(void)setCustomModeView:(UIView *)customView forState:(CLRefreshState)state{
    [self removeDefaultView];
    NSAssert(customView, @"customView couldn't be nil");
    if (!_customStateViewArr) {
        _customStateViewArr = [@[[UIView new],[UIView new],[UIView new]] mutableCopy];
    }
    [_customStateViewArr replaceObjectAtIndex:state withObject:customView];
    _isCustum = YES;
    [self addSubview:customView];
    if (state == CLRefreshStateNormal) {
        customView.hidden = NO;
    }else{
        customView.hidden = YES;
    }
}
-(void)startRefresh{
    if (self.pullState != CLRefreshStateLoading) {
        _scrollView.contentInset = UIEdgeInsetsMake(_originalTopInset+trigglePointY, 0, _scrollView.contentInset.bottom, 0);
        [UIView animateWithDuration:0.3 animations:^{
            _scrollView.contentOffset = CGPointMake(0, -_originalTopInset-trigglePointY);
        }];
        if (_isCustum) {
            [self showCustomWithIndex:2];
        }else{
            if (_indicatorView) {
                [_indicatorView startAnimating];
            }
            if (_titleLab) {
                _titleLab.text = _labelTitleArr[2];
            }
        }
        _pullState = CLRefreshStateLoading;
    }
}
-(void)endRefresh{
    if (self.pullState == CLRefreshStateLoading) {
        _pullState = CLRefreshStateNormal;
        [UIView animateWithDuration:0.3 animations:^{
            _scrollView.contentInset = UIEdgeInsetsMake(_originalTopInset, 0, _scrollView.contentInset.bottom, 0);
        }];
        if (_isCustum) {
            [self showCustomWithIndex:0];
        }else{
            if (_indicatorView) {
                [_indicatorView stopAnimating];
            }
            if (_titleLab) {
                _titleLab.text = _labelTitleArr[0];
            }
        }
    }
}
-(BOOL)isAnimation{
    if (self.pullState == CLRefreshStateNormal) {
        return NO;
    }else{
        return YES;
    }
}
#pragma mark- 监听
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    }else if ([keyPath isEqualToString:@"frame"]){
        [self layoutSubviews];
    }
}
-(void)scrollViewDidScroll:(CGPoint)contentOffset{
    CGFloat y = contentOffset.y;
    if (y<-_originalTopInset-trigglePointY) {
        //当下拉超过临界状态
        if (self.pullState == CLRefreshStateNormal) {
            self.pullState = CLRefreshStatePulling; //释放即可刷新
        }
    }else{
        //当下拉没有达到 临界
        if (_scrollView.isDragging) { //手指没有离开屏幕
            if (self.pullState == CLRefreshStatePulling) { //原先是要求释放的话，则变为正常
                self.pullState = CLRefreshStateNormal;
            }
        }else{ //手指离开屏幕
            if (self.pullState == CLRefreshStatePulling) { //原先是要求释放的话则变为加载中
                _scrollView.contentInset = UIEdgeInsetsMake(_originalTopInset+trigglePointY, 0, _scrollView.contentInset.bottom, 0);
                self.pullState = CLRefreshStateLoading;
            }
        }
    }
}
-(void)setPullState:(CLRefreshState)pullState{
    if (_pullState == pullState) {
        return;
    }
    _pullState = pullState;
    switch (pullState) {
        case CLRefreshStateNormal:
            if (_isCustum) {
                [self showCustomWithIndex:0];
            }else{
                _titleLab.text = _labelTitleArr[0];
            }
            break;
        case CLRefreshStatePulling:
            if (_isCustum) {
                [self showCustomWithIndex:1];
            }else{
                if (_indicatorView) {
                    [_indicatorView startAnimating];
                }
                _titleLab.text = _labelTitleArr[1];
            }
            break;
        case CLRefreshStateLoading:
            if (_isCustum) {
                [self showCustomWithIndex:2];
            }else{
                _titleLab.text = _labelTitleArr[2];
                if (_indicatorView) {
                    [_indicatorView startAnimating];
                }
            }
            if (_cl_PullRefreshHandler) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.cl_PullRefreshHandler();
                });
            }
            break;
    }
}
#pragma mark- private
-(void)removeDefaultView{
    if (_titleLab) {
        [_titleLab removeFromSuperview];
    }
    if (_indicatorView) {
        [_indicatorView removeFromSuperview];
    }
}
-(void)showCustomWithIndex:(NSInteger)index{
    for (int i = 0; i<_customStateViewArr.count; i++) {
        if (index == i) {
            ((UIView *)_customStateViewArr[i]).hidden = NO;
        }else{
            ((UIView *)_customStateViewArr[i]).hidden = YES;
        }
    }
}
#pragma mark- lazy
-(UIActivityIndicatorView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhite)];
        _indicatorView.color = _tintColor ? _tintColor:[UIColor blackColor];
        _indicatorView.hidesWhenStopped = NO;
        [self addSubview:_indicatorView];
    }
    return _indicatorView;
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-25, self.frame.size.width, 20)];
        _titleLab.textColor = _tintColor? _tintColor:[UIColor grayColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLab];
    }
    return _titleLab;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
