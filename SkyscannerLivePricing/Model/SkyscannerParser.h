//
//  TripDetailsParser.h
//  SkyscannerTripDetails
//
//  Created by Aung Moe on 7/4/16.
//  Copyright © 2016 Alaric Gonzales. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkyscannerRequest.h"
#import "TripDetailsRequest.h"

@interface SkyscannerParser :NSObject
+ (SkyscannerRequest *)parseTripListJSON:(NSDictionary *)json;
+ (TripDetailsRequest *)parseTripDetailsJSON:(NSDictionary *)json;
@end
