//
//  TripDetailsSegmentTableViewCell.h
//  SkyscannerTripDetails
//
//  Created by Alaric Gonzales on 7/6/16.
//  Copyright © 2016 Alaric Gonzales. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripDetailsInformationView.h"

@interface TripDetailsSegmentTableViewCell : UITableViewCell

@property (nonatomic, strong) TripDetailsInformationView *originView;
@property (nonatomic, strong) TripDetailsInformationView *flightView;
@property (nonatomic, strong) TripDetailsInformationView *destinationView;
@property (nonatomic, strong) UIView *topFlightLine;
@property (nonatomic, strong) UIView *bottomFlightLine;
@property (nonatomic, strong) UIView *topCircleView;
@property (nonatomic, strong) UIImageView *airplaneImage;
@property (nonatomic, strong) UIView *bottomCircleView;

@end
