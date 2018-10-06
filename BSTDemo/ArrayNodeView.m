//
//  ArrayNodeView.m
//  BSTDemo
//
//  Created by Andy Lee on 10/4/18.
//  Copyright © 2018 Andy Lee. All rights reserved.
//

#import "ArrayNodeView.h"
#import "BSTView.h"

@implementation ArrayNodeView

#pragma mark - NSResponder methods

- (void)mouseEntered:(NSEvent *)event {
	[self.owningView mouseEnteredArrayNodeView:self];
}

- (void)mouseExited:(NSEvent *)event {
	[self.owningView mouseExitedArrayNodeView:self];
}

- (void)mouseUp:(NSEvent *)event {
	NSPoint mousePoint = [self convertPoint:event.locationInWindow fromView:nil];
	if (NSPointInRect(mousePoint, self.bounds)) {
		[self.owningView mouseClickedArrayNodeView:self];
	} else {
		[super mouseUp:event];
	}
}

@end
