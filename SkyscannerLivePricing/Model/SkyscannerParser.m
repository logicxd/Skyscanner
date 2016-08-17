//
//  TripDetailsParser.m
//  SkyscannerTripDetails
//
//  Created by Aung Moe on 7/4/16.
//  Copyright © 2016 Alaric Gonzales. All rights reserved.
//

#import "RPJSONMapper.h"
#import "SkyscannerParser.h"
#import "SkyscannerFactory.h"
#import "SkyscannerRequest.h"
#import "SkyscannerQuery.h"
#import "SkyscannerPricingOption.h"
#import "SkyscannerBookingDetailsLink.h"
#import "SkyscannerSegment.h"
#import "SkyscannerItinerary.h"
#import "SkyscannerLeg.h"
#import "SkyscannerPlace.h"
#import "SkyscannerCurrency.h"
#import "SkyscannerAgent.h"
#import "TripDetailsQuery.h"
#import "SkyscannerBookingOption.h"
#import "SkyscannerBookingItem.h"

@implementation SkyscannerParser

// -----------------------------------------------------------------------------------------------------
#pragma mark - Parse Trip Details
// -----------------------------------------------------------------------------------------------------

+ (TripDetailsRequest *)parseTripDetailsJSON:(NSDictionary *)json {
    TripDetailsRequest *request = [[TripDetailsRequest alloc] init];
    
    TripDetailsQuery *query = [self queryTripDetailsWithJson:json[@"Query"]];
    NSArray *segments = [self segmentsWithJson:json[@"Segments"]];
    NSArray *places = [self placesWithJson:json[@"Places"]];
    NSArray *carriers = [self carriersWithJson:json[@"Carriers"]];
    NSArray *bookingOptions = [self bookingOptionsWithJSON:json[@"BookingOptions"]];
    
    request.query = query;
    request.segments = segments;
    request.places = places;
    request.carriers = carriers;
    request.bookingOptions = bookingOptions;

    return request;
}

+ (TripDetailsQuery *)queryTripDetailsWithJson:(NSDictionary *)queryJson {
    TripDetailsQuery *query = [[TripDetailsQuery alloc] init];
    [[RPJSONMapper sharedInstance] mapJSONValuesFrom:queryJson
                                          toInstance:query
                                        usingMapping:@{
                                                       @"Country" : @"country",
                                                       @"Currency" : @"currency",
                                                       @"Locale" : @"locale",
                                                       @"Adults" : @"adults",
                                                       @"Children" : @"children",
                                                       @"Infants" : @"infants",
                                                       @"OutboundDate" : @"outboundDate",
                                                       @"InboundDate" : @"inboundDate",
                                                       @"LocationSchema" : @"locationSchema",
                                                       @"CabinClass" : @"cabinClass",
                                                       }];
    
    NSString *stupidTripDetailsOriginPlaceId = [queryJson objectForKey:@"OriginPlace"];
    NSString *stupidTripDetailsDestinationPlaceId = [queryJson objectForKey:@"DestinationPlace"];
    
    if (queryJson[@"GroupPricing"]) {
        query.groupPricing = [[queryJson objectForKey:@"GroupPricing"] boolValue];
    }
    if (stupidTripDetailsOriginPlaceId.integerValue) {
        query.originPlace = [[SkyscannerFactory sharedFactory] skyscannerPlaceWithId:@(stupidTripDetailsOriginPlaceId.integerValue)];
    }
    if (stupidTripDetailsDestinationPlaceId.integerValue) {
        query.destinationPlace = [[SkyscannerFactory sharedFactory] skyscannerPlaceWithId:@(stupidTripDetailsDestinationPlaceId.integerValue)];
    }
    return query;
}

+ (NSArray<SkyscannerBookingOption *> *)bookingOptionsWithJSON:(NSArray <NSDictionary *> *)bookingOptionsJSON {
    NSMutableArray<SkyscannerBookingOption *> *bookingOptions = [[NSMutableArray alloc] init];
    for (NSDictionary *bookingOptionsDictionary in bookingOptionsJSON) {
        SkyscannerBookingOption *bookingOption = [SkyscannerBookingOption new];
        bookingOption.bookingItems = [self bookingItemsWithJson:bookingOptionsDictionary[@"BookingItems"]];
        [bookingOptions addObject:bookingOption];
    }
    return bookingOptions; // Objective: Return bookingOptions, the array that contains the bookingItems array.
}

+ (NSArray<SkyscannerBookingItem *> *)bookingItemsWithJson:(NSArray<NSDictionary *> *)bookingItemsJson {
    NSMutableArray<SkyscannerBookingItem *> *bookingItems = [NSMutableArray array];
    for (NSDictionary *bookingItemDictionary in bookingItemsJson) {
        SkyscannerBookingItem *bookingItem = [SkyscannerBookingItem new];
        [[RPJSONMapper sharedInstance] mapJSONValuesFrom:bookingItemDictionary
                                              toInstance:bookingItem
                                            usingMapping:@{
                                                           @"Status" : @"status",
                                                           @"Price" : @"price"
                                                           }];

        bookingItem.agent = [[SkyscannerFactory sharedFactory] skyscannerAgentWithId:bookingItemDictionary[@"AgentID"]];
        bookingItem.bookingOptionLink = [[NSURL alloc] initWithString:bookingItemDictionary[@"Deeplink"]];
        bookingItem.segments = [self segmentsWithIds:bookingItemDictionary[@"SegmentIds"]];
        [bookingItems addObject:bookingItem];
    }
    return bookingItems;
}
// -----------------------------------------------------------------------------------------------------
#pragma mark - Parse Trip List
// -----------------------------------------------------------------------------------------------------

+ (SkyscannerRequest *)parseTripListJSON:(NSDictionary *)json {
    SkyscannerRequest *request = [[SkyscannerRequest alloc] init];
    [[RPJSONMapper sharedInstance] mapJSONValuesFrom:json
                                          toInstance:request
                                        usingMapping:@{
                                                       @"SessionKey" : @"sessionKey",
                                                       @"Status" : @"status",
                                                       }];
    SkyscannerQuery *query = [[SkyscannerQuery alloc] init];
    NSArray *itineraries = [self itinerariesWithJson:json[@"Itineraries"]];
    NSArray *legs = [self legsWithJson:json[@"Legs"]];
    NSArray *segments = [self segmentsWithJson:json[@"Segments"]];
    NSArray *carriers = [self carriersWithJson:json[@"Carriers"]];
    NSArray *agents = [self agentsWithJson:json[@"Agents"]];
    NSArray *places = [self placesWithJson:json[@"Places"]];
    NSArray *currencies = [self currenciesWithJson:json[@"Currencies"]];
    
    request.query = query;
    request.itineraries = itineraries;
    request.legs = legs;
    request.segments = segments;
    request.carriers = carriers;
    request.agents = agents;
    request.places = places;
    request.currencies = currencies;
    
    return request;
}

+ (SkyscannerQuery *)queryWithJson:(NSDictionary *)queryJson {
    SkyscannerQuery *query = [[SkyscannerQuery alloc] init];
    [[RPJSONMapper sharedInstance] mapJSONValuesFrom:queryJson
                                          toInstance:query
                                        usingMapping:@{
                                                       @"Country" : @"country",
                                                       @"Currency" : @"currencyCode",
                                                       @"Locale" : @"locale",
                                                       @"Adults" : @"amountAdults",
                                                       @"Children" : @"amountChildren",
                                                       @"Infants" : @"amountInfants",
                                                       @"OutboundDate" : @"outboundDate",
                                                       @"InboundDate" : @"inboundDate",
                                                       @"LocationSchema" : @"locationSchema",
                                                       @"CabinClass" : @"cabinClass",
                                                       }];
    
    NSString *stupidSkyscannerOriginPlaceId = [queryJson objectForKey:@"OriginPlace"];
    NSString *stupidSkyscannerDestinationPlaceId = [queryJson objectForKey:@"DestinationPlace"];
    
    if (queryJson[@"GroupPricing"]) {
        query.groupPricing = [[queryJson objectForKey:@"GroupPricing"] boolValue];
    }
    if (stupidSkyscannerOriginPlaceId.integerValue) {
        query.originPlace = [[SkyscannerFactory sharedFactory] skyscannerPlaceWithId:@(stupidSkyscannerOriginPlaceId.integerValue)];
    }
    if (stupidSkyscannerDestinationPlaceId.integerValue) {
        query.destinationPlace = [[SkyscannerFactory sharedFactory] skyscannerPlaceWithId:@(stupidSkyscannerDestinationPlaceId.integerValue)];
    }
    return query;
}

+ (NSArray<SkyscannerItinerary *> *)itinerariesWithJson:(NSArray <NSDictionary *> *)itinerariesJson {
    NSMutableArray<SkyscannerItinerary *> *itineraries = [[NSMutableArray alloc] init];
    
    for (NSDictionary *itineraryJson in itinerariesJson) {
        SkyscannerLeg *outboundLeg = [[SkyscannerFactory sharedFactory] skyscannerLegWithId:itineraryJson[@"OutboundLegId"]];
        SkyscannerLeg *inboundLeg = [[SkyscannerFactory sharedFactory] skyscannerLegWithId:itineraryJson[@"InboundLegId"]];
        SkyscannerItinerary *itinerary = [[SkyscannerItinerary alloc] init];
        
        itinerary.outboundLeg = outboundLeg;
        itinerary.inboundLeg = inboundLeg;
        itinerary.pricingOptions = [self pricingOptionsWithJson:itineraryJson[@"PricingOptions"]];
        itinerary.bookingDetailsLinks = [self bookingDetailsWithJson:itineraryJson[@"BookingDetailsLink"]];
        
        [itineraries addObject:itinerary];
    }
    return itineraries;
}

+ (NSArray <SkyscannerPricingOption *> *)pricingOptionsWithJson:(NSArray<NSDictionary *> *)pricingOptionsJson {
    NSMutableArray<SkyscannerPricingOption *> *pricingOptions = [[NSMutableArray alloc] init];
    
    for (NSDictionary *pricingDictionary in pricingOptionsJson) {
        SkyscannerPricingOption *pricingOption = [[SkyscannerPricingOption alloc] init];
        [[RPJSONMapper sharedInstance] mapJSONValuesFrom:pricingDictionary toInstance:pricingOption usingMapping:@{
                                                                                                                   @"QuoteAgeInMinutes" : @"quoteAgeInMinutes",
                                                                                                                   @"Price" : @"price",
                                                                                                                   @"DeeplinkUrl" : @"deeplinkURL"
                                                                                                                   
                                                                                                                   }];
        pricingOption.agents = [self agentsWithIds:pricingDictionary[@"Agents"]];
        [pricingOptions addObject:pricingOption];
    }
    return pricingOptions;
}

+ (NSArray <SkyscannerBookingDetailsLink *> *)bookingDetailsWithJson:(NSArray<NSDictionary *> *)bookingDetailsJson {
    NSMutableArray<SkyscannerBookingDetailsLink *> *bookingDetailsLink = [[NSMutableArray alloc] init];
    
    for (NSDictionary *bookingDictionary in bookingDetailsJson) {
        SkyscannerBookingDetailsLink *bookingDetail = [[SkyscannerBookingDetailsLink alloc] init];
        [[RPJSONMapper sharedInstance] mapJSONValuesFrom:bookingDictionary toInstance:bookingDetail usingMapping:@{
                                                                                                                   @"Uri" : @"uri",
                                                                                                                   @"Body" : @"body",
                                                                                                                   @"Method" : @"method"
                                                                                                                   }];
    }
    return bookingDetailsLink;
}

+ (NSArray<SkyscannerLeg *> *)legsWithJson:(NSArray *)legsJson {
    NSMutableArray<SkyscannerLeg *> *legs = [NSMutableArray arrayWithCapacity:legsJson.count];
    
    for (NSDictionary *legDictionary in legsJson) {
        SkyscannerLeg *leg = [self legWithJson:legDictionary];
        [legs addObject:leg];
    }
    return legs;
}

+ (SkyscannerLeg *)legWithJson:(NSDictionary *)legJson {
    SkyscannerLeg *leg = [[SkyscannerFactory sharedFactory] skyscannerLegWithId:legJson[@"Id"]];
    [[RPJSONMapper sharedInstance] mapJSONValuesFrom:legJson
                                          toInstance:leg
                                        usingMapping:@{
                                                       @"Id" : @"legID",
                                                       @"Duration" : @"duration",
                                                       @"JourneyMode" : @"journeyMode",
                                                       @"Directionality" : @"directionality"
                                                       }];
    leg.stops = [self placesWithIds:legJson[@"Stops"]];
    leg.segments = [self segmentsWithIds:legJson[@"SegmentIds"]];
    leg.operatingCarriers = [self carriersWithIds:legJson[@"OperatingCarrier"]];
    leg.carriers = [self carriersWithIds:legJson[@"Carriers"]];
    if (legJson[@"OriginStation"]) {
        leg.originStation = [[SkyscannerFactory sharedFactory] skyscannerPlaceWithId:legJson[@"OriginStation"]];
    }
    if (legJson[@"DestinationStation"]) {
        leg.destinationStation = [[SkyscannerFactory sharedFactory] skyscannerPlaceWithId:legJson[@"DestinationStation"]];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    leg.timeDeparture = [formatter dateFromString:legJson[@"Departure"]];
    leg.timeArrival = [formatter dateFromString:legJson[@"Arrival"]];
        
    return leg;
}

+ (NSArray<SkyscannerSegment *> * _Nullable)segmentsWithIds:(NSArray *)segmentIds {
    NSMutableArray *segments = [NSMutableArray array];
    for (NSNumber *eachSegmentId in segmentIds) {
        SkyscannerSegment *eachSegment = [[SkyscannerFactory sharedFactory] skyscannerSegmentWithId:eachSegmentId];
        [segments addObject:eachSegment];
    }
    
    return segments;
}

+ (NSMutableArray<SkyscannerSegment *> *)segmentsWithJson:(NSArray *)segmentsJson {
    NSMutableArray *segments = [[NSMutableArray alloc] init];
    for (NSDictionary *segmentJson in segmentsJson) {
        SkyscannerSegment *segment = [[SkyscannerFactory sharedFactory] skyscannerSegmentWithId:segmentJson[@"Id"]];
        [[RPJSONMapper sharedInstance] mapJSONValuesFrom:segmentJson toInstance:segment
                                            usingMapping:@{
                                                           @"Id" : @"segmentID",
                                                           @"Duration" : @"duration",
                                                           @"FlightNumber" : @"flightNumber",
                                                           @"JourneyMode" : @"journeyMode",
                                                           @"Directionality" : @"directionality"
                                                           }];
        if (segmentJson[@"OriginStation"]) {
            segment.originStation = [[SkyscannerFactory sharedFactory] skyscannerPlaceWithId:segmentJson[@"OriginStation"]];
        }
        if (segmentJson[@"DestinationStation"]) {
            segment.destinationStation = [[SkyscannerFactory sharedFactory] skyscannerPlaceWithId:segmentJson[@"DestinationStation"]];
        }
        segment.carrier = [[SkyscannerFactory sharedFactory] skyscannerCarrierWithId:segmentJson[@"Carrier"]];
        segment.operatingCarrier = [[SkyscannerFactory sharedFactory] skyscannerCarrierWithId:segmentJson[@"OperatingCarrier"]];
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        segment.timeDeparture = [formatter dateFromString:segmentJson[@"DepartureDateTime"]];
        segment.timeArrival = [formatter dateFromString:segmentJson[@"ArrivalDateTime"]];
        
        [segments addObject:segment];
    }
    
    return segments;
}

+ (NSArray <SkyscannerCarrier *> *)carriersWithIds:(NSArray *)carrierIds {
    NSMutableArray *carriers = [NSMutableArray array];
    for (NSNumber *eachCarrierId in carrierIds) {
        SkyscannerCarrier *eachCarrier = [[SkyscannerFactory sharedFactory] skyscannerCarrierWithId:eachCarrierId];
        [carriers addObject:eachCarrier];
    }
    return carriers;
}

+ (NSArray<SkyscannerCarrier *> *)carriersWithJson:(NSArray <NSDictionary *> *)carriersJson {
    NSMutableArray<SkyscannerCarrier *> *mutableArrayOfCarriers = [[NSMutableArray alloc] init];
    for (NSDictionary *eachDictionary in carriersJson) {
        SkyscannerCarrier *eachCarrier = [[SkyscannerFactory sharedFactory] skyscannerCarrierWithId:eachDictionary[@"Id"]];
        [[RPJSONMapper sharedInstance] mapJSONValuesFrom:eachDictionary toInstance:eachCarrier
                                            usingMapping:@{
                                                           @"Id" : @"carrierID",
                                                           @"Code" : @"carrierCode",
                                                           @"Name" : @"carrierName",
                                                           @"ImageUrl" : @"carrierImageURL",
                                                           @"DisplayCode" : @"displayCode"
                                                           }];
        [mutableArrayOfCarriers addObject:eachCarrier];
    }
    return mutableArrayOfCarriers;
}

+ (NSArray<SkyscannerAgent *> *)agentsWithIds:(NSArray *)agentIDs {
    NSMutableArray *agents = [NSMutableArray array];
    for (NSNumber *eachAgentId in agentIDs) {
        SkyscannerAgent *eachAgent = [[SkyscannerFactory sharedFactory] skyscannerAgentWithId:eachAgentId];
        [agents addObject:eachAgent];
    }
    return agents;
}

+ (NSArray<SkyscannerPlace *> *)placesWithIds:(NSArray *)placeIds {
    NSMutableArray *places = [NSMutableArray array];
    for (NSNumber *eachPlaceId in placeIds) {
        if (eachPlaceId){
            SkyscannerPlace *eachPlace = [[SkyscannerFactory sharedFactory] skyscannerPlaceWithId:eachPlaceId];
            [places addObject:eachPlace];
        }
    }
    
    return places;
}

+ (NSArray<SkyscannerPlace *> *)placesWithJson:(NSArray <NSDictionary *> *)placesJson {
    NSMutableArray<SkyscannerPlace *> *mutableArrayOfPlaces = [[NSMutableArray alloc] init];
    for (NSDictionary *placeJson in placesJson) {
        if (placeJson[@"Id"]) {
            SkyscannerPlace *place = [[SkyscannerFactory sharedFactory] skyscannerPlaceWithId:placeJson[@"Id"]];
            [[RPJSONMapper sharedInstance] mapJSONValuesFrom:placeJson toInstance:place
                                                usingMapping:@{
                                                               @"Id" : @"placeID",
                                                               @"Code" : @"code",
                                                               @"Type" : @"type",
                                                               @"Name" : @"name"
                                                               }];
            if (placeJson[@"ParentId"]) {
                place.parent = [[SkyscannerFactory sharedFactory] skyscannerPlaceWithId:placeJson[@"ParentId"]];
            }
            
            [mutableArrayOfPlaces addObject:place];
        }
    }
    return mutableArrayOfPlaces;
}

+ (NSArray<SkyscannerCurrency *> *)currenciesWithJson:(NSArray <NSDictionary *> *)currenciesJson {
    NSMutableArray<SkyscannerCurrency *> *mutableArrayOfCurrencies = [[NSMutableArray alloc] init];
    for (NSDictionary *eachDictionary in currenciesJson) {
        SkyscannerCurrency *eachCurrency = [[SkyscannerCurrency alloc] init];
        [[RPJSONMapper sharedInstance] mapJSONValuesFrom:eachDictionary toInstance:eachCurrency
                                            usingMapping:@{
                                                           @"Code" : @"currencyCode",
                                                           @"Symbol" : @"currencySymbol",
                                                           @"ThousandsSeparator" : @"currencyThousandsSeparator",
                                                           @"DecimalSeparator" : @"currencyDecimalSeparator",
                                                           @"RoundingCoefficient" : @"roundingCoefficient",
                                                           @"DecimalDigits" : @"decimalDigits"
                                                           }];
        eachCurrency.symbolOnLeft = [eachDictionary[@"SymbolOnLeft"] boolValue];
        eachCurrency.spaceBetweenAmountAndSymbol = [eachDictionary[@"SpaceBetweenAmountAndSymbol"] boolValue];
        [mutableArrayOfCurrencies addObject:eachCurrency];
    }
    return mutableArrayOfCurrencies;
}

+ (NSArray<SkyscannerAgent *> *)agentsWithJson:(NSArray <NSDictionary *> *)agentsJson {
    NSMutableArray<SkyscannerAgent *> *mutableArrayOfAgents = [[NSMutableArray alloc] init];
    for (NSDictionary *eachDictionary in agentsJson) {
        SkyscannerAgent *eachAgent = [[SkyscannerFactory sharedFactory] skyscannerAgentWithId:eachDictionary[@"Id"]];
        [[RPJSONMapper sharedInstance] mapJSONValuesFrom:eachDictionary toInstance:eachAgent
                                            usingMapping:@{
                                                           @"Id" : @"agentID",
                                                           @"Name" : @"agentName",
                                                           @"ImageUrl" : @"agentImageURL",
                                                           @"Status" : @"status",
                                                           @"Type" : @"agentType"
                                                           }];
        eachAgent.optimisedForMobile = [eachDictionary[@"OptimisedForMobile"] boolValue];
        [mutableArrayOfAgents addObject:eachAgent];
    }
    return mutableArrayOfAgents;
}

@end
