//
//  BaseNodeView.m
//  BSTDemo
//
//  Created by Andy Lee on 10/4/18.
//  Copyright © 2018 Andy Lee. All rights reserved.
//

#import "BaseNodeView.h"


@implementation BaseNodeView



#pragma mark - Getters and setters

- (BSTView *)mainView {
	return (BSTView *)self.superview;
}


#pragma mark - NSView methods

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

	// Draw the border.
	[NSColor.blackColor set];
	NSFrameRect(self.bounds);

	// Draw the node value.
	NSString *valueString = [NSString stringWithFormat:@"%ld", self.value];
	NSRect valueRect = NSInsetRect(self.bounds, 4, 4);
	[valueString drawInRect:valueRect withAttributes:nil];
}

@end
