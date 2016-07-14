//
//  TripDetailsQuery.h
//  SkyscannerTripDetails
//
//  Created by Alaric Gonzales on 6/30/16.
//  Copyright © 2016 Alaric Gonzales. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SkyscannerPlace;

@interface TripDetailsQuery : NSObject

@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *locale;
@property (nonatomic, strong) NSNumber *adults;
@property (nonatomic, strong) NSNumber *children;
@property (nonatomic, strong) NSNumber *infants;
@property (nonatomic, strong) SkyscannerPlace *originPlace;
@property (nonatomic, strong) SkyscannerPlace *destinationPlace;
@property (nonatomic, copy) NSDate *outboundDate;
@property (nonatomic, copy) NSDate *inboundDate;
@property (nonatomic, copy) NSString *locationSchema;
@property (nonatomic, copy) NSString *cabinClass;
@property (nonatomic) BOOL groupPricing;

@end
