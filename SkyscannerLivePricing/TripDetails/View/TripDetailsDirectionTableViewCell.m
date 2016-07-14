//
//  TripDetailsDurationTableViewCell.m
//  SkyscannerTripDetails
//
//  Created by Aung Moe on 7/7/16.
//  Copyright © 2016 Alaric Gonzales. All rights reserved.
//

#import "TripDetailsDirectionTableViewCell.h"
#import "Masonry.h"

@interface TripDetailsDirectionTableViewCell  ()

@property (nonatomic) BOOL setConstraints;

@end

@implementation TripDetailsDirectionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.directionalityLabel = [UILabel new];
        self.directionalityLabel.font = [UIFont boldSystemFontOfSize:14.f];
        [self.contentView addSubview:self.directionalityLabel];
        
        self.timeAndStopLabel = [UILabel new];
        self.timeAndStopLabel.font = [UIFont systemFontOfSize:13.f];
        self.timeAndStopLabel.textColor = [UIColor colorWithRed:0.494 green:0.494 blue:0.494 alpha:1.00];
        
        self.directionalityLabel.text = @"Outbound: Wed, Jul 13, SFO-HND";
        self.timeAndStopLabel.text = @"23h 55m, 1 stop";
        
        [self.contentView addSubview:self.timeAndStopLabel];
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    if (!self.setConstraints) {
        const CGFloat INSET_SIZE = 12.f;
        
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(14.f, INSET_SIZE, 14.f, INSET_SIZE));
        }];
        
        [self.directionalityLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
        }];
        
        [self.timeAndStopLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.directionalityLabel.mas_bottom);
            make.left.equalTo(self.directionalityLabel);
            make.right.equalTo(self.directionalityLabel);
        }];
        self.setConstraints = YES;
    }
    [super updateConstraints];
}

@end
