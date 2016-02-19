//
//  UINavigationController+Rotation.m
//  Energy
//
//  Created by qianfeng on 15/11/9.
//  Copyright © 2015年 wheng. All rights reserved.
//

#import "UINavigationController+Rotation.h"

@implementation UINavigationController (Rotation)

//界面 旋转的时候 调用
//是否 支持 界面 旋转
- (BOOL)shouldAutorotate {
    
    //self.topViewController -->获取 当前 导航中正在显示的界面地址(栈顶的子视图控制器)
    //每次旋转 去调用 当前正在显示的界面 控制
    return self.topViewController.shouldAutorotate;
}
//界面支持的方法
- (NSUInteger)supportedInterfaceOrientations {
    //交给导航的当前 子界面 控制器来 控制旋转
    return self.topViewController.supportedInterfaceOrientations;
}



@end
