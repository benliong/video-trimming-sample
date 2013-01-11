//
//  VDOVideoCell.h
//  Video Demo
//
//  Created by Ben Liong on 11/1/13.
//  Copyright (c) 2013 Pixls Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VDOVideoCell : UITableViewCell

@property (nonatomic, assign) IBOutlet UIImageView *videoThumbnailImageView;
@property (nonatomic, assign) IBOutlet UILabel *videoTitleLabel;
@property (nonatomic, assign) IBOutlet UILabel *videoDetailsLabel;
@property (nonatomic, assign) IBOutlet UIProgressView *progressView;
@property (nonatomic, assign) BOOL completed;
@end
