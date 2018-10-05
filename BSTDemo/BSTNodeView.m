//
//  BSTNodeView.m
//  BSTDemo
//
//  Created by Andy Lee on 10/4/18.
//  Copyright © 2018 Andy Lee. All rights reserved.
//

#import "BSTNodeView.h"
#import "BSTNode.h"


@implementation BSTNodeView



#pragma mark - Getters and setters

- (BSTMainView *)mainView {
	return (BSTMainView *)self.superview;
}


#pragma mark - NSView methods

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

	NSString *valueString = [NSString stringWithFormat:@"%ld", self.node.value];
	NSRect valueRect = NSInsetRect(self.bounds, 4, 4);
	[valueString drawInRect:valueRect withAttributes:nil];

	[NSColor.blackColor set];
	NSFrameRect(self.bounds);
}

@end
