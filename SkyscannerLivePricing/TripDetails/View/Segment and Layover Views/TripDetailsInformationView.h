//
//  TripDetailsSegmentInformationView.h
//  SkyscannerTripDetails
//
//  Created by Aung Moe on 7/5/16.
//  Copyright © 2016 Alaric Gonzales. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TripDetailsInformationViewLayout){
    TripDetailsInformationViewLayoutDefault,
    TripDetailsInformationViewLayoutFlight,
    TripDetailsInformationViewLayoutShortLayover,
    TripDetailsInformationViewLayoutLongLayover
};

@interface TripDetailsInformationView : UIView

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *informationLabel;

/*If initialized through other ways, the tripLayout will be initialized as TripDetailsInformationViewLayoutDefault */
@property (nonatomic) TripDetailsInformationViewLayout tripLayout;

- (instancetype)initWithTripLayout:(TripDetailsInformationViewLayout)tripLayout NS_DESIGNATED_INITIALIZER;

@end
