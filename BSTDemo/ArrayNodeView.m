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

#pragma mark - NSView methods

- (void)updateTrackingAreas {
	[super updateTrackingAreas];

	if (self.trackingAreas.count == 0) {
		[self addTrackingArea:[[NSTrackingArea alloc] initWithRect:self.bounds
														   options:(NSTrackingMouseEnteredAndExited
																	| NSTrackingActiveInKeyWindow
																	| NSTrackingInVisibleRect)
															 owner:self
														  userInfo:nil]];
	}
}

#pragma mark - NSResponder methods

- (void)mouseEntered:(NSEvent *)event {
	[self.mainView mouseEnteredArrayNodeView:self];
}

- (void)mouseExited:(NSEvent *)event {
	[self.mainView mouseExitedArrayNodeView:self];
}

- (void)mouseUp:(NSEvent *)event {
	NSPoint mousePoint = [self convertPoint:event.locationInWindow fromView:nil];
	if (NSPointInRect(mousePoint, self.bounds)) {
		[self.mainView handleClickOnArrayNodeView:self];
	} else {
		[super mouseUp:event];
	}
}

@end
