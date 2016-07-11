//
//  TripDetailsBookingItem.h
//  SkyscannerTripDetails
//
//  Created by Alaric Gonzales on 6/30/16.
//  Copyright © 2016 Alaric Gonzales. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TripDetailsSegment;

@interface SkyscannerBookingItem : NSObject

@property (nonatomic, strong) NSNumber *agentID;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSURL *bookingOptionLink;
@property (nonatomic, strong) NSArray <TripDetailsSegment *> *segmentID;

@end
