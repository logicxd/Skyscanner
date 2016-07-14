//
//  SkyScannerTableViewController.m
//  SkyScannerClone
//
//  Created by Aung Moe on 6/13/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import "SkyscannerTableViewController.h"
#import "TwoPlaneFlightTableViewCell.h"
#import "EmptyTableViewCell.h"
#import "SkyShimmerTableViewCell.h"
#import "SkyscannerRequest.h"
#import "SkyscannerQuery.h"
#import "SkyscannerCurrency.h"
#import "SkyscannerPlace.h"
#import "SkyscannerItinerary.h"
#import "SkyscannerLeg.h"
#import "SkyscannerSegment.h"
#import "SkyscannerAgent.h"
#import "SkyscannerCarrier.h"
#import "SkyscannerPricingOption.h"
#import "SkyscannerBookingDetailsLink.h"
#import "SkyscannerFactory.h"
#import "UIImageView+AFNetworking.h"
#import "HelperClass.h"
#import "SkyscannerNetworking.h"
#import "RPJSONMapper.h"
#import "TripDetailsTableViewController.h"
#import "SkyscannerParser.h"

@interface SkyscannerTableViewController ()
@property (strong, nonatomic) UITableView *view;
@property(nonatomic, strong) NSArray <SkyscannerItinerary *> *itineraries;
@property (nonatomic, copy) NSString *requestID;
@end

@implementation SkyscannerTableViewController

@dynamic view;

- (void)loadView {
    self.view = [[UITableView alloc] init];
    
    [self.view registerClass:[TwoPlaneFlightTableViewCell class] forCellReuseIdentifier:@"TwoPlaneFlight"];
    [self.view registerClass:[EmptyTableViewCell class] forCellReuseIdentifier:@"EmptyCell"];
    [self.view registerClass:[SkyShimmerTableViewCell class] forCellReuseIdentifier:@"SkyShimmer"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.delegate = self;
    self.view.dataSource = self;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    SkyscannerNetworking *networkJson = [SkyscannerNetworking sharedNetworking];
    [networkJson postSessionWithOriginPlace:self.originStationCode
                           destinationPlace:self.destinationStationCode
                               outboundDate:[dateFormatter stringFromDate:self.departureDate]
                                inboundDate:[dateFormatter stringFromDate:self.returnDate]
                                 completion:^(NSString *requestID, NSError *error) {
                                     if (requestID != nil) {
                                         self.requestID = requestID;
                                         
                                         NSLog(@"RequestID != nil.");
                                         [networkJson pollPricingRequestWithRequestID:requestID completion:^(NSDictionary *json, NSError *error) {
                                             if (json != nil) {
                                                 NSLog(@"json != nil.");
                                                 NSLog(@"requestID == %@", requestID);
                                                 SkyscannerRequest *request = [SkyscannerParser parseTripListJSON:json];
                                                 self.itineraries = request.itineraries;
                                                 [self.view reloadData];
                                                 NSLog(@"request.status == %@", request.status);
                                                 if (![request.status isEqualToString: @"UpdatesComplete"]) {
                                                     NSLog(@"Running timer");
                                                     [HelperClass runBlock:^{
                                                         [self refreshData:networkJson requestID:requestID];
                                                     } afterTimeInSeconds:5];
                                                 }
                                             } else {
                                                 NSLog(@"json == nil, running timer");                                                 [HelperClass runBlock:^{ [self refreshData:networkJson requestID:requestID]; } afterTimeInSeconds:5];
                                             }
                                         }];
                                     }
                                 }];
}

- (void)refreshData:(SkyscannerNetworking *)networkJson requestID:(NSString *)requestID {
    [networkJson pollPricingRequestWithRequestID:requestID
                                      completion:^(NSDictionary *json, NSError *error) {
                                          NSLog(@"  Inside refreshData:");
                                          NSLog(@"  requestID == %@", requestID);
                                          if (json != nil) {
                                              NSLog(@"  json != nil");
                                              SkyscannerRequest *request = [SkyscannerParser parseTripListJSON:json];
                                              self.itineraries = request.itineraries;
                                              [self.view reloadData];
                                              NSLog(@"  request.status == %@", request.status);
                                              if (![request.status isEqualToString: @"UpdatesComplete"]) {
                                                  NSLog(@"  running timer");
                                                  [HelperClass runBlock:^{
                                                      [self refreshData:networkJson requestID:requestID];
                                                  } afterTimeInSeconds:5.0f];
                                              }
                                          } else {
                                              NSLog(@"  json == nil, running timer");
                                              [HelperClass runBlock:^{
                                                  [self refreshData:networkJson requestID:requestID];
                                              } afterTimeInSeconds:5.0f];
                                          }
                                      }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.itineraries.count == 0) {
        return 5;
    }
    return self.itineraries.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.backgroundColor = [UIColor colorWithWhite:.90f alpha:1];
    NSString *headerString = [NSString stringWithFormat:@"%i results shown sorted by Price", self.itineraries.count];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:headerString];
    [attributedString addAttributes:@{
                                      NSFontAttributeName:[UIFont boldSystemFontOfSize:13]
                                      }
                              range:[headerString rangeOfString:@"Price"]];
    headerLabel.font = [UIFont systemFontOfSize:12.f];
    headerLabel.textColor = [UIColor grayColor];
    headerLabel.attributedText = attributedString;
    headerLabel.textAlignment = NSTextAlignmentCenter;
    return headerLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.itineraries.count == 0 ) {
        SkyShimmerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SkyShimmer" forIndexPath:indexPath];
        return cell;
    }
    TwoPlaneFlightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TwoPlaneFlight" forIndexPath:indexPath];
    
    SkyscannerItinerary *itinerary = [self.itineraries objectAtIndex:indexPath.row];
    
    NSString *outboundOriginStationCode = itinerary.outboundLeg.originStation.code;
    NSString *outboundDestinationStationCode = itinerary.outboundLeg.destinationStation.code;
    NSString *outboundCarrierName = itinerary.outboundLeg.carriers.firstObject.carrierName;
    
    NSString *inboundOriginStationCode = itinerary.inboundLeg.originStation.code;
    NSString *inboundDestinationStationCode = itinerary.inboundLeg.destinationStation.code;
    NSString *inboundCarrierName = itinerary.inboundLeg.carriers.firstObject.carrierName;
    
    NSString *outboundNumStops;
    if (itinerary.outboundLeg.stops.count == 0) {
        outboundNumStops = @"Non-stop";
    } else if (itinerary.outboundLeg.stops.count == 1) {
        outboundNumStops = @"1 stop";
    } else {
        outboundNumStops = [NSString stringWithFormat:@"%i stops", itinerary.outboundLeg.stops.count];
    }
    NSString *inboundNumStops;
    if (itinerary.inboundLeg.stops.count == 0) {
        inboundNumStops = @"Non-stop";
    } else if (itinerary.inboundLeg.stops.count == 1){
        inboundNumStops = @"1 stop";
    } else {
        inboundNumStops = [NSString stringWithFormat:@"%i stops", itinerary.inboundLeg.stops.count];
    }
    
    NSInteger outboundDurationInMinutes = itinerary.outboundLeg.duration.integerValue;
    NSInteger days = outboundDurationInMinutes / (1440);
    NSInteger hours = (outboundDurationInMinutes - (days * 1440)) / 60;
    NSInteger minutes = outboundDurationInMinutes - ( (days * 1440) + (hours * 60) );
    
    NSString *outboundFlightDuration;
    if (days == 0) {
        outboundFlightDuration = [NSString stringWithFormat:@"%ih %im", hours, minutes];
    } else {
        outboundFlightDuration = [NSString stringWithFormat:@"%id %ih %i", days, hours, minutes];
    }
    
    NSInteger inboundDurationInMinutes = itinerary.inboundLeg.duration.integerValue;
    days = inboundDurationInMinutes / (1440);
    hours = (inboundDurationInMinutes - (days * 1440)) / 60;
    minutes = inboundDurationInMinutes - ( (days * 1440) + (hours * 60) );
    
    NSString *inboundFlightDuration;
    if (days == 0) {
        inboundFlightDuration = [NSString stringWithFormat:@"%ih %im", hours, minutes];
    } else {
        inboundFlightDuration = [NSString stringWithFormat:@"%id %ih %im", days, hours, minutes];
    }
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"h:mm a"];
    
    NSString *first_departureTime = [formatter stringFromDate:itinerary.outboundLeg.timeDeparture];
    NSString *first_arrivalTime = [formatter stringFromDate:itinerary.outboundLeg.timeArrival];
    NSString *first_travelTime = [NSString stringWithFormat:@"%@ - %@", first_departureTime, first_arrivalTime];
    NSMutableAttributedString *first_attributedTravelTime =
    [HelperClass addAttributeToAllOccurrences:first_travelTime
                                       target:@"[AP]M"
                                       option:NSRegularExpressionSearch
                               withAttributes:@{
                                                NSFontAttributeName:[UIFont systemFontOfSize:10.f]
                                                }];
    
    NSString *second_departureTime = [formatter stringFromDate:itinerary.inboundLeg.timeDeparture];
    NSString *second_arrivalTime = [formatter stringFromDate:itinerary.inboundLeg.timeArrival];
    NSString *second_travelTime = [NSString stringWithFormat:@"%@ - %@", second_departureTime, second_arrivalTime];
    NSMutableAttributedString *second_attributedTravelTime =
    [HelperClass addAttributeToAllOccurrences:second_travelTime
                                       target:@"[AP]M"
                                       option:NSRegularExpressionSearch
                               withAttributes:@{
                                                NSFontAttributeName:[UIFont systemFontOfSize:10.f]
                                                }];
    
    [cell.first_ImageIcon setImageWithURL:[NSURL URLWithString:itinerary.outboundLeg.carriers.firstObject.carrierImageURL]];
    cell.first_TravelTime.attributedText = first_attributedTravelTime;
    cell.first_Destination.text = [NSString stringWithFormat:@"%@ - %@, %@", outboundOriginStationCode, outboundDestinationStationCode, outboundCarrierName];
    cell.first_NumOfStops.text = outboundNumStops;
    cell.first_TimeEstimate.text = outboundFlightDuration;
    
    [cell.second_ImageIcon setImageWithURL:[NSURL URLWithString:itinerary.inboundLeg.carriers.firstObject.carrierImageURL]];
    cell.second_TravelTime.attributedText = second_attributedTravelTime;
    cell.second_Destination.text = [NSString stringWithFormat:@"%@ - %@, %@", inboundOriginStationCode, inboundDestinationStationCode, inboundCarrierName];
    cell.second_NumOfStops.text = inboundNumStops;
    cell.second_TimeEstimate.text = inboundFlightDuration;
    
    cell.cost.text = [NSString stringWithFormat:@"$%.2f", [itinerary.pricingOptions.firstObject.price floatValue]];
    cell.flightProvider.text = [NSString stringWithFormat:@"via %@",itinerary.pricingOptions.firstObject.agents.firstObject.agentName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.itineraries) {
        return;
    }
    SkyscannerItinerary *itinerary = [self.itineraries objectAtIndex:indexPath.row];
    
    TripDetailsTableViewController *viewController = [[TripDetailsTableViewController alloc] init];
    viewController.requestID = self.requestID;
    viewController.inboundLeg = itinerary.inboundLeg;
    viewController.outboundLeg = itinerary.outboundLeg;
    [self.navigationController pushViewController:viewController animated:YES];
    
}

@end
