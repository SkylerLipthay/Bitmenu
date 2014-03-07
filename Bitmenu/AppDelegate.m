//
//  AppDelegate.m
//  Bitmenu
//
//  Created by Skyler Lipthay on 3/7/14.
//  Copyright (c) 2014 Skyler Lipthay. All rights reserved.
//

#import <IYLoginItem/NSBundle+LoginItem.h>

#import "AppDelegate.h"
#import "Source.h"

@interface AppDelegate()
+ (NSString *)currencyCode;
+ (void)setSource:(NSString *)source;
+ (void)setCurrencyCode:(NSString *)currencyCode;
+ (BOOL)shouldLaunchOnStartup;
+ (id<Source>)source;
+ (NSString *)sourceName;
+ (BOOL)toggleShouldLaunchOnStartup;
- (void)refreshStatus;
- (void)setStatusLoading;
- (void)setStatusWithValue:(NSDecimalNumber *)value;
- (void)updateShouldLaunchOnStartupMenuItem:(BOOL)state;
- (void)updateCurrencyCodeMenuItem:(NSString *)currencyCode;
- (void)updateSourceMenuItem:(NSString *)source;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
}

- (void)awakeFromNib{
  _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
  [_statusItem setMenu:self.statusMenu];
  [_statusItem setHighlightMode:YES];
  [self updateShouldLaunchOnStartupMenuItem:[self.class shouldLaunchOnStartup]];
  [self updateCurrencyCodeMenuItem:[self.class currencyCode]];
  [self updateSourceMenuItem:[self.class sourceName]];
  
  [_refreshTimer invalidate];
  _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:15.0
                                                   target:self
                                                 selector:@selector(refreshStatus)
                                                 userInfo:nil
                                                  repeats:YES];
}

- (IBAction)handleCurrency:(id)sender {
  [self.class setCurrencyCode:[sender title]];
  [self updateCurrencyCodeMenuItem:[sender title]];
  [self refreshStatus];
}

- (IBAction)handleSource:(id)sender {
  [self.class setSource:[sender title]];
  [self updateSourceMenuItem:[sender title]];
  [self refreshStatus];
}

- (IBAction)handleQuit:(id)sender {
  [[NSApplication sharedApplication] terminate:nil];
}

- (IBAction)handleShouldLaunchOnStartup:(id)sender {
  [self updateShouldLaunchOnStartupMenuItem:[self.class toggleShouldLaunchOnStartup]];
}

+ (NSString *)currencyCode {
  NSString *currencyCode = [[NSUserDefaults standardUserDefaults] stringForKey:@"currencyCode"];
  if (currencyCode == nil) {
    currencyCode = @"USD";
  }

  return currencyCode;
}

+ (void)setCurrencyCode:(NSString *)currencyCode {
  [[NSUserDefaults standardUserDefaults] setObject:currencyCode forKey:@"currencyCode"];
}

+ (void)setSource:(NSString *)source {
  [[NSUserDefaults standardUserDefaults] setObject:source forKey:@"source"];
}

+ (BOOL)shouldLaunchOnStartup {
  return [[NSUserDefaults standardUserDefaults] boolForKey:@"shouldLaunchOnStartup"];
}

+ (id<Source>)source {
  Class class = NSClassFromString([self sourceName]);
  if (class == nil) {
    return nil;
  }

  return [[class alloc] init];
}

+ (NSString *)sourceName {
  NSString *source = [[NSUserDefaults standardUserDefaults] stringForKey:@"source"];
  if (source == nil) {
    source = @"Coinbase";
  }

  return source;
}

+ (BOOL)toggleShouldLaunchOnStartup {
  BOOL launchOnStartup = ![[NSUserDefaults standardUserDefaults] boolForKey:@"shouldLaunchOnStartup"];
  [[NSUserDefaults standardUserDefaults] setBool:launchOnStartup forKey:@"shouldLaunchOnStartup"];
  [[NSUserDefaults standardUserDefaults] synchronize];

  if (launchOnStartup) {
    [[NSBundle mainBundle] addToLoginItems];
  } else {
    [[NSBundle mainBundle] removeFromLoginItems];
  }

  return launchOnStartup;
}

- (void)refreshStatus {
  [self setStatusLoading];

  id<Source> source = [self.class source];
  if (source == nil) {
    return;
  }

  dispatch_async(dispatch_get_main_queue(), ^{
    [self setStatusWithValue:[source buyPriceWithCurrencyCode:[self.class currencyCode]]];
  });
}

- (void)setStatusLoading {
  [self setStatusWithValue:[NSDecimalNumber decimalNumberWithString:@"0.00"]];
}

- (void)setStatusWithValue:(NSDecimalNumber *)value {
  if (value == nil) {
    return;
  }

  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
  [formatter setNumberStyle: NSNumberFormatterCurrencyStyle];
  [formatter setCurrencyCode:[self.class currencyCode]];
  NSString *title = [formatter stringFromNumber:value];

  [_statusItem setTitle:title];
}

- (void)updateShouldLaunchOnStartupMenuItem:(BOOL)state {
  [_launchOnStartupItem setState:state ? NSOnState : NSOffState];
}

- (void)updateCurrencyCodeMenuItem:(NSString *)currencyCode {
  for (NSMenuItem *item in [[self.currencyItem submenu] itemArray]) {
    if ([[item title] compare:currencyCode] != NSOrderedSame) {
      [item setState:NSOffState];
      continue;
    }

    [item setState:NSOnState];
  }
}

- (void)updateSourceMenuItem:(NSString *)source {
  for (NSMenuItem *item in [[self.sourceItem submenu] itemArray]) {
    if ([[item title] compare:source] != NSOrderedSame) {
      [item setState:NSOffState];
      continue;
    }

    [item setState:NSOnState];
  }
}

@end
