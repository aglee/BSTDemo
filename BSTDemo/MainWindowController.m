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
	[self.mainView resetWithValues:@[ @1, @2, @3, @4, @5, @6, @7, @8, @9, @10, @11, @12 ]];
}

#pragma mark - <NSWindowDelegate> methods

- (void)windowDidLoad {
	[super windowDidLoad];

	[self resetNodes:nil];
}

@end
