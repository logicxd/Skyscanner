//
//  SkyScannerNetworking.m
//  SkyScannerClone
//
//  Created by Aung Moe on 6/28/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import "SkyscannerNetworking.h"

static const NSString *apiKey = @"pl448015395202178988289540667914";

@interface SkyscannerNetworking()
- (void)initializeLocalVariables;
@end

@implementation SkyscannerNetworking

+ (SkyscannerNetworking *)sharedNetworking {
    static SkyscannerNetworking *sharedClient = nil;
    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        [config setURLCache:nil];
        sharedClient = [[SkyscannerNetworking alloc] initWithSessionConfiguration:config];
        [sharedClient initializeLocalVariables];
        
    });
    return sharedClient;
}

- (void)initializeLocalVariables {
    self.country = @"us";
    self.currency = @"usd";
    self.locale = @"en-us";
    self.adults = @1;
}

- (void)postSessionWithOriginPlace:(NSString *)originPlace destinationPlace:(NSString *)destinationPlace outboundDate:(NSString *)outboundDate inboundDate:(NSString *)inboundDate completion:(void (^)(id response, NSError *error))completion {
    self.originPlace = originPlace;
    self.destinationPlace = destinationPlace;
    self.outboundDate = outboundDate;
    self.inboundDate = inboundDate;
    
    [self POST:@"http://partners.api.skyscanner.net/apiservices/pricing/v1.0"
    parameters:@{
                 @"apiKey" : apiKey,
                 @"country" : self.country,
                 @"currency" : self.currency,
                 @"locale" : self.locale,
                 @"originplace" : self.originPlace,
                 @"destinationplace" : self.destinationPlace,
                 @"outbounddate" : self.outboundDate,
                 @"inbounddate" : self.inboundDate,
                 @"adults" : self.adults
                 }
      progress:nil
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           id responseHTTP = task.response;
           NSString *responseURL= [responseHTTP allHeaderFields][@"Location"];
           NSString *responseID = [[responseURL componentsSeparatedByString:@"/"] lastObject];
           completion(responseID, nil);
       }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           NSLog(@"postAddress FAIL!");
           completion(nil,error);
       }];
}

- (void)pollPricingRequestWithRequestID:(NSString *)requestID completion:(void (^)(NSDictionary *json, NSError *error))completion {
    [self GET:[NSString stringWithFormat:@"http://partners.api.skyscanner.net/apiservices/pricing/us/v1.0/%@", requestID]
   parameters:@{
                @"apiKey" : apiKey
                }
     progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          completion(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          completion(nil, error);
      }];
}

- (void)putRequestForBookingDetailsWithSessionID:(NSString *)sessionID outboundLegID:(NSString *)outboundLegID inboundLegID:(NSString *)inboundLegID completion:(void (^)(NSString *itineraryKey, NSError *error))completion {
    
    [self PUT:[NSString stringWithFormat:@"http://partners.api.skyscanner.net/apiservices/pricing/v1.0/%@/booking?apiKey=%@", sessionID, apiKey]
   parameters:@{
                @"apiKey" : apiKey,
                @"outboundlegid" : outboundLegID,
                @"inboundlegid" : inboundLegID
                }
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          id responseHTTP = task.response;
          NSString *responseURL= [responseHTTP allHeaderFields][@"Location"];
          NSString *itineraryKey = [[responseURL componentsSeparatedByString:@"/"] lastObject];
          completion(itineraryKey, nil);
          NSLog(@"SUCCESS PUT");
      }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          completion(nil, error);
          NSLog(@"FAIL PUT");
      }];
}

- (void)getRequestForBookingDetailsWithSessionKey:(NSString *)sessionKey itineraryKey:(NSString *)itineraryKey completion:(void (^)(NSDictionary *JSON, NSError *error))completion {
    
    [self GET:[NSString stringWithFormat:@"http://partners.api.skyscanner.net/apiservices/pricing/v1.0/%@/booking/%@", sessionKey, itineraryKey]
   parameters:@{
                @"apiKey" : apiKey
                }
     progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          completion(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          completion(nil, error);
      }];
}

@end
