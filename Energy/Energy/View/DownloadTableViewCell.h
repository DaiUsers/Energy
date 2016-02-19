//
//  DownloadTableViewCell.h
//  Energy
//
//  Created by qianfeng on 15/11/7.
//  Copyright (c) 2015年 wheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CellDelegate <NSObject>

- (void)cellClicked:(id)sender;

@end

@interface DownloadTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *category;
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UIButton *cancel;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIProgressView *progress;
@property (strong, nonatomic) IBOutlet UIButton *play;
@property (copy  , nonatomic) NSString *url;

@property (weak, nonatomic) id <CellDelegate> delegate;

- (void)getSliderValue:(NSString *)url;
- (IBAction)startAction:(id)sender;
- (void)getSpeed;
@end
