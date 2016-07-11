//
//  TDTableViewController.m
//  SkyscannerTripDetails
//
//  Created by Alaric Gonzales on 6/30/16.
//  Copyright © 2016 Alaric Gonzales. All rights reserved.
//

#import "TripDetailsTableViewController.h"
#import "TripDetailsDirectionalityShimmerTableViewCell.h"
#import "TripDetailsSegmentShimmerTableViewCell.h"
#import "TripDetailsLayoverShimmerTableViewCell.h"
#import "TripDetailsInformationView.h"
#import "TripDetailsSegmentTableViewCell.h"
#import "TripDetailsLayoverTableViewCell.h"
#import "TripDetailsDirectionTableViewCell.h"
#import "SkyscannerNetworking.h"
#import "SkyscannerLeg.h"
#import "TripDetailsRequest.h"
#import "SkyscannerParser.h"

@interface TripDetailsTableViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *view;
@property (nonatomic, strong) TripDetailsRequest *request;
@end

@implementation TripDetailsTableViewController

@dynamic view;

- (void)loadView {
    self.view = [[UITableView alloc] init];
    self.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view registerClass:[TripDetailsDirectionalityShimmerTableViewCell class] forCellReuseIdentifier:@"DirectionalityShimmer"];
    [self.view registerClass:[TripDetailsSegmentShimmerTableViewCell class] forCellReuseIdentifier:@"SegmentShimmer"];
    [self.view registerClass:[TripDetailsLayoverShimmerTableViewCell class] forCellReuseIdentifier:@"LayoverShimmer"];
    [self.view registerClass:[TripDetailsSegmentTableViewCell class] forCellReuseIdentifier:@"SegmentCells"];
    [self.view registerClass:[TripDetailsLayoverTableViewCell class] forCellReuseIdentifier:@"LayoverCells"];
    [self.view registerClass:[TripDetailsDirectionTableViewCell class] forCellReuseIdentifier:@"DirectionCells"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.delegate = self;
    self.view.dataSource = self;
    
    void (^putRequestBlock)(NSString *, NSError *) = ^(NSString *itineraryKey, NSError *error) {
        if (!itineraryKey) {
            NSLog(@"ItineraryKey is nil. At line %d", __LINE__);
            return;
        }
        [[SkyscannerNetworking sharedNetworking] getRequestForBookingDetailsWithSessionKey:self.requestID
                                                                              itineraryKey:itineraryKey
                                                                                completion:^(NSDictionary *JSON, NSError *error) {
                                                                                    self.request = [SkyscannerParser parseTripDetailsJSON:JSON];
                                                                                    
                                                                                    [self.view reloadData];
                                                                                }];
    };
    
    [[SkyscannerNetworking sharedNetworking] putRequestForBookingDetailsWithSessionID:self.requestID
                                                                        outboundLegID:self.outboundLeg.legID
                                                                         inboundLegID:self.inboundLeg.legID
                                                                           completion:putRequestBlock];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.request) {
        return self.request.segments.count;
    }
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.backgroundColor = [UIColor colorWithWhite:.90f alpha:1];
    headerLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14.0];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.text = @"TRIP DETAILS";
    return headerLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.request) {
        if (indexPath.row == 0) {
            return 50;
        } else if (indexPath.row % 2 == 0 ) {
            return 50;
        }
        return 120;
    } else {
        return 75;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.request) {
        if (indexPath.row == 0) {
            TripDetailsDirectionalityShimmerTableViewCell *cell =
            [tableView dequeueReusableCellWithIdentifier:@"DirectionCells"
                                            forIndexPath:indexPath];
            return cell;
        } else if (indexPath.row % 2 == 0) {
            TripDetailsLayoverTableViewCell *cell =
            [tableView dequeueReusableCellWithIdentifier:@"LayoverCells"
                                            forIndexPath:indexPath];
            return cell;
        }
        
        TripDetailsSegmentTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"SegmentCells"
                                        forIndexPath:indexPath];
        
        return cell;
    } else {
        if (indexPath.row % 3 == 0) {
            return [tableView dequeueReusableCellWithIdentifier:@"DirectionalityShimmer" forIndexPath:indexPath];
        } else if (indexPath.row % 3 == 1) {
            return [tableView dequeueReusableCellWithIdentifier:@"SegmentShimmer" forIndexPath:indexPath];
        } else {
            return [tableView dequeueReusableCellWithIdentifier:@"LayoverShimmer" forIndexPath:indexPath];
        }
    }

}

@end

