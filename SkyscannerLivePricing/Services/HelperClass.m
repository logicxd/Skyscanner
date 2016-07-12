//
//  HelperClass.m
//  SkyScannerClone
//
//  Created by Aung Moe on 6/28/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import "HelperClass.h"

@implementation HelperClass

+ (NSMutableAttributedString *)addAttributesToAllOccurrences:(NSString *)str target:(NSString *)target option:(NSStringCompareOptions)option withAttributes:(NSDictionary *)attributes{
    //Make an attributedString out of the original string.
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    //Variables to hold the NSRange(location, length), where index is from [location] to [length - 1];
    NSUInteger location = 0;
    NSUInteger length = [str length];
    
    //Set up initial range to search the entire string.
    NSRange searchRange = NSMakeRange(location, length);
    
    while (true) {
        //Search for 'target' with searching 'option' in the 'searchRange'
        NSRange findRange = [str rangeOfString:target options:option range:searchRange];
        
        //Add attributes to the range.
        [attributedStr addAttributes:attributes range:findRange];
        
        /*
         Set location = one index after the last 'target' character.
         Set length = length to the end of 'str',
         */
        location = findRange.location + findRange.length;
        length = [str length] - location;
        
        //Runs the loop until searchRange.location == NSNotFound or
        //until searchRange.location is more than [str length];
        if (location >= [str length]) {
            break;
        } else {
            searchRange = NSMakeRange(location, length);
        }
    }
    
    return attributedStr;
}

+ (void)runBlock:(void (^)())block afterTimeInSeconds:(CGFloat)seconds {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}

@end
