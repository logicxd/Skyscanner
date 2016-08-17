//
//  SkyScannerNetworking.h
//  SkyScannerClone
//
//  Created by Aung Moe on 6/28/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>

@interface SkyscannerNetworking : AFHTTPSessionManager

@property (copy, nonatomic) NSString *country;
@property (copy, nonatomic) NSString *currency;
@property (copy, nonatomic) NSString *locale;
@property (copy, nonatomic) NSString *originPlace;
@property (copy, nonatomic) NSString *destinationPlace;
@property (copy, nonatomic) NSString *outboundDate;
@property (copy, nonatomic) NSString *inboundDate;
@property (strong, nonatomic) NSNumber *adults;

+ (SkyscannerNetworking *)sharedNetworking;

- (void) postSessionWithOriginPlace:(NSString *)originPlace destinationPlace:(NSString *)destinationPlace outboundDate:(NSString *)outboundDate inboundDate:(NSString *)inboundDate completion:(void (^)(id response, NSError *error))completion;

- (void) pollPricingRequestWithRequestID:(NSString *)requestID completion:(void (^)(NSDictionary *json, NSError *error))completion;

- (void)putRequestForBookingDetailsWithSessionID:(NSString *)sessionID outboundLegID:(NSString *)outboundLegID inboundLegID:(NSString *)inboundLegID completion:(void (^)(NSString *itineraryKey, NSError *error))completion;

- (void)getRequestForBookingDetailsWithSessionKey:(NSString *)sessionKey itineraryKey:(NSString *)itineraryKey completion:(void (^)(NSDictionary *JSON, NSError *error))completion;
f\
@end
