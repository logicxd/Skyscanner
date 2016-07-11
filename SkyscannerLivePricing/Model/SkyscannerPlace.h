//
//  SkyscannerPlace.h
//  SkyScannerClone
//
//  Created by Aung Moe on 6/16/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkyscannerPlace : NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *placeID;
@property (nonatomic, strong) SkyscannerPlace *parent;

@end

