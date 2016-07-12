//
//  HelperClass.h
//  SkyScannerClone
//
//  Created by Aung Moe on 6/28/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HelperClass : NSObject

+ (NSMutableAttributedString *)addAttributesToAllOccurrences:(NSString *)str target:(NSString *)target option:(NSStringCompareOptions)option withAttributes:(NSDictionary *)attributes;

+ (void)runBlock:(void (^)())block afterTimeInSeconds:(CGFloat)seconds;

@end
