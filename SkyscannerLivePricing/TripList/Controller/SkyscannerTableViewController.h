//
//  SkyScannerTableViewController.h
//  SkyScannerClone
//
//  Created by Aung Moe on 6/13/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SkyscannerItinerary;

@interface SkyscannerTableViewController : UITableViewController

@property(nonatomic, strong) NSArray <SkyscannerItinerary *> *itineraries;

@end
