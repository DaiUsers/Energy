//
//  DetailViewController.h
//  Energy
//
//  Created by qianfeng on 15/11/6.
//  Copyright (c) 2015年 wheng. All rights reserved.
//

#import "BaseViewController.h"

#import "WHData.h"

@interface DetailViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UIImageView *bottomImage;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *desc;
@property (strong, nonatomic) IBOutlet UILabel *headTitle;
@property (strong, nonatomic) IBOutlet UILabel *category;
@property (strong, nonatomic) IBOutlet UIButton *love;
@property (strong, nonatomic) IBOutlet UIButton *share;
@property (strong, nonatomic) IBOutlet UIButton *down;

- (id)initWithDataModel:(WHData *)model;

@end
