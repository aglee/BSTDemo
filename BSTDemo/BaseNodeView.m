//
//  BaseNodeView.m
//  BSTDemo
//
//  Created by Andy Lee on 10/4/18.
//  Copyright © 2018 Andy Lee. All rights reserved.
//

#import "BaseNodeView.h"

@implementation BaseNodeView

#pragma mark - Init/awake/dealloc

- (instancetype)initWithValue:(NSInteger)value sortIndex:(NSInteger)sortIndex {
	self = [super initWithFrame:NSZeroRect];
	if (self) {
		self.value = value;
		self.sortIndex = sortIndex;
	}
	return self;
}

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
	NSDictionary *attr = @{ NSFontAttributeName: [NSFont fontWithName:@"Courier" size:20.0] };
	NSString *valueString = [NSString stringWithFormat:@"%ld", self.value];
	NSSize stringSize = [valueString sizeWithAttributes:attr];
	NSRect valueRect = (NSRect) { .origin = NSZeroPoint, .size = stringSize };
	valueRect.origin.x = floor((NSWidth(self.bounds) - stringSize.width) / 2.0);
	valueRect.origin.y = floor((NSHeight(self.bounds) - stringSize.height) / 2.0);
	[valueString drawInRect:valueRect withAttributes:attr];
}

@end
