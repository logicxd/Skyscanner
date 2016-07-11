//
//  SkyscannerItinerary.h
//  SkyScannerClone
//
//  Created by Aung Moe on 6/16/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SkyscannerLeg;
@class SkyscannerPricingOption;
@class SkyscannerBookingDetailsLink;

@interface SkyscannerItinerary : NSObject

@property (nonatomic, strong) SkyscannerLeg *outboundLeg;
@property (nonatomic, strong) SkyscannerLeg *inboundLeg;
@property (nonatomic, strong) NSArray<SkyscannerPricingOption *> *pricingOptions;
@property (nonatomic, strong) NSArray<SkyscannerBookingDetailsLink *> *bookingDetailsLinks;

@end
