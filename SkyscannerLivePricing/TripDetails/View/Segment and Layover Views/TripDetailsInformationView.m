//
//  TripDetailsSegmentInformationView.m
//  SkyscannerTripDetails
//
//  Created by Aung Moe on 7/5/16.
//  Copyright © 2016 Alaric Gonzales. All rights reserved.
//

#import "TripDetailsInformationView.h"
#import "Masonry.h"

@implementation TripDetailsInformationView

#pragma mark - Inits

- (instancetype)init {
    //Should not call this to implement views. But just in case if it's called, this is overriden to try to avoid errors.
    return [self initWithTripLayout:TripDetailsInformationViewLayoutDefault];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    //This is not the correct way to initWithCoder.
    //It's only implemented to get rid of the warning.
    return [self initWithTripLayout:TripDetailsInformationViewLayoutDefault];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithTripLayout:TripDetailsInformationViewLayoutDefault];
}

- (instancetype)initWithTripLayout:(TripDetailsInformationViewLayout)tripLayout {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.timeLabel = [UILabel new];
        [self addSubview:self.timeLabel];
        
        self.informationLabel = [UILabel new];
        self.informationLabel.numberOfLines = 2;
        self.informationLabel.adjustsFontSizeToFitWidth = NO; // If (character length > 55) { YES } else { NO }
        [self addSubview:self.informationLabel];
        
        self.backgroundColor = [UIColor whiteColor];
        self.tripLayout = tripLayout;
    }
    return self;
}

#pragma mark - Constraints


+(BOOL)requiresConstraintBasedLayout{
    return YES;
}

-(void)updateConstraints {
    
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        // Without this, there's an annoying error. //
    }];
    
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.informationLabel);
        make.left.equalTo(self);
        make.width.equalTo(@105);
    }];
    
    [self.informationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right);
        make.right.lessThanOrEqualTo(self.mas_right);
        make.top.equalTo(self);
    }];
    
    [super updateConstraints];
}

#pragma mark - Overridden setter for tripLayout

- (void)setTripLayout:(TripDetailsInformationViewLayout)tripLayout {
    _tripLayout = tripLayout;
    const CGFloat TRIP_FONT_SIZE = 13.f;
    
    switch (tripLayout) {
        case TripDetailsInformationViewLayoutDefault:
            [self.timeLabel setFont:[UIFont systemFontOfSize:TRIP_FONT_SIZE]];
            [self.informationLabel setFont:[UIFont systemFontOfSize:TRIP_FONT_SIZE]];
            break;
        case TripDetailsInformationViewLayoutFlight:
            [self.timeLabel setFont:[UIFont systemFontOfSize:TRIP_FONT_SIZE]];
            [self.timeLabel setTextColor:[UIColor colorWithRed:0.494 green:0.494 blue:0.494 alpha:1.00]];
            [self.informationLabel setFont:[UIFont systemFontOfSize:TRIP_FONT_SIZE]];
            [self.informationLabel setTextColor:[UIColor colorWithRed:0.494 green:0.494 blue:0.494 alpha:1.00]];
            break;
        case TripDetailsInformationViewLayoutLongLayover:
            [self.timeLabel setFont:[UIFont systemFontOfSize:TRIP_FONT_SIZE weight:-1.0]];
            [self.timeLabel setTextColor:[UIColor redColor]];
            [self.informationLabel setFont:[UIFont systemFontOfSize:TRIP_FONT_SIZE weight:-1.0]];
            [self.informationLabel setTextColor:[UIColor redColor]];
            break;
            
        case TripDetailsInformationViewLayoutShortLayover:
            [self.timeLabel setFont:[UIFont systemFontOfSize:TRIP_FONT_SIZE]];
            [self.timeLabel setTextColor:[UIColor colorWithRed:0.494 green:0.494 blue:0.494 alpha:1.00]];
            [self.informationLabel setFont:[UIFont systemFontOfSize:TRIP_FONT_SIZE]];
            [self.informationLabel setTextColor:[UIColor colorWithRed:0.494 green:0.494 blue:0.494 alpha:1.00]];
            break;
        default:
            @throw NSInvalidArgumentException;
            break;
    }
    
}

@end
