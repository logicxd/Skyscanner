//
//  SkyscannerCarrier.h
//  SkyScannerClone
//
//  Created by Aung Moe on 6/16/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkyscannerCarrier : NSObject

@property (nonatomic, copy) NSString *carrierCode;
@property (nonatomic, copy) NSString *carrierName;
@property (nonatomic, copy) NSString *carrierImageURL;
@property (nonatomic, copy) NSString *displayCode;
@property (nonatomic, strong) NSNumber *carrierID;

@end
