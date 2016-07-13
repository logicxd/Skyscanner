//
//  TripDetailsSegmentTableViewCell.m
//  SkyscannerTripDetails
//
//  Created by Alaric Gonzales on 7/6/16.
//  Copyright © 2016 Alaric Gonzales. All rights reserved.
//

#import "TripDetailsSegmentTableViewCell.h"
#import "TripDetailsInformationView.h"
#import "Masonry.h"

@interface TripDetailsSegmentTableViewCell ()

@property (nonatomic, strong) UIView *flightLine;
@property (nonatomic, strong) UIView *bottomFlightLine;
@property (nonatomic, strong) UIView *topCircleView;
@property (nonatomic, strong) UIImageView *airplaneImage;
@property (nonatomic, strong) UIView *bottomCircleView;

@end


@implementation TripDetailsSegmentTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.originView = [[TripDetailsInformationView alloc] initWithTripLayout:TripDetailsInformationViewLayoutDefault];
        self.originView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.originView];
        
        self.flightView = [[TripDetailsInformationView alloc] initWithTripLayout:TripDetailsInformationViewLayoutFlight];
        self.flightView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.flightView];
        
        self.destinationView = [[TripDetailsInformationView alloc] initWithTripLayout:TripDetailsInformationViewLayoutDefault];
        self.destinationView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.destinationView];
        
        self.flightLine = [[UIView alloc] init];
        self.flightLine.backgroundColor = [UIColor colorWithRed:0 green:.667f blue:1 alpha:1];
        [self.contentView addSubview:self.flightLine];
        
        self.topCircleView = [[UIView alloc] init];
        self.topCircleView.backgroundColor = [UIColor whiteColor];
        self.topCircleView.clipsToBounds = YES;
        self.topCircleView.layer.borderColor = [UIColor colorWithRed:0.494 green:0.494 blue:0.494 alpha:1.00].CGColor;
        self.topCircleView.layer.borderWidth = 1.8f;
        [self.contentView addSubview:self.topCircleView];
        
        self.airplaneImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Entypo_2708(0)_64.png"]];
        self.airplaneImage.backgroundColor = [UIColor whiteColor];
        [self.airplaneImage sizeToFit];
        [self.contentView addSubview:self.airplaneImage];
        
        self.bottomCircleView = [[UIView alloc] init];
        self.bottomCircleView.backgroundColor = [UIColor whiteColor];
        self.bottomCircleView.clipsToBounds = YES;
        self.bottomCircleView.layer.borderColor = [UIColor colorWithRed:0.494 green:0.494 blue:0.494 alpha:1.00].CGColor;
        self.bottomCircleView.layer.borderWidth = 1.8f;
        [self.contentView addSubview:self.bottomCircleView];
        
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.originView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(45.f);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView);
        make.height.equalTo(self.originView.informationLabel);
    }];
    [self.flightView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.flightView.informationLabel);
        make.width.equalTo(self.originView);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.originView.mas_left);
    }];
    [self.destinationView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(self.destinationView.informationLabel);
        make.width.equalTo(self.flightView);
        make.left.equalTo(self.flightView.mas_left);
    }];
    
    [self.flightLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.width.equalTo(@2.5f);
        make.top.equalTo(self.topCircleView.mas_bottom);
        make.bottom.equalTo(self.bottomCircleView.mas_top);
    }];
    [self.topCircleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.flightLine);
        make.centerY.equalTo(self.originView);
        make.width.height.equalTo(@14);
    }];
    [self.airplaneImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.flightLine);
        make.centerY.equalTo(self.flightView);
        make.width.height.equalTo(@24);
    }];
    [self.bottomCircleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.flightLine);
        make.centerY.equalTo(self.destinationView);
        make.width.height.equalTo(@14);
    }];
    
    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.topCircleView.layer.cornerRadius = 14/ 2.f;
    self.airplaneImage.layer.cornerRadius = 24/ 2.f;
    self.bottomCircleView.layer.cornerRadius = 14 / 2.f;
    
//    self.topCircleView.layer.cornerRadius = self.topCircleView.bounds.size.width / 2.f;
//    self.airplaneImage.layer.cornerRadius = self.airplaneImage.bounds.size.height / 2.f;
//    self.bottomCircleView.layer.cornerRadius = self.bottomCircleView.bounds.size.height / 2.f;
}
@end
