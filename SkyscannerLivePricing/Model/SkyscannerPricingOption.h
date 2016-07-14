//
//  SkyscannerPricingOption.h
//  SkyScannerClone
//
//  Created by Aung Moe on 6/16/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SkyscannerAgent;

@interface SkyscannerPricingOption : NSObject

@property (nonatomic, strong) NSArray <SkyscannerAgent *> *agents;
@property (nonatomic, strong) NSNumber *quoteAgeInMinutes;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, copy) NSString *deeplinkURL;

@end
