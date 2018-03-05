# CLRefresh上下拉刷新控件

### 一 简介

​	CLRefresh为UIScrollView提供上拉刷新控件和下拉刷新控件，该框架设计简单，大家可以参考源代码的实现，具体编写思路也可以参考简书https://www.jianshu.com/p/574e2d4ae6c6

### 二 下拉刷新

普通使用方法

```objective-c
_pullHeaderV = [_tableView cl_addPullRefreshControlWithBlock:^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            sleep(1.0);
            NSLog(@"刷新吧！ 骚年！");
            dispatch_async(dispatch_get_main_queue(), ^{
                [me.tableView.pullHeaderV endRefresh];
            });
        });
    }];
```

设置标题

```objective-c
    _pullHeaderV.tintColor = [UIColor blackColor];
    [_pullHeaderV setTitle:@"拉一下" forState:(CLRefreshStateNormal)];
    [_pullHeaderV setTitle:@"快松手" forState:(CLRefreshStatePulling)];
    [_pullHeaderV setTitle:@"玩命加载..." forState:(CLRefreshStateLoading)];
```

自定义控件

````objective-c
    UIView * v1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    v1.backgroundColor = [UIColor blackColor];
    [_pullHeaderV setCustomModeView:v1 forState:(CLRefreshStateNormal)];

    UIView * v2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    v2.backgroundColor = [UIColor orangeColor];
    [_pullHeaderV setCustomModeView:v2 forState:(CLRefreshStatePulling)];

    UIView * v3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    v3.backgroundColor = [UIColor greenColor];
    [_pullHeaderV setCustomModeView:v3 forState:(CLRefreshStateLoading)];
````

### 三 上拉加载更多

普通使用

```objective-c
    CLUpFooterV * footerV = [_tableView cl_addUpRefreshControlWithBlock:^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            sleep(2.0);
            NSLog(@"上拉：%d",index++);
            for (int i =0; i<2; i++) {
                [_dataArr addObject:@"1"];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [me.tableView reloadData];
                [me.tableView.footerV endRefresh];
                //[me.tableView.footerV endRefreshWithNoMoreData:@"数据已光光"];
            });
        });
    }];
```

自定义

```objective-c
   [footerV setTitle:@"上拉加载更多😆" forState:(CLRefreshUpStateStopped)];
    [footerV setTitle:@"加载中..." forState:(CLRefreshUpStateLoading)];
    [footerV setCustomModeView:v1 forState:(CLRefreshUpStateStopped)];
    [footerV setCustomModeView:v3 forState:CLRefreshUpStateLoading];
```







