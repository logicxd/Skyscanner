//
//  TripDetailsShimmerCellTableViewCell.m
//  SkyscannerTripDetails
//
//  Created by Alaric Gonzales on 6/30/16.
//  Copyright © 2016 Alaric Gonzales. All rights reserved.
//

#import "TripDetailsDirectionalityShimmerTableViewCell.h"
#import "Masonry.h"

@interface TripDetailsDirectionalityShimmerTableViewCell()

@property (strong, nonatomic) UIView *directionalityView;
@property (strong, nonatomic) UIView *directionalityDateView;
@property (strong, nonatomic) UIView *originStationView;
@property (strong, nonatomic) UIView *destinationStationView;
@property (strong, nonatomic) UIView *durationView;
@property (strong, nonatomic) UIView *amountStopsView;

@property (nonatomic) BOOL setConstraints;

@end

@implementation TripDetailsDirectionalityShimmerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.directionalityView = [[UIView alloc] init];
        [self.contentView addSubview:self.directionalityView];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.directionalityDateView = [[UIView alloc] init];
        [self.contentView addSubview:self.directionalityDateView];
        
        self.originStationView = [[UIView alloc] init];
        [self.contentView addSubview:self.originStationView];
        
        self.destinationStationView = [[UIView alloc] init];
        [self.contentView addSubview:self.destinationStationView];
        
        self.durationView = [[UIView alloc] init];
        [self.contentView addSubview:self.durationView];
        
        self.amountStopsView = [[UIView alloc] init];
        [self.contentView addSubview:self.amountStopsView];
        
////////////////////////////////////////////////////////////////////////////////////
        self.directionalityShimmerViews = [[NSMutableArray alloc] initWithCapacity:10];
        for (UIView *subview in self.contentView.subviews) {
            FBShimmeringView *shimmer = [[FBShimmeringView alloc] init];
            shimmer.contentView = subview;
            shimmer.shimmering = YES;
            
            [self.directionalityShimmerViews addObject:shimmer];
            [self.contentView addSubview:_directionalityShimmerViews.lastObject];
            
//            CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
//            CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
//            CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
//            UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
            subview.backgroundColor = [UIColor lightGrayColor];
        }
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    if (!self.setConstraints) {
        CGFloat widthOfDirectionalityView = 85.f;
        CGFloat heightOfDirectionalityView = 15.f;
        CGFloat widthOfOriginStationView = 35.f;
        CGFloat widthOfDurationStationView = 45.f;
        
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        // directionalityView //
        [self.directionalityShimmerViews[0] mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(widthOfDirectionalityView));
            make.height.equalTo(@(heightOfDirectionalityView));
            make.left.equalTo(self.contentView).offset(30.f);
            make.top.equalTo(self.contentView).offset(5.f);
        }];
        
        // directionalityDateView //
        [self.directionalityShimmerViews[1] mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(((UIView *)self.directionalityShimmerViews[0]).mas_right).offset(5.f);
            make.top.width.height.equalTo(self.directionalityShimmerViews[0]);
        }];
        
        //originStationView //
        [self.directionalityShimmerViews[2] mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(((UIView *)self.directionalityShimmerViews[1]).mas_right).offset(5.f);
            make.top.equalTo(self.directionalityShimmerViews[1]);
            make.width.equalTo(@(widthOfOriginStationView));
            make.height.equalTo(@(heightOfDirectionalityView));
        }];
        
        // destinationStationView //
        [self.directionalityShimmerViews[3] mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.width.height.equalTo(self.directionalityShimmerViews[2]);
            make.left.equalTo(((UIView *)self.directionalityShimmerViews[2]).mas_right).offset(5.f);
        }];
        
        // durationView //
        [self.directionalityShimmerViews[4] mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(((UIView *)self.directionalityShimmerViews[0]).mas_bottom).offset(5.f);
            make.width.equalTo(@(widthOfDurationStationView));
            make.height.equalTo(@(heightOfDirectionalityView));
            make.left.equalTo(((UIView *)self.directionalityShimmerViews[0]).mas_left);
        }];
        
        // amountStopsView //
        [self.directionalityShimmerViews[5] mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(((UIView *)self.directionalityShimmerViews[4]).mas_right).offset(5.f);
            make.width.height.baseline.equalTo(self.directionalityShimmerViews[4]);
        }];
        
        self.setConstraints = YES;
    }
    [super updateConstraints];
}

@end
