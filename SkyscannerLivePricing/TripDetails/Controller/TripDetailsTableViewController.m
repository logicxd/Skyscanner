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
#import "EmptyTableViewCell.h"
#import "SkyscannerTableViewController.h"
#import "SkyscannerSegment.h"
#import "SkyscannerPlace.h"
#import "SkyscannerCarrier.h"
#import "HelperClass.h"
#import "FBShimmeringView.h"
#import "SkyscannerBookingOption.h"
#import "SkyscannerBookingItem.h"

typedef NS_ENUM(NSInteger, TripDetailsCellType){
    TripDetailsCellTypeBookingDetailsCell,
    TripDetailsCellTypeDirectionalityCell,
    TripDetailsCellTypeSegmentCell,
    TripDetailsCellTypeLayoverCell,
};

@interface TripDetailsTableViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *view;
@property (nonatomic, strong) TripDetailsRequest *request;
@property (nonatomic, strong) NSDictionary *dataSourceDictionary;
@property (nonatomic, copy) NSString *itineraryKey;

@property (nonatomic, strong) id resource;

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
    [self.view registerClass:[EmptyTableViewCell class] forCellReuseIdentifier:@"EmptyCells"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchData];
    self.view.delegate = self;
    self.view.dataSource = self;
    
    [self refreshData];
}

- (void)refreshData {
    if (self.itineraryKey) {
        [[SkyscannerNetworking sharedNetworking] getRequestForBookingDetailsWithSessionKey:self.requestID
                                                                              itineraryKey:self.itineraryKey
                                                                                completion:^(NSDictionary *JSON, NSError *error) {
                                                                                    self.request = [SkyscannerParser parseTripDetailsJSON:JSON];
                                                                                    
                                                                                    [self fetchData];
                                                                                    [self.view reloadData];
                                                                                    
                                                                                    BOOL shouldRefresh = NO;
                                                                                    
                                                                                    // Iterate through all booking items in booking options in request
                                                                                    // If one of the booking item's status == Pending || status == Failed, then make another request to get booking details
                                                                                    
                                                                                    for (SkyscannerBookingOption *option in self.request.bookingOptions) {
                                                                                        for (SkyscannerBookingItem *item in option.bookingItems) {
                                                                                            if (![item.status isEqualToString:@"Current"]) {
                                                                                                shouldRefresh = YES;
                                                                                            }
                                                                                            
                                                                                            if (shouldRefresh) {
                                                                                                break;
                                                                                            }
                                                                                        }
                                                                                        
                                                                                        if (shouldRefresh) {
                                                                                            break;
                                                                                        }
                                                                                    }
                                                                                    
                                                                                    if (shouldRefresh) {
                                                                                        [HelperClass runBlock:^{
                                                                                            [self refreshData];
                                                                                        } afterTimeInSeconds:5];
                                                                                    }
                                                                                }];
    } else {
        [[SkyscannerNetworking sharedNetworking] putRequestForBookingDetailsWithSessionID:self.requestID
                                                                            outboundLegID:self.outboundLeg.legID
                                                                             inboundLegID:self.inboundLeg.legID
                                                                               completion:^(NSString *itineraryKey, NSError *error) {
                                                                                   if (error) {
                                                                                       NSLog(@"There was an error");
                                                                                   } else {
                                                                                       self.itineraryKey = itineraryKey;
                                                                                       [self refreshData];
                                                                                   }
                                                                               }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSDictionary *sectionDictionary = self.dataSourceDictionary[@(section)];
    NSNumber *headerHeight = sectionDictionary[@"headerHeight"];
    return headerHeight.integerValue;}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *sectionDictionary = self.dataSourceDictionary[@(section)];
    UIView *headerView = sectionDictionary[@"headerView"];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *sectionDictionary = self.dataSourceDictionary[@(section)];
    NSArray *rows = sectionDictionary[@"rows"];
    return rows.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *sectionDictionary = self.dataSourceDictionary[@(indexPath.section)];
    NSArray *rows = sectionDictionary[@"rows"];
    NSDictionary *rowDictionary = rows[indexPath.row];
    NSNumber *cellHeight = rowDictionary[@"height"];
    return cellHeight.floatValue;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *sectionDictionary = self.dataSourceDictionary[@(indexPath.section)];
    NSArray *rows = sectionDictionary[@"rows"];
    NSDictionary *rowDictionary = rows[indexPath.row];
    NSString *cellType = rowDictionary[@"cell"];
    
    NSDateFormatter *dayMonthFormatter = [NSDateFormatter new];
    [dayMonthFormatter setDateFormat:@"E, d MMM"];
    
    NSDateFormatter *hourMinuteFormatter = [NSDateFormatter new];
    [hourMinuteFormatter setDateFormat: @"h:mm a"];
    
#pragma mark - DIRECTION CELL
    
    if ([cellType isEqualToString:@"DirectionCell"]) {
        TripDetailsDirectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DirectionCells" forIndexPath:indexPath];
        
        SkyscannerLeg *leg = rowDictionary[@"leg"];
        NSInteger duration = leg.duration.integerValue;
        NSInteger days = duration / (1440);
        NSInteger hours = (duration - (days * 1440)) / 60;
        NSInteger minutes = duration - ( (days * 1440) + (hours * 60) );
        
        NSString *durationString;
        if (days == 0) {
            durationString = [NSString stringWithFormat:@"%ih %im", hours, minutes];
        } else {
            durationString = [NSString stringWithFormat:@"%id %ih %im", days, hours, minutes];
        }
        
        NSString *segmentDate = [dayMonthFormatter stringFromDate:leg.timeDeparture];
        NSString *topLabelText = [NSString stringWithFormat:@"%@: %@, %@-%@", leg.directionality, segmentDate, leg.originStation.code, leg.destinationStation.code];
        
        cell.directionalityLabel.text = topLabelText;
        cell.timeAndStopLabel.text = durationString;
        
        return cell;
        
#pragma mark - SEGMENT CELL
        
    } else if ([cellType isEqualToString:@"SegmentCell"]) {
        TripDetailsSegmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SegmentCells" forIndexPath:indexPath];
        SkyscannerSegment *segment = rowDictionary[@"segment"];
        
        NSInteger diff = segment.duration.integerValue;
        NSInteger timeInterval = (NSInteger)diff;
        NSInteger minutes = timeInterval % 60;
        NSInteger hours = (timeInterval / 60);
    
        cell.originView.timeLabel.text = [hourMinuteFormatter stringFromDate:segment.timeDeparture];
        cell.originView.informationLabel.text = segment.originStation.name;
        
        cell.destinationView.timeLabel.text =[hourMinuteFormatter stringFromDate:segment.timeArrival];
        cell.destinationView.informationLabel.text = segment.destinationStation.name;
        
        cell.flightView.timeLabel.text = [NSString stringWithFormat:@"%ih %im",hours, minutes];
        cell.flightView.informationLabel.text = [NSString stringWithFormat:@"%@ - \n %@%@",segment.operatingCarrier.carrierName, segment.operatingCarrier.carrierCode, segment.operatingCarrier.carrierID];
    
        return cell;
        
#pragma mark - LAYOVER CELL
        
    } else if ([cellType isEqualToString:@"LayoverCell"]) {
        
        TripDetailsLayoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LayoverCells" forIndexPath:indexPath];
        SkyscannerSegment *previousSegment = rowDictionary[@"previousSegment"];
        SkyscannerSegment *segment = rowDictionary[@"segment"];
        
        NSTimeInterval diff = [segment.timeDeparture timeIntervalSinceDate:previousSegment.timeArrival];
        NSInteger timeInterval = (NSInteger)diff;
        NSInteger minutes = (timeInterval / 60) % 60;
        NSInteger hours = (timeInterval / 3600);
        
        NSString *timeDiff = [NSString stringWithFormat:@"%lih %lim", (long)hours, (long)minutes];
        
        if (hours >= 3) {
        
            [cell.layoverView setTripLayout:TripDetailsInformationViewLayoutLongLayover];
            cell.layoverView.informationLabel.text = @"Connection at airport \nLong connection";
        
        } else {
        
            [cell.layoverView setTripLayout:TripDetailsInformationViewLayoutShortLayover];
            cell.layoverView.informationLabel.text = @"Connection at airport";
        }
        
        cell.layoverView.timeLabel.text = timeDiff;
        
        return cell;
        
    } else if ([cellType isEqualToString:@"EmptyCell"]) {
        return [tableView dequeueReusableCellWithIdentifier:@"EmptyCells" forIndexPath:indexPath];
    } else if ([cellType isEqualToString:@"DirectionalityShimmer"]) {
        return [tableView dequeueReusableCellWithIdentifier:@"DirectionalityShimmer" forIndexPath:indexPath];
    } else if ([cellType isEqualToString:@"SegmentShimmer"]) {
        return [tableView dequeueReusableCellWithIdentifier:@"SegmentShimmer" forIndexPath:indexPath];
    } else if ([cellType isEqualToString:@"LayoverShimmer"]) {
        return [tableView dequeueReusableCellWithIdentifier:@"LayoverShimmer" forIndexPath:indexPath];
    }
    return nil;
}

- (void)fetchData {
    UILabel *headerView = [[UILabel alloc] init];
    headerView.backgroundColor = [UIColor colorWithWhite:.90f alpha:1];
    headerView.font = [UIFont fontWithName:@"Helvetica-Light" size:14.0];
    headerView.textAlignment = NSTextAlignmentCenter;
    headerView.text = @"TRIP DETAILS";
    
    NSInteger currentSection = 0;
    
    NSMutableDictionary *dataSourceDictionary = [NSMutableDictionary dictionary];
    
    if (self.request) {
        NSMutableArray *rows = [NSMutableArray array];
        
        NSArray<SkyscannerSegment *> *outboundSegments = [self.request.segments filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"directionality = %@", @"Outbound"]];
        NSArray<SkyscannerSegment *> *inboundSegments = [self.request.segments filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"directionality = %@", @"Inbound"]];
        outboundSegments = [outboundSegments sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"timeDeparture" ascending:YES]]];
        inboundSegments = [inboundSegments sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"timeDeparture" ascending:YES]]];
        
        [rows addObject:@{
                          @"cell" : @"DirectionCell",
                          @"height" : @50,
                          @"leg" : self.outboundLeg
                          }];
        
        NSInteger currentSegmentIndex = 0;
        for (SkyscannerSegment *segment in outboundSegments) {
            if (currentSegmentIndex > 0) {
                SkyscannerSegment *previousSegment = outboundSegments[currentSegmentIndex - 1];
                
                [rows addObject:@{
                                  @"cell" : @"LayoverCell",
                                  @"height" : @50,
                                  @"previousSegment" : previousSegment,
                                  @"segment" : segment
                                  }];
            }
            
            [rows addObject:@{
                              @"cell" : @"SegmentCell",
                              @"height" : @120,
                              @"segment" : segment
                              }];
            currentSegmentIndex++;
        }
        
        [rows addObject:@{
                          @"cell" : @"DirectionCell",
                          @"height" : @50,
                          @"leg" : self.inboundLeg
                          }];
        
        currentSegmentIndex = 0;
        for (SkyscannerSegment *segment in inboundSegments) {
            if (currentSegmentIndex > 0) {
                SkyscannerSegment *previousSegment = inboundSegments[currentSegmentIndex - 1];
                
                [rows addObject:@{
                                  @"cell" : @"LayoverCell",
                                  @"height" : @50,
                                  @"previousSegment" : previousSegment,
                                  @"segment" : segment
                                  }];
            }
            
            [rows addObject:@{
                              @"cell" : @"SegmentCell",
                              @"height" : @120,
                              @"segment" : segment
                              }];
            currentSegmentIndex++;
        }
        
        dataSourceDictionary[@(currentSection++)] = @{
                                                      @"headerHeight" : @70,
                                                      @"headerView" : headerView,
                                                      @"rows" : rows
                                                      };
    } else {
        dataSourceDictionary[@(currentSection++)] = @{
                                                      @"headerHeight" : @0,
                                                      @"rows" : @[@{
                                                                      @"cell" : @"DirectionalityShimmer",
                                                                      @"height" : @50
                                                                      },
                                                                  @{
                                                                      @"cell" : @"SegmentShimmer",
                                                                      @"height" : @120
                                                                      },
                                                                  @{
                                                                      @"cell" : @"LayoverShimmer",
                                                                      @"height" : @50
                                                                      },
                                                                  @{
                                                                      @"cell" : @"SegmentShimmer",
                                                                      @"height" : @120
                                                                      },
                                                                  @{
                                                                      @"cell" : @"DirectionalityShimmer",
                                                                      @"height" : @50
                                                                      },
                                                                  @{
                                                                      @"cell" : @"SegmentShimmer",
                                                                      @"height" : @120
                                                                      },
                                                                  @{
                                                                      @"cell" : @"LayoverShimmer",
                                                                      @"height" : @50
                                                                      },
                                                                  @{
                                                                      @"cell" : @"SegmentShimmer",
                                                                      @"height" : @120
                                                                      }
                                                                  ]
                                                      };
    }
    
    self.dataSourceDictionary = dataSourceDictionary;
}


@end

