//
//  SkyscannerCurrency.h
//  SkyScannerClone
//
//  Created by Aung Moe on 6/16/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkyscannerCurrency : NSObject

@property (nonatomic, copy) NSString *currencyCode;
@property (nonatomic, copy) NSString *currencySymbol;
@property (nonatomic, copy) NSString *currencyThousandsSeparator;
@property (nonatomic, copy) NSString *currencyDecimalSeparator;
@property (nonatomic, strong) NSNumber *roundingCoefficient;
@property (nonatomic, strong) NSNumber *decimalDigits;
@property (nonatomic) BOOL symbolOnLeft;
@property (nonatomic) BOOL spaceBetweenAmountAndSymbol;

@end
