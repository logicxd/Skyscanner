//
//  SkyScannerTableViewController.h
//  SkyScannerClone
//
//  Created by Aung Moe on 6/13/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SkyscannerTableViewController : UITableViewController
@property (nonatomic, copy) NSString *originStationCode;
@property (nonatomic, copy) NSString *destinationStationCode;
@property (nonatomic, strong) NSDate *departureDate;
@property (nonatomic, strong) NSDate *returnDate;
@end
