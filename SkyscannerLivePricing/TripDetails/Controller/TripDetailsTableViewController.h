//
//  TDTableViewController.h
//  SkyscannerTripDetails
//
//  Created by Alaric Gonzales on 6/30/16.
//  Copyright © 2016 Alaric Gonzales. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBShimmeringView.h"


typedef NS_ENUM(NSInteger, TripDetailsCellType) {
    TripDetailsCellTypeBookingDetails,
    TripDetailsCellTypeDirectionality,
    TripDetailsCellTypeSegment,
    TripDetailsCellTypeLayover,
    TripDetailsCellTypeEmpty
};


@class SkyscannerLeg;

@interface TripDetailsTableViewController : UITableViewController

@property (nonatomic, copy) NSString *requestID;
@property (nonatomic, strong) SkyscannerLeg *inboundLeg;
@property (nonatomic, strong) SkyscannerLeg *outboundLeg;

@end
