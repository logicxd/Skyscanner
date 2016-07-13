//
//  TwoPlaneFlightTableViewCell.m
//  SkyScannerClone
//
//  Created by Aung Moe on 6/13/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import "TwoPlaneFlightTableViewCell.h"
#import "Masonry.h"

@interface TwoPlaneFlightTableViewCell()

@property (readonly) CGFloat fontSizeTravelTime;
@property (readonly) CGFloat fontSizeDestination;
@property (readonly) CGFloat fontSizeNumOfStops;
@property (readonly) CGFloat fontSizeTimeEstimate;

@property (nonatomic) BOOL setConstraints;
@end

@implementation TwoPlaneFlightTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        _fontSizeTravelTime = 15.f;
        _fontSizeDestination = 12.f;
        _fontSizeNumOfStops = 15.f;
        _fontSizeTimeEstimate = 12.f;
        
        self.first_ImageIcon = [[UIImageView alloc] init];
        self.first_ImageIcon.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.first_ImageIcon];
        
        self.first_TravelTime = [[UILabel alloc] init];
        [self.first_TravelTime setFont:[UIFont boldSystemFontOfSize:_fontSizeTravelTime]];
        [self.contentView addSubview:self.first_TravelTime];
        
        self.first_Destination = [[UILabel alloc] init];
        [self.first_Destination setFont:[UIFont systemFontOfSize:_fontSizeDestination]];
        [self.first_Destination setTextColor:[UIColor grayColor]];
        [self.contentView addSubview:self.first_Destination];
        
        self.first_NumOfStops = [[UILabel alloc] init];
        [self.first_NumOfStops setFont:[UIFont systemFontOfSize:_fontSizeNumOfStops]];
        [self.first_NumOfStops setTextColor: [UIColor redColor]];
        [self.first_NumOfStops setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:self.first_NumOfStops];
        
        self.first_TimeEstimate = [[UILabel alloc] init];
        [self.first_TimeEstimate setFont:[UIFont systemFontOfSize:_fontSizeTimeEstimate]];
        [self.first_TimeEstimate setTextColor:[UIColor grayColor]];
        [self.first_TimeEstimate setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:self.first_TimeEstimate];
        
        self.second_ImageIcon = [[UIImageView alloc] init];
        self.second_ImageIcon.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.second_ImageIcon];
        
        self.second_TravelTime = [[UILabel alloc] init];
        [self.second_TravelTime setFont:[UIFont boldSystemFontOfSize:_fontSizeTravelTime]];
        [self.contentView addSubview:self.second_TravelTime];
        
        self.second_Destination = [[UILabel alloc] init];
        [self.second_Destination setFont:[UIFont systemFontOfSize:_fontSizeDestination]];
        [self.second_Destination setTextColor:[UIColor grayColor]];
        [self.contentView addSubview:self.second_Destination];
        
        self.second_NumOfStops = [[UILabel alloc] init];
        [self.second_NumOfStops setFont:[UIFont systemFontOfSize:_fontSizeNumOfStops]];
        [self.second_NumOfStops setTextColor:[UIColor redColor]];
        [self.second_NumOfStops setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:self.second_NumOfStops];
        
        self.second_TimeEstimate = [[UILabel alloc] init];
        [self.second_TimeEstimate setFont:[UIFont systemFontOfSize:_fontSizeTimeEstimate]];
        [self.second_TimeEstimate setTextColor:[UIColor grayColor]];
        [self.second_TimeEstimate setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:self.second_TimeEstimate];
        
        self.ratingHappyness = [[UILabel alloc] init];
        [self.ratingHappyness setFont:[UIFont systemFontOfSize:10.f]];
        [self.ratingHappyness setTextColor:[UIColor darkGrayColor]];
        [self.contentView addSubview:self.ratingHappyness];
        
        self.ratingForCheapest = [[UILabel alloc] init];
        [self.ratingForCheapest setFont:[UIFont systemFontOfSize:10.f]];
        [self.ratingForCheapest setTextColor:[UIColor greenColor]];
        [self.contentView addSubview:self.ratingForCheapest];
        
        self.cost = [[UILabel alloc] init];
        [self.cost setFont:[UIFont systemFontOfSize:15.f]];
        [self.cost setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:self.cost];
        
        self.flightProvider = [[UILabel alloc] init];
        [self.flightProvider setFont:[UIFont systemFontOfSize:10.f]];
        [self.flightProvider setTextColor:[UIColor grayColor]];
        [self.flightProvider setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:self.flightProvider];
    }
    
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    if (!self.setConstraints) {
        self.setConstraints = YES;

        CGFloat lengthOfImageIcon = 20.f;
        CGSize sizeOfTravelTime = CGSizeMake(160.f, 18.f);
        CGSize sizeOfDestination = CGSizeMake(170.f, 18.f);
        CGSize sizeOfNumOfStops = CGSizeMake(80.f, 18.f);
        CGSize sizeOfTimeEstimate = CGSizeMake(80.f, 18.f);
        CGSize sizeOfRatingHappy = CGSizeMake(120.f, 16.f);
        CGSize sizeOfRatingCheap = CGSizeMake(120.f, 16.f);
        CGSize sizeOfCost = CGSizeMake(120.f, 21.f);
        CGSize sizeOfFlightProvider = CGSizeMake(120.f, 18.f);

        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(15.f, 13.f, 15.f, 13.f));
        }];

        [self.first_ImageIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(lengthOfImageIcon));
            make.right.lessThanOrEqualTo(self.first_NumOfStops.mas_left);
            make.left.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(4.f);
        }];

        [self.first_TravelTime mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(sizeOfTravelTime.width));
            make.height.equalTo(@(sizeOfTravelTime.height));
            make.top.equalTo(self.contentView);
            make.left.equalTo(_first_ImageIcon.mas_right).offset(12.f);
        }];

        [self.first_Destination mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(sizeOfDestination.width));
            make.height.equalTo(@(sizeOfDestination.height));
            make.top.equalTo(_first_TravelTime.mas_bottom);
            make.left.equalTo(_first_TravelTime);
        }];

        [self.first_NumOfStops mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(sizeOfNumOfStops.width));
            make.height.equalTo(@(sizeOfNumOfStops.height));
            make.baseline.equalTo(_first_TravelTime.mas_baseline);
            make.right.equalTo(self.contentView);
        }];

        [self.first_TimeEstimate mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(sizeOfTimeEstimate.width));
            make.height.equalTo(@(sizeOfTimeEstimate.height));
            make.baseline.equalTo(_first_Destination);
            make.right.equalTo(self.contentView);
        }];

        [self.second_ImageIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(lengthOfImageIcon));
            make.left.right.equalTo(self.first_ImageIcon);
            make.top.equalTo(self.contentView).offset(57);
        }];

        [self.second_TravelTime mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(sizeOfTravelTime.width));
            make.height.equalTo(@(sizeOfTravelTime.height));
            make.top.equalTo(_first_Destination.mas_bottom).offset(16.f);
            make.left.right.equalTo(self.first_TravelTime);
        }];

        [self.second_Destination mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(sizeOfDestination.width));
            make.height.equalTo(@(sizeOfDestination.height));
            make.top.equalTo(_second_TravelTime.mas_bottom);
            make.left.equalTo(_second_TravelTime);
        }];

        [self.second_NumOfStops mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(sizeOfNumOfStops.width));
            make.height.equalTo(@(sizeOfNumOfStops.height));
            make.baseline.equalTo(_second_TravelTime.mas_baseline);
            make.right.equalTo(self.contentView);
        }];

        [self.second_TimeEstimate mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(sizeOfTimeEstimate.width));
            make.height.equalTo(@(sizeOfTimeEstimate.height));
            make.baseline.equalTo(_second_Destination);
            make.right.equalTo(self.contentView);
        }];

        [self.ratingHappyness mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(sizeOfRatingHappy.width));
            make.height.equalTo(@(sizeOfRatingHappy.height));
            make.top.equalTo(_second_ImageIcon.mas_bottom).offset(23.f);
            make.left.equalTo(self.contentView);
        }];

        [self.ratingForCheapest mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(sizeOfRatingCheap.width));
            make.height.equalTo(@(sizeOfRatingCheap.height));
            make.top.equalTo(_ratingHappyness.mas_bottom);
            make.left.equalTo(self.contentView);
        }];

        [self.cost mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(sizeOfCost.width));
            make.height.equalTo(@(sizeOfCost.height));
            make.baseline.equalTo(self.ratingHappyness);
            make.right.equalTo(self.contentView);
        }];

        [self.flightProvider mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(sizeOfFlightProvider.width));
            make.height.equalTo(@(sizeOfFlightProvider.height));
            make.baseline.equalTo(self.ratingForCheapest);
            make.right.equalTo(self.contentView);
        }];
    }

    [super updateConstraints];
}

@end
