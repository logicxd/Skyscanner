//
//  SkyscannerRequest.h
//  SkyScannerClone
//
//  Created by Aung Moe on 6/16/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SkyscannerQuery;
@class SkyscannerItinerary;
@class SkyscannerLeg;
@class SkyscannerSegment;
@class SkyscannerCarrier;
@class SkyscannerAgent;
@class SkyscannerPlace;
@class SkyscannerCurrency;

@interface SkyscannerRequest : NSObject

@property (nonatomic, copy) NSString *sessionKey;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) SkyscannerQuery *query;
@property (nonatomic, strong) NSArray <SkyscannerItinerary *> *itineraries;
@property (nonatomic, strong) NSArray <SkyscannerLeg *> *legs;
@property (nonatomic, strong) NSArray <SkyscannerSegment *> *segments;
@property (nonatomic, strong) NSArray <SkyscannerCarrier *> *carriers;
@property (nonatomic, strong) NSArray <SkyscannerAgent *> *agents;
@property (nonatomic, strong) NSArray <SkyscannerPlace *> *places;
@property (nonatomic, strong) NSArray <SkyscannerCurrency *> *currencies;

@end

