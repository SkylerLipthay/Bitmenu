//
//  Coinbase.m
//  Bitmenu
//
//  Created by Skyler Lipthay on 3/7/14.
//  Copyright (c) 2014 Skyler Lipthay. All rights reserved.
//

#import "Coinbase.h"

NSString * const kAPIURL = @"https://coinbase.com/api/v1";

@interface Coinbase()
+ (NSURL *)URLWithPath:(NSString *)path;
@end

@implementation Coinbase

- (NSDecimalNumber *)buyPriceWithCurrencyCode:(NSString *)currencyCode {
  NSURL *URL = [self.class URLWithPath:[NSString stringWithFormat:@"prices/buy?currency=%@", currencyCode]];
  NSData *data = [NSData dataWithContentsOfURL:URL];
  if (data == nil) {
    return nil;
  }

  NSError *error;
  NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
  if (error != nil) {
    return nil;
  }

  return [NSDecimalNumber decimalNumberWithString:[result objectForKey:@"amount"]];
}

+ (NSURL *)URLWithPath:(NSString *)path {
  return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kAPIURL, path]];
}

@end
