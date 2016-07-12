//
//  SkyscannerPlaceFactory.h
//  SkyScannerClone
//
//  Created by Alaric Gonzales on 6/21/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SkyscannerPlace;
@class SkyscannerLeg;
@class SkyscannerSegment;
@class SkyscannerAgent;
@class SkyscannerCarrier;


@interface SkyscannerFactory : NSObject

+ (instancetype)sharedFactory;

- (SkyscannerPlace *)skyscannerPlaceWithId:(id)placeID;
- (SkyscannerLeg *)skyscannerLegWithId:(id)legID;
- (SkyscannerSegment *)skyscannerSegmentWithId:(id)segmentID;
- (SkyscannerAgent *)skyscannerAgentWithId:(id)agentID;
- (SkyscannerCarrier *)skyscannerCarrierWithId:(id)carrierID;

@end