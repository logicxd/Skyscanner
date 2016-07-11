//
//  SkyscannerAgent.h
//  SkyScannerClone
//
//  Created by Aung Moe on 6/16/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SkyscannerAgent : NSObject

@property (nonatomic, copy) NSString *agentName;
@property (nonatomic, copy) NSString *agentImageURL;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *agentType;
@property (nonatomic, strong) NSNumber *agentID;
@property (nonatomic) BOOL optimisedForMobile;

@end

