//
//  TwoPlaneFlightTableViewCell.m
//  SkyScannerClone
//
//  Created by Aung Moe on 6/13/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import "SkyShimmerTableViewCell.h"
#import "Masonry.h"

@interface SkyShimmerTableViewCell()

@property (strong, nonatomic) UIView *first_ImageIcon;
@property (strong, nonatomic) UIView *first_TravelTime;
@property (strong, nonatomic) UIView *first_Destination;
@property (strong, nonatomic) UIView *first_NumOfStops;
@property (strong, nonatomic) UIView *first_TimeEstimate;

@property (strong, nonatomic) UIView *second_ImageIcon;
@property (strong, nonatomic) UIView *second_TravelTime;
@property (strong, nonatomic) UIView *second_Destination;
@property (strong, nonatomic) UIView *second_NumOfStops;
@property (strong, nonatomic) UIView *second_TimeEstimate;

@property (strong, nonatomic) UIView *ratingHappyness;
@property (strong, nonatomic) UIView *ratingForCheapest;
@property (strong, nonatomic) UIView *cost;
@property (strong, nonatomic) UIView *flightProvider;

@end

@implementation SkyShimmerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.first_ImageIcon = [[UIView alloc] init];
        self.first_ImageIcon.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self.contentView addSubview:self.first_ImageIcon];
        
        self.first_TravelTime = [[UIView alloc] init];
        self.first_TravelTime.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self.contentView addSubview:self.first_TravelTime];
        
        self.first_Destination = [[UIView alloc] init];
        self.first_Destination.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self.contentView addSubview:self.first_Destination];
        
        self.first_NumOfStops = [[UIView alloc] init];
        self.first_NumOfStops.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self.contentView addSubview:self.first_NumOfStops];
        
        self.first_TimeEstimate = [[UIView alloc] init];
        self.first_TimeEstimate.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self.contentView addSubview:self.first_TimeEstimate];
        
        self.second_ImageIcon = [[UIView alloc] init];
        self.second_ImageIcon.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self.contentView addSubview:self.second_ImageIcon];
        
        self.second_TravelTime = [[UIView alloc] init];
        self.second_TravelTime.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self.contentView addSubview:self.second_TravelTime];
        
        self.second_Destination = [[UIView alloc] init];
        self.second_Destination.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self.contentView addSubview:self.second_Destination];
        
        self.second_NumOfStops = [[UIView alloc] init];
        self.second_NumOfStops.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self.contentView addSubview:self.second_NumOfStops];
        
        self.second_TimeEstimate = [[UIView alloc] init];
        self.second_TimeEstimate.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self.contentView addSubview:self.second_TimeEstimate];
        
        self.ratingHappyness = [[UIView alloc] init];
        self.ratingHappyness.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self.contentView addSubview:self.ratingHappyness];
        
        self.ratingForCheapest = [[UIView alloc] init];
        self.ratingForCheapest.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self.contentView addSubview:self.ratingForCheapest];
        
        self.cost = [[UIView alloc] init];
        self.cost.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self.contentView addSubview:self.cost];
        
        self.flightProvider = [[UIView alloc] init];
        self.flightProvider.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self.contentView addSubview:self.flightProvider];
        
        self.shimmeringViews = [[NSMutableArray alloc] initWithCapacity:14];
        for (UIView *eachView in self.contentView.subviews) {
            FBShimmeringView *shimmer = [[FBShimmeringView alloc] init];
            shimmer.contentView = eachView;
            shimmer.shimmering = YES;
            [self.shimmeringViews addObject:shimmer];
            [self.contentView addSubview:_shimmeringViews.lastObject];
        }
        
    }
    
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    CGFloat lengthOfImageIcon = 30.f;
    CGSize sizeOfTravelTime = CGSizeMake(150.f, 15.f);
    CGSize sizeOfDestination = CGSizeMake(150.f, 15.f);
    CGSize sizeOfNumOfStops = CGSizeMake(80.f, 15.f);
    CGSize sizeOfTimeEstimate = CGSizeMake(80.f, 15.f);
    CGSize sizeOfRatingHappy = CGSizeMake(120.f, 15.f);
    CGSize sizeOfRatingCheap = CGSizeMake(120.f, 15.f);
    CGSize sizeOfCost = CGSizeMake(120.f, 15.f);
    CGSize sizeOfFlightProvider = CGSizeMake(120.f, 15.f);
    
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(15.f, 13.f, 15.f, 13.f));
    }];
    
    //ImageIcon
    [self.shimmeringViews[0] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(lengthOfImageIcon));
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
    }];
    
    //TravelTime
    [self.shimmeringViews[1] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(sizeOfTravelTime.width));
        make.height.equalTo(@(sizeOfTravelTime.height));
        make.top.equalTo(self.contentView);
        make.left.equalTo(((UIView *)self.shimmeringViews[0]).mas_right).offset(12.f);
    }];
    
    //Destination
    [self.shimmeringViews[2] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(sizeOfDestination.width));
        make.height.equalTo(@(sizeOfDestination.height));
        make.top.equalTo(((UIView *)self.shimmeringViews[1]).mas_bottom).offset(4.f);
        make.left.equalTo(((UIView *)self.shimmeringViews[1]));
    }];
    
    //NumOfStops
    [self.shimmeringViews[3] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(sizeOfNumOfStops.width));
        make.height.equalTo(@(sizeOfNumOfStops.height));
        make.baseline.equalTo(((UIView *)self.shimmeringViews[1]).mas_baseline);
        make.right.equalTo(self.contentView);
    }];
    
    //TimeEstimate
    [self.shimmeringViews[4] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(sizeOfTimeEstimate.width));
        make.height.equalTo(@(sizeOfTimeEstimate.height));
        make.baseline.equalTo((UIView *)self.shimmeringViews[2]);
        make.right.equalTo(self.contentView);
    }];
    
    //ImageIcon
    [self.shimmeringViews[5] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(lengthOfImageIcon));
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(57);
    }];
    
    //TravelTime
    [self.shimmeringViews[6] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(sizeOfTravelTime.width));
        make.height.equalTo(@(sizeOfTravelTime.height));
        make.top.equalTo(((UIView *)self.shimmeringViews[2]).mas_bottom).offset(16.f);
        make.left.equalTo(((UIView *)self.shimmeringViews[5]).mas_right).offset(12.f);
    }];
    
    //Destination
    [self.shimmeringViews[7] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(sizeOfDestination.width));
        make.height.equalTo(@(sizeOfDestination.height));
        make.top.equalTo(((UIView *)self.shimmeringViews[6]).mas_bottom).offset(4.f);
        make.left.equalTo(((UIView *)self.shimmeringViews[6]));
    }];
    
    //NumOfStops
    [self.shimmeringViews[8] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(sizeOfNumOfStops.width));
        make.height.equalTo(@(sizeOfNumOfStops.height));
        make.baseline.equalTo(((UIView *)self.shimmeringViews[6]).mas_baseline);
        make.right.equalTo(self.contentView);
    }];
    
    //TimeEstimate
    [self.shimmeringViews[9] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(sizeOfTimeEstimate.width));
        make.height.equalTo(@(sizeOfTimeEstimate.height));
        make.baseline.equalTo(((UIView *)self.shimmeringViews[7]));
        make.right.equalTo(self.contentView);
    }];
    
    //RatingHappy
    [self.shimmeringViews[10] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(sizeOfRatingHappy.width));
        make.height.equalTo(@(sizeOfRatingHappy.height));
        make.top.equalTo(((UIView *)self.shimmeringViews[5]).mas_bottom).offset(15.f);
        make.left.equalTo(self.contentView);
    }];
    
    //RatingCheap
    [self.shimmeringViews[11] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(sizeOfRatingCheap.width));
        make.height.equalTo(@(sizeOfRatingCheap.height));
        make.top.equalTo(((UIView *)self.shimmeringViews[10]).mas_bottom).offset(4.f);
        make.left.equalTo(self.contentView);
    }];
    
    //Cost
    [self.shimmeringViews[12] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(sizeOfCost.width));
        make.height.equalTo(@(sizeOfCost.height));
        make.baseline.equalTo(((UIView *)self.shimmeringViews[10]));
        make.right.equalTo(self.contentView);
    }];
    
    //FlightProvider
    [self.shimmeringViews[13] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(sizeOfFlightProvider.width));
        make.height.equalTo(@(sizeOfFlightProvider.height));
        make.baseline.equalTo(((UIView *)self.shimmeringViews[11]));
        make.right.equalTo(self.contentView);
    }];

    [super updateConstraints];
}

@end
