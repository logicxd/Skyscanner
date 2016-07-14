//
//  EmptyCellTableViewCell.m
//  SkyScannerClone
//
//  Created by Aung Moe on 6/14/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import "EmptyTableViewCell.h"

@implementation EmptyTableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
    }
        
    return self;
}

@end
