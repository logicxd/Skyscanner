//
//  SkyscannerLeg.h
//  SkyScannerClone
//
//  Created by Aung Moe on 6/16/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SkyscannerPlace;
@class SkyscannerSegment;
@class SkyscannerCarrier;

@interface SkyscannerLeg : NSObject

@property (nonatomic, copy) NSString *legID;
@property (nonatomic, copy) NSString *journeyMode;
@property (nonatomic, copy) NSString *directionality;
@property (nonatomic, strong) NSNumber *duration;
@property (nonatomic, strong) NSArray <SkyscannerPlace *> *stops;
@property (nonatomic, strong) NSArray <SkyscannerSegment *> *segments;
@property (nonatomic, strong) NSArray <SkyscannerCarrier *> *operatingCarriers;
@property (nonatomic, strong) NSArray <NSNumber *> *flightNumber;
@property (nonatomic, strong) NSArray <SkyscannerCarrier *> *carriers;
@property (nonatomic, strong) SkyscannerPlace *originStation;
@property (nonatomic, strong) SkyscannerPlace *destinationStation;
@property (nonatomic, copy) NSDate *timeDeparture;
@property (nonatomic, copy) NSDate *timeArrival;

@end
