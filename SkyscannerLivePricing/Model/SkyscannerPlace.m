//
//  SkyscannerPlace.m
//  SkyScannerClone
//
//  Created by Aung Moe on 6/16/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import "SkyscannerPlace.h"

@implementation SkyscannerPlace
- (NSString *)description {
//    @property (nonatomic, copy) NSString *code;
//    @property (nonatomic, copy) NSString *type;
//    @property (nonatomic, copy) NSString *name;
//    @property (nonatomic, strong) NSNumber *placeID;
    return [NSString stringWithFormat:@"code: %@, type: %@, name: %@, placeID: %@", _code, _type, _name, _placeID];
}
@end
