//
//  MainWindowController.m
//  BSTDemo
//
//  Created by Andy Lee on 10/4/18.
//  Copyright © 2018 Andy Lee. All rights reserved.
//

#import "MainWindowController.h"
#import "BSTView.h"

@interface MainWindowController ()

@property IBOutlet BSTView *mainView;

@end


@implementation MainWindowController

#pragma mark - Action methods

- (IBAction)resetNodes:(id)sender {
	[self.mainView resetWithValues:@[ @100, @200, @300, @400, @500, @600, @700, @800, @900, @1000, @1100, @1200 ]];
}

#pragma mark - <NSWindowDelegate> methods

- (void)windowDidLoad {
	[super windowDidLoad];

	[self resetNodes:nil];
}

@end
