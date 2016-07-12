//
//  TripDetailsBookingOption.h
//  SkyscannerTripDetails
//
//  Created by Alaric Gonzales on 6/30/16.
//  Copyright © 2016 Alaric Gonzales. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TripDetailsSegment;
@class SkyscannerBookingItem;

@interface SkyscannerBookingOption : NSObject

@property (nonatomic, strong) NSArray <SkyscannerBookingItem *> *bookingItems;

@end
