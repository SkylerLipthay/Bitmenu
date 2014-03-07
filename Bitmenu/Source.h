//
//  Source.h
//  Bitmenu
//
//  Created by Skyler Lipthay on 3/7/14.
//  Copyright (c) 2014 Skyler Lipthay. All rights reserved.
//

@protocol Source
- (NSDecimalNumber *)buyPriceWithCurrencyCode:(NSString *)currencyCode;
@end
