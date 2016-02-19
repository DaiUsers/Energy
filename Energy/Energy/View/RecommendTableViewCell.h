//
//  RecommendTableViewCell.h
//  Energy
//
//  Created by qianfeng on 15/11/5.
//  Copyright (c) 2015年 wheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *backImage;

@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *duration;
@property (strong, nonatomic) IBOutlet UILabel *category;
@end
