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

@property NSInteger numberOfNodes;
@property IBOutlet BSTView *mainView;

// Number-of-nodes sheet.
@property IBOutlet NSWindow *numberOfNodesSheetWindow;

@end


@implementation MainWindowController

#pragma mark - Action methods

- (IBAction)resetNodes:(id)sender {
	[self.mainView resetWithPositiveIntegersThrough:self.numberOfNodes];
}

- (IBAction)makeRandomTree:(id)sender {
	[self resetNodes:nil];
	[self finishTreeRandomly:nil];
}

- (IBAction)finishTreeRandomly:(id)sender {
	[self.mainView finishTreeRandomly];
}

#pragma mark - Action methods - number-of-nodes sheet

/// Displays the sheet.
- (IBAction)changeNumberOfNodes:(id)sender {
	[self.window beginSheet:self.numberOfNodesSheetWindow completionHandler:^(NSModalResponse returnCode) {
		if (returnCode != NSModalResponseOK) {
			return;
		}
		[self resetNodes:nil];
	}];
}

/// OK's the sheet (tries to).
- (IBAction)okNumberOfNodesSheet:(id)sender {
	// Try to make the sheet the first responder.  This will fail if the text
	// field is being edited and fails validation, in which case we do not want
	// to dismiss the sheet.
	//TODO: Actually right now I've made the text field non-editable; had weird
	// errors around field validation.  Using a slider now, which not great UX
	// but avoids field validation issues, which I can come back to later.
	if ([self.numberOfNodesSheetWindow makeFirstResponder:self.numberOfNodesSheetWindow]) {
		[self.window endSheet:self.numberOfNodesSheetWindow returnCode:NSModalResponseOK];
	}
}

/// Cancels the sheet.
- (IBAction)cancelNumberOfNodesSheet:(id)sender {
	[self.window endSheet:self.numberOfNodesSheetWindow returnCode:NSModalResponseCancel];
}

#pragma mark - <NSWindowDelegate> methods

- (void)windowDidLoad {
	[super windowDidLoad];

	self.numberOfNodes = 12;
	[self resetNodes:nil];
}

@end
