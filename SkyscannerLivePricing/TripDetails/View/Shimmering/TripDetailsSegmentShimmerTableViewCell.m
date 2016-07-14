//
//  SegmentShimmerTableViewCell.m
//  SkyscannerTripDetails
//
//  Created by Alaric Gonzales on 7/1/16.
//  Copyright © 2016 Alaric Gonzales. All rights reserved.
//

#import "TripDetailsSegmentShimmerTableViewCell.h"
#import "Masonry.h"

@interface TripDetailsSegmentShimmerTableViewCell()

@property (nonatomic, strong) UIView *segmentView;
@property (nonatomic, strong) UIView *boardTimeView;
@property (nonatomic, strong) UIView *durationTimeView;
@property (nonatomic, strong) UIView *departTimeView;
@property (nonatomic, strong) UIView *originDestinationView;
@property (nonatomic, strong) UIView *flightCarrierView;
@property (nonatomic, strong) UIView *arrivalDestinationView;
@property (nonatomic, strong) UIView *flightIconView;
@property (nonatomic, strong) UIView *topCircleView;
@property (nonatomic, strong) UIView *middleCircleView;
@property (nonatomic, strong) UIView *bottomCircleView;

@property (nonatomic) BOOL setConstraints;

@end

@implementation TripDetailsSegmentShimmerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];

        self.boardTimeView = [[UIView alloc] init];
        [self.contentView addSubview:self.boardTimeView];
        
        self.durationTimeView = [[UIView alloc] init];
        [self.contentView addSubview:self.durationTimeView];
        
        self.departTimeView = [[UIView alloc] init];
        [self.contentView addSubview:self.departTimeView];
        
        self.originDestinationView = [[UIView alloc] init];
        [self.contentView addSubview:self.originDestinationView];
        
        self.flightCarrierView = [[UIView alloc] init];
        [self.contentView addSubview:self.flightCarrierView];
        
        self.arrivalDestinationView = [[UIView alloc] init];
        [self.contentView addSubview:self.arrivalDestinationView];

        self.flightIconView = [[UIView alloc] init];
        [self.contentView addSubview:self.flightIconView];
        
        self.topCircleView = [[UIView alloc] init];
        self.topCircleView.clipsToBounds = YES;
        [self.contentView addSubview:self.topCircleView];
        
        self.middleCircleView = [[UIView alloc] init];
        self.middleCircleView.clipsToBounds = YES;
        [self.contentView addSubview:self.middleCircleView];
        
        self.bottomCircleView = [[UIView alloc] init];
        self.bottomCircleView.clipsToBounds = YES;
        [self.contentView addSubview:self.bottomCircleView];
        
        self.contentView.backgroundColor = [UIColor whiteColor];

        
////////////////////////////////////////////////////////////////////////////////////
        self.segmentShimmerViews = [[NSMutableArray alloc] initWithCapacity:10];
        for (UIView *subview in self.contentView.subviews) {
            FBShimmeringView *shimmer = [[FBShimmeringView alloc] init];
            shimmer.contentView = subview;
            shimmer.shimmering = YES;
            
            [self.segmentShimmerViews addObject:shimmer];
            [self.contentView addSubview:_segmentShimmerViews.lastObject];
            
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
        CGFloat widthOfBoardTimeView = 80.f;
        CGFloat heightOfBoardTimeView = 25.f;
        CGFloat widthOfOriginDestinationView = 130.f;
        CGFloat widthOfFlightIconView = 2;
        
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        // boardTimeView //
        [self.segmentShimmerViews[0] mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10.f);
            make.height.equalTo(@(heightOfBoardTimeView));
            make.width.equalTo(@(widthOfBoardTimeView));
            make.right.equalTo(((UIView *)self.contentView).mas_centerX).offset(-35.f);
        }];
        
        // durationTimeView //
        [self.segmentShimmerViews[1] mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(((UIView *)self.segmentShimmerViews[0]).mas_bottom).offset(15.f);
            make.width.height.left.equalTo(self.segmentShimmerViews[0]);
        }];
        
        // departTimeView //
        [self.segmentShimmerViews[2] mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(((UIView *)self.segmentShimmerViews[1]).mas_bottom).offset(15.f);
            make.width.height.left.equalTo(self.segmentShimmerViews[1]);
        }];
        
        // originDestinationView //
        [self.segmentShimmerViews[3] mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(((UIView *)self.segmentShimmerViews[0]).mas_right).offset(25.f);
            make.baseline.top.equalTo(self.segmentShimmerViews[0]);
            make.width.equalTo(@(widthOfOriginDestinationView));
        }];
        
        // flightCarrierView //
        [self.segmentShimmerViews[4] mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(((UIView *)self.segmentShimmerViews[1]).mas_right).offset(25.f);
            make.baseline.top.equalTo(self.segmentShimmerViews[1]);
            make.width.equalTo(self.segmentShimmerViews[3]);
        }];
        
        // arrivalDestinationView //
        [self.segmentShimmerViews[5] mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(((UIView *)self.segmentShimmerViews[2]).mas_right).offset(25.f);
            make.baseline.top.equalTo(self.segmentShimmerViews[2]);
            make.width.equalTo(self.segmentShimmerViews[4]);
        }];
        
        // flightIconView //
        [self.segmentShimmerViews[6] mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.top.equalTo(((UIView *)(self.segmentShimmerViews[7])).mas_bottom);
            make.bottom.equalTo(((UIView *)(self.segmentShimmerViews[9])).mas_top);
            make.width.equalTo(@(widthOfFlightIconView));
        }];
        
        //top circle
        [self.segmentShimmerViews[7] mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(((UIView *)self.segmentShimmerViews[6]));
            make.centerY.equalTo(((UIView *)self.segmentShimmerViews[0]).mas_centerY);
            make.width.height.equalTo(@10);
        }];
        
        //middle circle
        [self.segmentShimmerViews[8] mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(((UIView *)self.segmentShimmerViews[6]));
            make.centerY.equalTo(((UIView *)self.segmentShimmerViews[1]).mas_centerY);
            make.width.height.equalTo(@20);
        }];
        
        //bottom circle
        [self.segmentShimmerViews[9] mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(((UIView *)self.segmentShimmerViews[6]));
            make.centerY.equalTo(((UIView *)self.segmentShimmerViews[2]).mas_centerY);
            make.width.height.equalTo(@10);
        }];
        
        self.setConstraints = YES;
    }
    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.topCircleView.layer.cornerRadius = self.topCircleView.bounds.size.height / 2.f;
    self.middleCircleView.layer.cornerRadius = self.middleCircleView.bounds.size.height / 2.f;
    self.bottomCircleView.layer.cornerRadius = self.bottomCircleView.bounds.size.height / 2.f;
}

@end
