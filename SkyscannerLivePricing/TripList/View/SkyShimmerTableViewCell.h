
//
//  Created by Aung Moe on 6/13/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBShimmeringView.h"

/*
 1. Change all of these subview types to UIView
 2. Move them to the private interface: SkyShimmerTableViewCell()
 3. Don't declare a property for the shimmeringView, instead
    add them to an array. For example:
    @property (nonatomic, strong) NSMutableArray *shimmeringViews;
    for (UIView *subview in self.subviews) { ... }
 4. Setup constraints
 */

@interface SkyShimmerTableViewCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *shimmeringViews;

@end
