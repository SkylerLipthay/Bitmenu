//
//  AppDelegate.h
//  Bitmenu
//
//  Created by Skyler Lipthay on 3/7/14.
//  Copyright (c) 2014 Skyler Lipthay. All rights reserved.
//

@interface AppDelegate : NSObject <NSApplicationDelegate> {
 @private
  NSStatusItem *_statusItem;
}

@property (assign) IBOutlet NSMenu *statusMenu;
@property (assign) IBOutlet NSMenuItem *launchOnStartupItem;
@property (assign) IBOutlet NSMenuItem *currencyItem;
@property (assign) IBOutlet NSMenuItem *sourceItem;

- (IBAction)handleCurrency:(id)sender;
- (IBAction)handleSource:(id)sender;
- (IBAction)handleQuit:(id)sender;
- (IBAction)handleShouldLaunchOnStartup:(id)sender;

@end
