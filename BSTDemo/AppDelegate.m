//
//  AppDelegate.m
//  BSTDemo
//
//  Created by Andy Lee on 10/4/18.
//  Copyright © 2018 Andy Lee. All rights reserved.
//

#import "AppDelegate.h"
#import "MainWindowController.h"

@interface AppDelegate ()

@property MainWindowController *mainWC;

@end



@implementation AppDelegate



#pragma mark - <NSApplicationDelegate> methods

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	self.mainWC = [[MainWindowController alloc] initWithWindowNibName:@"MainWindowController"];
	[self.mainWC showWindow:nil];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}


@end
