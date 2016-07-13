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

@end
