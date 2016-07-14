//
//  LayoverShimmerTableViewCell.m
//  SkyscannerTripDetails
//
//  Created by Alaric Gonzales on 7/1/16.
//  Copyright © 2016 Alaric Gonzales. All rights reserved.
//

#import "TripDetailsLayoverShimmerTableViewCell.h"
#import "Masonry.h"

@interface TripDetailsLayoverShimmerTableViewCell()

@property (nonatomic, strong) UIView *layoverTimeView;
@property (nonatomic, strong) UIView *layoverStatusView;

@property (nonatomic) BOOL setConstraints;
@end

@implementation TripDetailsLayoverShimmerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.layoverTimeView = [[UIView alloc] init];
        [self.contentView addSubview:self.layoverTimeView];
        
        self.layoverStatusView = [[UIView alloc] init];
        [self.contentView addSubview:self.layoverStatusView];
        
        
////////////////////////////////////////////////////////////////////////////////////
        self.layoverShimmerViews = [[NSMutableArray alloc] initWithCapacity:10];
        for (UIView *subview in self.contentView.subviews) {
            FBShimmeringView *shimmer = [[FBShimmeringView alloc] init];
            shimmer.contentView = subview;
            shimmer.shimmering = YES;
            
            [self.layoverShimmerViews addObject:shimmer];
            [self.contentView addSubview:_layoverShimmerViews.lastObject];
            
//            CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
//            CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
//            CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
//            UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
            subview.backgroundColor = [UIColor lightGrayColor];
        }
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    if (!self.setConstraints) {
        CGFloat heightOfLayoverTimeView = 25.f;
        CGFloat widthOfLayoverTimeView = 80.f;
        CGFloat widthOfOriginDestinationView = 130.f;
        
        
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        //  layoverTimeView
        [self.layoverShimmerViews[0] mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10.f);
            make.width.equalTo(@(widthOfLayoverTimeView));
            make.height.equalTo(@(heightOfLayoverTimeView));
            make.right.equalTo(((UIView *)self.contentView).mas_centerX).offset(-35.f);
        }];
        
        // layoverStatusView //
        [self.layoverShimmerViews[1] mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(((UIView *)self.layoverShimmerViews[0]).mas_right).offset(25.f);
            make.baseline.top.equalTo(self.layoverShimmerViews[0]);
            make.width.equalTo(@(widthOfOriginDestinationView));
        }];
        
        self.setConstraints = YES;
    }
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
