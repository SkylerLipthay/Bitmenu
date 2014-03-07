//
//  Coinbase.h
//  Bitmenu
//
//  Created by Skyler Lipthay on 3/7/14.
//  Copyright (c) 2014 Skyler Lipthay. All rights reserved.
//

#import "Source.h"

@interface Coinbase : NSObject <Source>

- (NSDecimalNumber *)buyPriceWithCurrencyCode:(NSString *)currencyCode;

@end
