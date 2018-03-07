//
//  ViewController.m
//  下拉刷新框架
//
//  Created by AppleCheng on 2018/2/23.
//  Copyright © 2018年 AppleCheng. All rights reserved.
//

#import "ViewController.h"
#import "SVPullToRefresh.h"
#import "CLRefresh.h"
///下拉刷新状态
//typedef NS_ENUM(NSUInteger,CLRefreshState){
//    CLRefreshStateNormal, //正常
//    CLRefreshStatePulling, //释放即可刷新
//    CLRefreshStateLoading, //加载中
//};
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel * label;
    UILabel * upLabel;
    CGFloat originInsetTop;
    CGFloat originInsetBottom;
    CGFloat bottomMoreLab_Height; //底部上拉刷新时 的视图高度
    BOOL isUpRefresh; //是否上拉刷新中
}
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,assign) CLRefreshState pullState;
@property (nonatomic,strong) CLPullHeaderV * pullHeaderV;
@end

@implementation ViewController

-(void)basic{
    isUpRefresh = NO;
    originInsetTop = 0;
    originInsetBottom =  0;
    bottomMoreLab_Height = 30;
    _pullState = CLRefreshStateNormal;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self basic];
    // Do any additional setup after loading the view, typically from a nib.
    _dataArr = [@[@1,@2,@3,@4,@5] mutableCopy];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-200) style:(UITableViewStylePlain)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 120;
    _tableView.contentInset = UIEdgeInsetsMake(originInsetTop, 0, originInsetBottom, 0);
    
//    UIRefreshControl * control = [[UIRefreshControl alloc] init];
//    control.tintColor = [UIColor blackColor];
//    control.attributedTitle = [[NSAttributedString alloc] initWithString:@"refresh me" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
//    [control addTarget:self action:@selector(action:) forControlEvents:(UIControlEventValueChanged)];
//    _tableView.refreshControl = control;
    [self.view addSubview:_tableView];
    __weak typeof(self) me = self;
    _pullHeaderV = [_tableView cl_addPullRefreshControlWithBlock:^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            sleep(2.0);
            NSLog(@"刷新吧！ 骚年！");
            [_dataArr removeObjectAtIndex:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                [me.tableView reloadData];
                [me.tableView.pullHeaderV endRefresh];
            });
        });
    }];
    _pullHeaderV.tintColor = [UIColor blackColor];
    [_pullHeaderV setTitle:@"拉一下" forState:(CLRefreshStateNormal)];
    [_pullHeaderV setTitle:@"快松手" forState:(CLRefreshStatePulling)];
    [_pullHeaderV setTitle:@"玩命加载..." forState:(CLRefreshStateLoading)];
    UIView * v1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    v1.backgroundColor = [UIColor blackColor];
    [_pullHeaderV setCustomModeView:v1 forState:(CLRefreshStateNormal)];

    UIView * v2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    v2.backgroundColor = [UIColor orangeColor];
    [_pullHeaderV setCustomModeView:v2 forState:(CLRefreshStatePulling)];

    UIView * v3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    v3.backgroundColor = [UIColor blueColor];
    [_pullHeaderV setCustomModeView:v3 forState:(CLRefreshStateLoading)];

    __block int index  =0;
    CLUpFooterV * footerV = [_tableView cl_addUpRefreshControlWithBlock:^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            sleep(2.0);
            NSLog(@"上拉：%d",index++);
            [_dataArr addObject:@"1"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [me.tableView reloadData];
                [me.tableView.footerV endRefresh];
                //[me.tableView.footerV endRefreshWithNoMoreData:@"数据已光光"];
            });
        });
    }];
    [footerV setTitle:@"上拉加载更多😆" forState:(CLRefreshUpStateStopped)];
    [footerV setTitle:@"加载中..." forState:(CLRefreshUpStateLoading)];
    UIView * v4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    v4.backgroundColor = [UIColor blackColor];
    [footerV setCustomModeView:v4 forState:(CLRefreshUpStateStopped)];
    UIView * v5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    v5.backgroundColor = [UIColor blueColor];
    [footerV setCustomModeView:v5 forState:CLRefreshUpStateLoading];
    _tableView.backgroundColor = [UIColor yellowColor];
    self.view.backgroundColor = [UIColor lightGrayColor];
    //    __weak typeof(self) me = self;
//    [_tableView addPullToRefreshWithActionHandler:^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [me.tableView.pullToRefreshView stopAnimating];
//        });
//    }];
//    _tableView.pullToRefreshView.backgroundColor = [UIColor redColor];
//    _tableView.pullToRefreshView.arrowColor = [UIColor whiteColor];
//    [_tableView.pullToRefreshView setTitle:@"Pull Refresh" forState:(SVPullToRefreshStateLoading)];
//    [_tableView.pullToRefreshView setSubtitle:@"Pull Refresh" forState:(SVPullToRefreshStateLoading)];
//    _tableView.pullToRefreshView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
//
//    [_tableView addInfiniteScrollingWithActionHandler:^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [me.tableView.infiniteScrollingView stopAnimating];
//        });
//    }];
//    _tableView.infiniteScrollingView.backgroundColor = [UIColor blueColor];
//    _tableView.infiniteScrollingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;

    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 30)];
    label.text = @"下拉刷新";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor purpleColor];
    [self.view addSubview:label];
    upLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tableView.frame)+50, self.view.frame.size.width, 30)];
    upLabel.text = @"上拉加载更多";
    upLabel.textAlignment = NSTextAlignmentCenter;
    upLabel.textColor = [UIColor purpleColor];
    [self.view addSubview:upLabel];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!_tableView.pullHeaderV.isAnimation) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:(UITableViewScrollPositionTop) animated:NO];
        [_tableView.pullHeaderV startRefresh];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_tableView.pullHeaderV endRefresh];
        });
    }
}
-(void)action:(UIRefreshControl *)control{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [control endRefreshing];
    });
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"第 %ld 行",indexPath.row];
    return cell;
}

-(void)loadMore{
    if (!isUpRefresh) {
        isUpRefresh = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top,
                                                           0,
                                                           bottomMoreLab_Height+originInsetBottom,
                                                           0);
        }];
        upLabel.text = @"正在加载更多";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                upLabel.text = @"上拉加载更多";
                self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top,
                                                               0,
                                                               originInsetBottom,
                                                               0);
            }];
            isUpRefresh = NO;
        });
    }
}
-(void)scrollViewDidScrolled:(UIScrollView *)scrollView{
    CGFloat y = scrollView.contentOffset.y;
    if (y <0) {
       // NSLog(@"下拉: %.2f",y);
    }else if (y >= scrollView.contentSize.height-_tableView.frame.size.height){
        //NSLog(@"上拉: %.2f",y-(scrollView.contentSize.height-_tableView.frame.size.height));
    }
    //originInsetTop = self.tableView.contentInset.top;
    CGFloat trigglePointY = 50;
    //NSLog(@"下拉：%.2f",y+originInsetTop);
    if (y<-originInsetTop-trigglePointY) {
        //当下拉超过临界状态
        if (self.pullState == CLRefreshStateNormal) {
            self.pullState = CLRefreshStatePulling; //释放即可刷新
        }
    }else{
        //当下拉没有达到 临界
        if (scrollView.isDragging) { //手指没有离开屏幕
            if (self.pullState == CLRefreshStatePulling) { //原先是要求释放的话，则变为正常
                self.pullState = CLRefreshStateNormal;
            }
        }else{ //手指离开屏幕
            if (self.pullState == CLRefreshStatePulling) { //原先是要求释放的话则变为加载中
                self.tableView.contentInset = UIEdgeInsetsMake(originInsetTop+trigglePointY, 0, self.tableView.contentInset.bottom, 0);
                self.pullState = CLRefreshStateLoading;
            }
        }
    }
    if (y>scrollView.contentSize.height-_tableView.frame.size.height+originInsetBottom) {
        NSLog(@"上拉加载更多,触发距离：%.2f",y-(scrollView.contentSize.height-_tableView.frame.size.height)-originInsetBottom);
        [self loadMore];
    }
}
-(void)setPullState:(CLRefreshState)pullState{
    _pullState = pullState;
    switch (pullState) {
        case CLRefreshStateNormal:
            label.text = @"下拉刷新";
            break;
        case CLRefreshStatePulling:
            label.text = @"松开你的猪蹄";
            break;
        case CLRefreshStateLoading:
            label.text = @"正在刷新哟.....";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSLog(@"test");
                [self endRefresh];
            });
            break;
    }
}
-(void)endRefresh{
    if (self.pullState == CLRefreshStateLoading) {
        self.pullState = CLRefreshStateNormal;
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.contentInset = UIEdgeInsetsMake(originInsetTop, 0, self.tableView.contentInset.bottom, 0);
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
