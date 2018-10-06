//
//  TreeNodeView.m
//  BSTDemo
//
//  Created by Andy Lee on 10/4/18.
//  Copyright © 2018 Andy Lee. All rights reserved.
//

#import "TreeNodeView.h"
#import "BSTView.h"

@implementation TreeNodeView

- (TreeNodeView *)minDescendant {
	TreeNodeView *result = self;
	while (result.left) {
		result = result.left;
	}
	return result;
}

- (TreeNodeView *)maxDescendant {
	TreeNodeView *result = self;
	while (result.right) {
		result = result.right;
	}
	return result;
}

#pragma mark - NSResponder methods

- (void)mouseEntered:(NSEvent *)event {
	[self.owningView mouseEnteredTreeNodeView:self];
}

- (void)mouseExited:(NSEvent *)event {
	[self.owningView mouseExitedTreeNodeView:self];
}

- (void)mouseUp:(NSEvent *)event {
	NSPoint mousePoint = [self convertPoint:event.locationInWindow fromView:nil];
	if (NSPointInRect(mousePoint, self.bounds)) {
		[self.owningView mouseClickedTreeNodeView:self];
	} else {
		[super mouseUp:event];
	}
}

@end
