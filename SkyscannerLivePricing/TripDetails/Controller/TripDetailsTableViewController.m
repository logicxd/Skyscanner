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
#import "SkyscannerSegment.h"
#import "EmptyTableViewCell.h"

@interface TripDetailsTableViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *view;
@property (nonatomic, strong) TripDetailsRequest *request;
@property (nonatomic, strong) NSArray *cellTypes;
@end

@implementation TripDetailsTableViewController

@dynamic view;

- (void)loadView {
    self.view = [[UITableView alloc] init];
    self.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view registerClass:[TripDetailsDirectionalityShimmerTableViewCell class] forCellReuseIdentifier:@"DirectionalityShimmer"];
    [self.view registerClass:[TripDetailsSegmentShimmerTableViewCell class] forCellReuseIdentifier:@"SegmentShimmer"];
    [self.view registerClass:[TripDetailsLayoverShimmerTableViewCell class] forCellReuseIdentifier:@"LayoverShimmer"];
    [self.view registerClass:[EmptyTableViewCell class] forCellReuseIdentifier:@"EmptyCells"];
    [self.view registerClass:[TripDetailsSegmentTableViewCell class] forCellReuseIdentifier:@"SegmentCells"];
    [self.view registerClass:[TripDetailsLayoverTableViewCell class] forCellReuseIdentifier:@"LayoverCells"];
    [self.view registerClass:[TripDetailsDirectionTableViewCell class] forCellReuseIdentifier:@"DirectionCells"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.delegate = self;
    self.view.dataSource = self;
    
    SkyscannerNetworking *network = [SkyscannerNetworking sharedNetworking];
    
    void (^putRequestBlock)(NSString *, NSError *) = ^(NSString *itineraryKey, NSError *error) {
        if (!itineraryKey) {
            NSLog(@"ItineraryKey is nil. At line %d", __LINE__);
            return;
        }
        [network getRequestForBookingDetailsWithSessionKey:self.requestID
                                              itineraryKey:itineraryKey
                                                completion:^(NSDictionary *JSON, NSError *error) {
                                                    NSLog(@"GETRequestForBookingDetails is success");
                                                    if (JSON) {
                                                        NSLog(@"   JSON != nil");
                                                        self.request = [SkyscannerParser parseTripDetailsJSON:JSON];
                                                        self.cellTypes = [self determineCellTypes];
                                                        [self.view reloadData];
                                                    }
                                                  
                                                }];
    };
    
    [network putRequestForBookingDetailsWithSessionID:self.requestID
                                        outboundLegID:self.outboundLeg.legID
                                         inboundLegID:self.inboundLeg.legID
                                           completion:putRequestBlock];
}

#pragma mark - Table view data source

//Private method: Determines what type of cell is at the index.
- (NSArray *)determineCellTypes {
    NSMutableArray *cellTypes = [NSMutableArray array];
    [cellTypes addObject:TripDetailsCellTypeBookingDetails];
    
    return cellTypes;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.request) {
        int countRows = 1;          //Booking Options is one row. (one cell).
        countRows += 2;             //A row for 'Outbound title' and a row for 'Inbound title'
        
        //The count of segments is added. Each segment has a destination and origin,
        //therefore, each segment contributes to two rows.
        countRows += self.request.segments.count * 2;
        
        int outboundSegmentCount = 0;
        int inboundSegmentCount = 0;
        for (SkyscannerSegment *segment in self.request.segments) {
            if ([segment.directionality isEqualToString:@"Outbound"]) {
                outboundSegmentCount++;
                
                //Every segment that is bigger than 1 has a layover.
                if (outboundSegmentCount > 1) {
                    countRows++; //Add a single layover row.
                }
            } else if ([segment.directionality isEqualToString:@"Inbound"]) {
                inboundSegmentCount++;
                
                //Every segment that is bigger than 1 has a layover.
                if (inboundSegmentCount > 1) {
                    countRows++;
                }
            }
        }
        
        return countRows;
    }
    return 10;
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
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.request) {
        //Booking Details row.
        if (indexPath.row == 0) {
            return 20;
        }
        //Outbound directionality row.
        else if (indexPath.row == 1 || indexPath.row == 6) {
            return 50;
        }
        
        //Segment rows.
        else if (indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 7 || indexPath.row == 9) {
            return 120;
        }
        
        //Layover rows.
        else if (indexPath.row == 3 || indexPath.row == 8) {
            return 50;
        }
        
        //Empty cells.
        else {
            return 20;
        }
    } else {    //Shimmering cells.
        
        //Booking Details row.
        if (indexPath.row == 0) {
            return 20;
        }
        //Outbound directionality row.
        else if (indexPath.row == 1 || indexPath.row == 6) {
            return 50;
        }
        
        //Segment rows.
        else if (indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 7 || indexPath.row == 9) {
            return 120;
        }
        
        //Layover rows.
        else if (indexPath.row == 3 || indexPath.row == 8) {
            return 50;
        }
        
        //Empty cells.
        else {
            return 20;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.request) {
        
        
        //Booking Details row.
        if (indexPath.row == 0) {
            return [tableView dequeueReusableCellWithIdentifier:@"EmptyCells" forIndexPath:indexPath];
        }
        //Outbound directionality row.
        else if (indexPath.row == 1 || indexPath.row == 6) {
            TripDetailsDirectionalityShimmerTableViewCell *cell =
            [tableView dequeueReusableCellWithIdentifier:@"DirectionCells"
                                            forIndexPath:indexPath];
            return cell;
        }
        
        //Segment rows.
        else if (indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 7 || indexPath.row == 9) {
            TripDetailsSegmentTableViewCell *cell =
            [tableView dequeueReusableCellWithIdentifier:@"SegmentCells"
                                            forIndexPath:indexPath];
            return cell;
        }
        
        //Layover rows.
        else if (indexPath.row == 3 || indexPath.row == 8) {
            TripDetailsLayoverTableViewCell *cell =
            [tableView dequeueReusableCellWithIdentifier:@"LayoverCells"
                                            forIndexPath:indexPath];
            return cell;
        }
        
        //Empty cells.
        else {
            return [tableView dequeueReusableCellWithIdentifier:@"EmptyCells" forIndexPath:indexPath];
        }
        
    } else {    //Shimmering cells
        
        //Booking Details row.
        if (indexPath.row == 0) {
            return [tableView dequeueReusableCellWithIdentifier:@"EmptyCells" forIndexPath:indexPath];
        }
        //Outbound directionality row.
        else if (indexPath.row == 1 || indexPath.row == 6) {
            return [tableView dequeueReusableCellWithIdentifier:@"DirectionalityShimmer" forIndexPath:indexPath];
        }
        
        //Segment rows.
        else if (indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 7 || indexPath.row == 9) {
            return [tableView dequeueReusableCellWithIdentifier:@"SegmentShimmer" forIndexPath:indexPath];
        }
        
        //Layover rows.
        else if (indexPath.row == 3 || indexPath.row == 8) {
            return [tableView dequeueReusableCellWithIdentifier:@"LayoverShimmer" forIndexPath:indexPath];
        }
        
        //Empty cells.
        else {
            return [tableView dequeueReusableCellWithIdentifier:@"EmptyCells" forIndexPath:indexPath];
        }
    }

}

@end

