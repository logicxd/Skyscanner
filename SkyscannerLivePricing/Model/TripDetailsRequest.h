//
//  TripDetailsRequest.h
//  SkyscannerTripDetails
//
//  Created by Aung Moe on 7/3/16.
//  Copyright © 2016 Alaric Gonzales. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TripDetailsQuery;
@class SkyscannerBookingOption;
@class SkyscannerBookingItem;
@class SkyscannerSegment;
@class SkyscannerPlace;
@class SkyscannerCarrier;

@interface TripDetailsRequest : NSObject

@property (nonatomic, strong) TripDetailsQuery *query;
@property (nonatomic, strong) NSArray<SkyscannerSegment *> *segments;
@property (nonatomic, strong) NSArray<SkyscannerPlace *> *places;
@property (nonatomic, strong) NSArray<SkyscannerCarrier *> *carriers;
@property (nonatomic, strong) NSArray<SkyscannerBookingOption *> *bookingOptions;

@end
