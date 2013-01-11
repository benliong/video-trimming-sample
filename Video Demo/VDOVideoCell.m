//
//  VDOVideoCell.m
//  Video Demo
//
//  Created by Ben Liong on 11/1/13.
//  Copyright (c) 2013 Pixls Limited. All rights reserved.
//

#import "VDOVideoCell.h"

@implementation VDOVideoCell
@synthesize videoThumbnailImageView = _videoThumbnailImageView;
@synthesize videoTitleLabel = _videoTitleLabel;
@synthesize videoDetailsLabel = _videoDetailsLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCompleted:(BOOL)isCompleted {
    if (_completed != isCompleted) {
        _completed = isCompleted;
        self.progressView.hidden = YES;
        self.videoDetailsLabel.text = @"Upload Completed";
    }
}

@end
