//
//  SkyscannerPlaceFactory.m
//  SkyScannerClone
//
//  Created by Alaric Gonzales on 6/21/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import "SkyscannerFactory.h"
#import "SkyscannerPlace.h"
#import "SkyscannerLeg.h"
#import "SkyscannerSegment.h"
#import "SkyscannerAgent.h"
#import "SkyscannerCarrier.h"


@interface SkyscannerFactory()
@property (nonatomic, strong) NSMutableDictionary<id, SkyscannerPlace *> *placesByID;
@property (nonatomic, strong) NSMutableDictionary<id, SkyscannerLeg *> *legsByID;
@property (nonatomic, strong) NSMutableDictionary<id, SkyscannerSegment *> *segmentsByID;
@property (nonatomic, strong) NSMutableDictionary<id, SkyscannerAgent *> *agentsByID;
@property (nonatomic, strong) NSMutableDictionary <id, SkyscannerCarrier *> *carriersByID;
@end

@implementation SkyscannerFactory

+ (instancetype)sharedFactory {
    static SkyscannerFactory *sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[SkyscannerFactory alloc] init];
        sharedInstance.placesByID = [NSMutableDictionary dictionary];
        sharedInstance.legsByID = [NSMutableDictionary dictionary];
        sharedInstance.segmentsByID = [NSMutableDictionary dictionary];
        sharedInstance.carriersByID = [NSMutableDictionary dictionary];
        sharedInstance.agentsByID = [NSMutableDictionary dictionary];
    });
    return sharedInstance;
}

- (SkyscannerAgent *)skyscannerAgentWithId:(id)agentID {
    SkyscannerAgent *agent = [self.agentsByID objectForKey:agentID];
    if (!agent) {
        agent = [[SkyscannerAgent alloc] init];
        [self.agentsByID setObject:agent forKey:agentID];
    }
    return agent;
}

- (SkyscannerPlace *)skyscannerPlaceWithId:(id)placeID {
    SkyscannerPlace *place = [self.placesByID objectForKey:placeID];
    
    if (!place) {
        place = [[SkyscannerPlace alloc] init];
        [self.placesByID setObject:place forKey:placeID];
    }
    
    return place;
}

- (SkyscannerLeg *)skyscannerLegWithId:(id)legID {
    SkyscannerLeg *leg = [self.legsByID objectForKey:legID];
    
    if (!leg) {
        leg = [[SkyscannerLeg alloc] init];
        [self.legsByID setObject:leg forKey:legID];
    }
    
    return leg;
}

- (SkyscannerSegment *)skyscannerSegmentWithId:(id)segmentID {
    SkyscannerSegment *segment = [self.segmentsByID objectForKey:segmentID];
    
    if (!segment) {
        segment = [[SkyscannerSegment alloc] init];
        [self.segmentsByID setObject:segment forKey:segmentID];
    }
    
    return segment;
}

- (SkyscannerCarrier *)skyscannerCarrierWithId:(id)carrierID{
    SkyscannerCarrier *carrier = [self.carriersByID objectForKey:carrierID];
    
    if (!carrier) {
        carrier = [[SkyscannerCarrier alloc] init];
        [self.carriersByID setObject:carrier forKey:carrierID];
    }
    return carrier;
}






@end
