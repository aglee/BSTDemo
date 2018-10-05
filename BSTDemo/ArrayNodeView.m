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

- (void)mouseUp:(NSEvent *)event {
	NSPoint mousePoint = [self convertPoint:event.locationInWindow fromView:nil];
	if (NSPointInRect(mousePoint, self.bounds)) {
		[self.mainView handleClickOnArrayNodeView:self];
	} else {
		[super mouseUp:event];
	}
}

@end
