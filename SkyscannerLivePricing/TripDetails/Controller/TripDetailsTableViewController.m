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
#import "TripDetailsQuery.h"
#import "SkyscannerPlace.h"
#import "SkyscannerNetworking.h"
#import "SkyscannerLeg.h"
#import "TripDetailsRequest.h"
#import "SkyscannerParser.h"
#import "SkyscannerSegment.h"
#import "SkyscannerCarrier.h"
#import "EmptyTableViewCell.h"
#import "HelperClass.h"

@interface TripDetailsTableViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *view;
@property (nonatomic, strong) TripDetailsRequest *request;
@property (nonatomic, strong) NSDictionary *dataSourceDictionary;
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
    self.title = [NSString stringWithFormat:@"%@ - %@", self.outboundLeg.originStation.code, self.outboundLeg.destinationStation.code];
    
    [self fetchData];
    [self.view reloadData];
    
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
                                                    
                                                    if (!JSON) {
                                                        self.request = [SkyscannerParser parseTripDetailsJSON:JSON];
                                                        [self fetchData];
                                                        [self.view reloadData];
                                                    }
                                                  
                                                }];
    };
    
    [network putRequestForBookingDetailsWithSessionID:self.requestID
                                        outboundLegID:self.outboundLeg.legID
                                         inboundLegID:self.inboundLeg.legID
                                           completion:putRequestBlock];
}

#pragma mark - Data Source

- (void)fetchData {
    if (!self.request) {
        NSMutableDictionary *dataSourceDictionary = [NSMutableDictionary dictionary];
        dataSourceDictionary[@0] = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                     @"headerHeight" : @0,
                                                                                     @"numberOfRows" : @8,
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
                                                                                                     }]
                                                                                     }];
        self.dataSourceDictionary = dataSourceDictionary;
        return;
    }
    
    /////////Get settings from JSON//////////////
    NSInteger numberOfRows = 0;
    NSInteger numberOfOutboundSegments = 0;
    NSInteger numberOfInboundSegments= 0;
    NSInteger numberOfOutboundLayovers = 0;
    NSInteger numberOfInboundLayovers = 0;
    
    numberOfRows += 3;                              //BookingOptionsCell, OutboundDirectionalityCell, and InboundDirectionalityCell
    numberOfRows += self.request.segments.count;    //Each segment cell is one row.
    
                                                    //Each layover cell is one row.
    for (SkyscannerSegment *segment in self.request.segments) {
        if ([segment.directionality isEqualToString:@"Outbound"]) {
            //There are (numberOfOutboundSegments - 1) layover cells
            if (++numberOfOutboundSegments > 1) {
                numberOfRows++;
                numberOfOutboundLayovers++;
            }
        } else if ([segment.directionality isEqualToString:@"Inbound"]) {
            //There are (numberOfInboundSegments - 1) layover cells
            if (++numberOfInboundSegments > 1) {
                numberOfRows++;
                numberOfInboundLayovers++;
            }
            
        }
    }
    
    /////////Header/////////////////////////////
    NSInteger headerHeight = 50;
    UILabel *headerView = [[UILabel alloc] init];
    headerView.backgroundColor = [UIColor colorWithWhite:.90f alpha:1];
    headerView.font = [UIFont fontWithName:@"Helvetica-Light" size:14.0];
    headerView.textAlignment = NSTextAlignmentCenter;
    headerView.text = @"TRIP DETAILS";
    
    /////////Data Source: Section 0/////////////////
    NSInteger currentSection = 0;
    
    NSMutableDictionary *dataSourceDictionary = [NSMutableDictionary dictionary];
    dataSourceDictionary[@(currentSection)] = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                              @"headerHeight" : @(headerHeight),
                                                                                              @"headerView" : headerView,
                                                                                              @"numberOfRows" : @(numberOfRows),
                                                                                              @"numberOfOutboundSegments" : @(numberOfOutboundSegments),
                                                                                              @"numberOfInboundSegments" : @(numberOfInboundSegments),
                                                                                              @"numberOfOutboundLayovers" : @(numberOfOutboundLayovers), @"numberOfInboundLayovers" : @(numberOfInboundLayovers)
                                                                                              }];
    
    NSMutableArray *cellRows = [NSMutableArray arrayWithCapacity:numberOfRows];
    
    BOOL needToAddLayover = NO;
    BOOL needToAddSecondDirectionality = YES;
    NSInteger currentOutboundSegment = 0;
    NSInteger currentInboundSegment = 0;
    for (NSInteger currentRow = 0; currentRow < numberOfRows; currentRow++) {
        //First index is always BookingDetails cell
        if (currentRow == 0) {
            
            NSMutableDictionary *cellDictionary = [NSMutableDictionary dictionary];
            [cellDictionary setObject:@"BookingDetails" forKey:@"cell" ];
            [cellDictionary setObject:@20 forKey:@"height"];
            [cellRows addObject:cellDictionary];
        }
        
        //Second index is always OutboundDirectionality cell
        else if (currentRow == 1) {
            NSMutableDictionary *cellDictionary = [NSMutableDictionary dictionary];
            [cellDictionary setObject:@"OutboundDirectionality" forKey:@"cell" ];
            [cellDictionary setObject:@50 forKey:@"height"];
            [cellRows addObject:cellDictionary];
        }
        
        //Current index is an outbound segment.
        else if (currentOutboundSegment < numberOfOutboundSegments && !needToAddLayover){
            NSMutableDictionary *cellDictionary = [NSMutableDictionary dictionary];
            [cellDictionary setObject:@"Segment" forKey:@"cell" ];
            [cellDictionary setObject:@120 forKey:@"height"];
            [cellDictionary setObject:@(currentOutboundSegment) forKey:@"segmentIndex"];
            [cellRows addObject:cellDictionary];
            
            currentOutboundSegment++;
            if (numberOfOutboundSegments - currentOutboundSegment > 0) {
                needToAddLayover = YES;
            }
        }
        
        //Current index is inbound directionality.
        else if (currentOutboundSegment == numberOfOutboundSegments && needToAddSecondDirectionality) {
            needToAddSecondDirectionality = NO;
            
            NSMutableDictionary *cellDictionary = [NSMutableDictionary dictionary];
            [cellDictionary setObject:@"InboundDirectionality" forKey:@"cell" ];
            [cellDictionary setObject:@50 forKey:@"height"];
            [cellRows addObject:cellDictionary];
        }
        
        //Current index is an inbound segment.
        else if (currentInboundSegment < numberOfInboundSegments && !needToAddLayover) {
            NSMutableDictionary *cellDictionary = [NSMutableDictionary dictionary];
            [cellDictionary setObject:@"Segment" forKey:@"cell" ];
            [cellDictionary setObject:@120 forKey:@"height"];
            [cellDictionary setObject:@(currentOutboundSegment + currentInboundSegment) forKey:@"segmentIndex"];
            [cellRows addObject:cellDictionary];
            
            currentInboundSegment++;
            if (numberOfInboundSegments - currentInboundSegment > 0) {
                needToAddLayover = YES;
            }
        }
        
        //Current index is an outbound layover.
        else if (currentOutboundSegment < numberOfOutboundSegments && needToAddLayover) {
            needToAddLayover = NO;
            
            NSMutableDictionary *cellDictionary = [NSMutableDictionary dictionary];
            [cellDictionary setObject:@"Layover" forKey:@"cell" ];
            [cellDictionary setObject:@50 forKey:@"height"];
            [cellDictionary setObject:@(currentOutboundSegment) forKey:@"previousSegment"];
            [cellDictionary setObject:@(currentOutboundSegment+1) forKey:@"nextSegment"];
            [cellRows addObject:cellDictionary];
        }
        
        //Current index is an inbound layover.
        else if (currentInboundSegment < numberOfInboundSegments && needToAddLayover) {
            needToAddLayover = NO;
            
            NSMutableDictionary *cellDictionary = [NSMutableDictionary dictionary];
            [cellDictionary setObject:@"Layover" forKey:@"cell" ];
            [cellDictionary setObject:@50 forKey:@"height"];
            [cellDictionary setObject:@(currentInboundSegment - 1 + currentOutboundSegment) forKey:@"previousSegment"];
            [cellDictionary setObject:@(currentInboundSegment + currentOutboundSegment) forKey:@"nextSegment"];
            [cellRows addObject:cellDictionary];
        }
        
        else {
            NSLog(@" **ERROR** at line %i", __LINE__);
        }
        
    }
    
    [dataSourceDictionary[@(currentSection)] setObject:cellRows forKey:@"rows"];
    
    self.dataSourceDictionary = dataSourceDictionary;
}

#pragma mark - TableView Loading

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSourceDictionary count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dataSource = self.dataSourceDictionary[@(section)];
    return [dataSource[@"rows"] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.dataSourceDictionary[@(section)][@"headerView"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSDictionary *dataSource = self.dataSourceDictionary[@(section)];
    return [dataSource[@"headerHeight"] floatValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dataSource = self.dataSourceDictionary[@(indexPath.section)];
    NSDictionary *row = dataSource[@"rows"][indexPath.row];
    return [row[@"height"] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dataSource = self.dataSourceDictionary[@(0)];
    NSDictionary *cellRow = [dataSource[@"rows"] objectAtIndex:indexPath.row];
    
    const NSInteger numberOfOutboundSegments = [(const NSNumber *) dataSource[@"numberOfOutboundSegments"] integerValue];
    const NSInteger numberOfInboundSegments = [(const NSNumber *) dataSource[@"numberOfInboundSegments"] integerValue];
    
    if ([cellRow[@"cell"] isEqualToString:@"OutboundDirectionality"]) {
        TripDetailsDirectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DirectionCells" forIndexPath:indexPath];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"E, MMM d"];
        NSString *outboundDate = [formatter stringFromDate:self.request.query.outboundDate];
        NSString *originPlaceCode = self.request.query.originPlace.code;
        NSString *destinationPlaceCode = self.request.query.destinationPlace.code;
        cell.directionalityLabel.text =[NSString stringWithFormat:@"Outbound: %@, %@-%@", outboundDate, originPlaceCode, destinationPlaceCode];
        
        
        
        NSInteger totalDuration = 0;
        NSInteger currentNumberOfOutboundLayovers = [dataSource[@"numberOfOutboundLayovers"] integerValue];
        for (NSInteger index = 0; index < numberOfOutboundSegments; index++) {
            totalDuration += [self.request.segments[index].duration integerValue];
            if (currentNumberOfOutboundLayovers > 0) {
                NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self.request.segments[index].timeArrival toDate:self.request.segments[index+1].timeDeparture options:NSCalendarWrapComponents];
                totalDuration += [dateComponents minute];
                currentNumberOfOutboundLayovers--;
            }
            
        }
        NSInteger hour = totalDuration / 60;
        NSInteger minute = totalDuration % 60;
        if (numberOfOutboundSegments == 2) {
            cell.timeAndStopLabel.text = [NSString stringWithFormat:@"%lih %lim, %li stop", (unsigned long) hour, (unsigned long)minute, (unsigned long)(numberOfOutboundSegments-1)];
        } else if (numberOfOutboundSegments > 1) {
            cell.timeAndStopLabel.text = [NSString stringWithFormat:@"%lih %lim, %li stops", (unsigned long) hour, (unsigned long)minute, (unsigned long)(numberOfOutboundSegments-1)];
        } else {
            cell.timeAndStopLabel.text = [NSString stringWithFormat:@"%lih %lim, direct", (unsigned long) hour, (unsigned long)minute];
        }
        
        return cell;
    } else if ([cellRow[@"cell"] isEqualToString:@"InboundDirectionality"]) {
        TripDetailsDirectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DirectionCells" forIndexPath:indexPath];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"E, MMM d"];
        NSString *inboundDate = [formatter stringFromDate:self.request.query.inboundDate];
        NSString *originPlaceCode = self.request.query.destinationPlace.code;
        NSString *destinationPlaceCode = self.request.query.originPlace.code;
        cell.directionalityLabel.text =[NSString stringWithFormat:@"Inbound: %@, %@-%@", inboundDate, originPlaceCode, destinationPlaceCode];
        
        NSInteger totalDuration = 0;
        NSInteger currentNumberOfInboundLayovers = [dataSource[@"numberOfInboundLayovers"] integerValue];
        for (NSInteger index = numberOfOutboundSegments; index < numberOfOutboundSegments + numberOfInboundSegments; index++) {
            totalDuration += [self.request.segments[index].duration integerValue];
            if (currentNumberOfInboundLayovers > 0) {
                NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self.request.segments[index].timeArrival toDate:self.request.segments[index+1].timeDeparture options:NSCalendarWrapComponents];
                totalDuration += [dateComponents minute];
                currentNumberOfInboundLayovers--;
            }
        }
        NSInteger hour = totalDuration / 60;
        NSInteger minute = totalDuration % 60;
        if (numberOfInboundSegments == 2) {
            cell.timeAndStopLabel.text = [NSString stringWithFormat:@"%lih %lim, %li stop", (unsigned long) hour, (unsigned long)minute, (unsigned long)(numberOfInboundSegments-1)];
        } else if (numberOfInboundSegments > 1) {
            cell.timeAndStopLabel.text = [NSString stringWithFormat:@"%lih %lim, %li stops", (unsigned long) hour, (unsigned long)minute, (unsigned long)(numberOfInboundSegments-1)];
        } else {
            cell.timeAndStopLabel.text = [NSString stringWithFormat:@"%lih %lim, direct", (unsigned long) hour, (unsigned long)minute];
        }
        
        return cell;
    }
    
    else if ([cellRow[@"cell"] isEqualToString:@"Segment"]) {
        TripDetailsSegmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SegmentCells" forIndexPath:indexPath];
        NSInteger segmentIndex = [cellRow[@"segmentIndex"] integerValue];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"h:mm a"];
        
        NSString *timeDeparture = [formatter stringFromDate:self.request.segments[segmentIndex].timeDeparture];
        cell.originView.timeLabel.text = timeDeparture;
        cell.originView.informationLabel.text = self.request.segments[segmentIndex].originStation.name;
        
        NSInteger totalDuration = [self.request.segments[segmentIndex].duration integerValue];
        NSInteger hour = totalDuration / 60;
        NSInteger minute = totalDuration % 60;
        NSString *carrierName = self.request.segments[segmentIndex].carrier.carrierName;
        NSString *carrierCode = self.request.segments[segmentIndex].carrier.carrierCode;
        NSInteger flightNumber = [self.request.segments[segmentIndex].flightNumber integerValue];
        cell.flightView.timeLabel.text = [NSString stringWithFormat:@"%lih %lim", (unsigned long)hour, (unsigned long)minute];
        cell.flightView.informationLabel.text = [NSString stringWithFormat:@"%@ - %@%li", carrierName, carrierCode, (unsigned long)flightNumber];
        
        NSString *timeArrival = [formatter stringFromDate:self.request.segments[segmentIndex].timeArrival];
        cell.destinationView.timeLabel.text = timeArrival;
        cell.destinationView.informationLabel.text = self.request.segments[segmentIndex].destinationStation.name;
        
        return cell;
    }
    
    else if ([cellRow[@"cell"] isEqualToString:@"Layover"]) {
        TripDetailsLayoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LayoverCells" forIndexPath:indexPath];
        NSInteger previousSegment = [cellRow[@"previousSegment"] integerValue];
        NSInteger nextSegment =[cellRow[@"nextSegment"] integerValue];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"h:mm a"];
        NSDate *arrivalDate = self.request.segments[previousSegment].timeArrival;
        NSDate *departureDate = self.request.segments[nextSegment].timeDeparture;
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:arrivalDate toDate:departureDate options:NSCalendarWrapComponents];
        NSInteger totalDuration = [dateComponents minute];
        NSInteger hour = totalDuration / 60;
        NSInteger minute = totalDuration % 60;
        cell.layoverView.timeLabel.text = [NSString stringWithFormat:@"%lih %lim", (unsigned long)hour, (unsigned long)minute];
        if (hour >= 3) {
            [cell.layoverView setTripLayout:TripDetailsInformationViewLayoutLongLayover];
            cell.layoverView.informationLabel.text = @"Connection at airport\nLong connection";
        } else {
            [cell.layoverView setTripLayout:TripDetailsInformationViewLayoutShortLayover];
            cell.layoverView.informationLabel.text = @"Connection at airport";
        }
        
        return cell;
    }
    
    else if ([cellRow[@"cell"] isEqualToString:@"DirectionalityShimmer"]) {
        return [tableView dequeueReusableCellWithIdentifier:@"DirectionalityShimmer" forIndexPath:indexPath];
    }
    
    else if ([cellRow[@"cell"] isEqualToString:@"SegmentShimmer"]) {
        return [tableView dequeueReusableCellWithIdentifier:@"SegmentShimmer" forIndexPath:indexPath];
    }
    
    else if ([cellRow[@"cell"] isEqualToString:@"LayoverShimmer"]) {
        return [tableView dequeueReusableCellWithIdentifier:@"LayoverShimmer" forIndexPath:indexPath];
    }
    
    NSLog(@"Enters empty cells");
    return [tableView dequeueReusableCellWithIdentifier:@"EmptyCells" forIndexPath:indexPath];
    
}

@end

