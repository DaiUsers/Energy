//
//  BaseViewController.m
//  WHHelper
//
//  Created by qianfeng on 15/10/20.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(248, 248, 248);
    
    //调用初始化数据
    [self initData];
    //调用创建视图
    [self createView];
    //调用添加事件
    [self addTouchAction];
}

/*********** 新增 ***********/
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /*
     将要做还没有做的时候提醒
     */
    //注册键盘将要弹出的提醒
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    //注册键盘将要消失时的提醒
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

/*********** 新增 ***********/
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //移除一切编辑状态
    [self.view endEditing:YES];
    //移除注册的键盘将要显示的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    //移除注册的键盘将要隐藏的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

//创建数据
- (void)initData {
    //我们只实现框架，不实现内容，主要是为了消除警告
}

//创建视图
- (void)createView {
    //我们只实现框架，不实现内容，主要是为了消除警告
}

//添加事件
- (void)addTouchAction {
    //我们只实现框架，不实现内容，主要是为了消除警告
}

//创建上导航的左侧按钮
- (void)createNavigationBarLeftBarButtonItemWithTitle:(NSString *)title {
    [self createNavigationBarLeftBarButtonItemWithTitle:title style:UIBarButtonItemStylePlain];
}

- (void)createNavigationBarLeftBarButtonItemWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style {
    [self createNavigationBarLeftBarButtonItemWithTitle:title style:style target:self action:@selector(leftAction)];
}

- (void)createNavigationBarLeftBarButtonItemWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action {
    //这个可以简单的理解为特殊的按钮，不需要我们去考虑布局，只要实现样式和内容，系统为我们进行布局。
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:title style:style target:target action:action];
    self.navigationItem.leftBarButtonItem = left;
}

/*********** 新增 ***********/
//创建上导航左侧按钮(以view作模板)
- (void)createNavigationLeftButton:(id)view {
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = leftItem;
}

/*********** 新增 ***********/
- (void)createNavigationBarRightBarButtonItemWithTitle:(NSString *)title {
    [self createNavigationBarRightBarButtonItemWithTitle:title style:UIBarButtonItemStylePlain];
}

/*********** 新增 ***********/
- (void)createNavigationBarRightBarButtonItemWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style {
    [self createNavigationBarRightBarButtonItemWithTitle:title style:style target:self action:@selector(rightAction)];
}

/*********** 新增 ***********/
- (void)createNavigationBarRightBarButtonItemWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action {
    //这个可以简单的理解为特殊的按钮，不需要我们去考虑布局，只要实现样式和内容，系统为我们进行布局。
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:title style:style target:target action:action];
    self.navigationItem.rightBarButtonItem = right;
}

/*********** 新增 ***********/
//创建上导航右侧按钮(以view作模板)
- (void)createNavigationRightButton:(id)view {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = rightItem;
}

//左侧按钮的默认行为
- (void)leftAction {
    //我们只实现框架，不实现内容，主要是为了消除警告
}

/*********** 新增 ***********/
//右侧按钮的默认行为
- (void)rightAction {
    //我们只实现框架，不实现内容，主要是为了消除警告
}

/*********** 新增 ***********/
//键盘弹出
- (void)keyboardShow:(NSNotification *)notification {
    
}

/*********** 新增 ***********/
//键盘隐藏
- (void)keyboardHide:(NSNotification *)notification {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
