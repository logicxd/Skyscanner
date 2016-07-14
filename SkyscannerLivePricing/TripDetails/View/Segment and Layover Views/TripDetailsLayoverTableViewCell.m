//
//  TripDetailsLayoverTableViewCell.m
//  SkyscannerTripDetails
//
//  Created by Alaric Gonzales on 7/7/16.
//  Copyright © 2016 Alaric Gonzales. All rights reserved.
//

#import "TripDetailsLayoverTableViewCell.h"
#import "TripDetailsInformationView.h"
#import "Masonry.h"

@interface TripDetailsLayoverTableViewCell()
@end
@implementation TripDetailsLayoverTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:
(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.layoverView = [[TripDetailsInformationView alloc] initWithTripLayout:TripDetailsInformationViewLayoutLongLayover];
        [self.contentView addSubview:self.layoverView];
        
        self.layoverFlightLine = [[UIView alloc] init];
        self.layoverFlightLine.backgroundColor = [UIColor lightGrayColor];
    }
return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.layoverView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(45.f);
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(self.layoverView.informationLabel);
    }];
    [super updateConstraints];
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGFloat pattern[] = {3, 8};
    [[UIColor lightGrayColor] setStroke];
    [path setLineDash:pattern count:2 phase:0];
    [path setLineWidth:2.f];
    [path moveToPoint:CGPointMake(21, 0)];
    [path addLineToPoint:CGPointMake(21, 50)];
    [path closePath];
    [path stroke];
}

@end
