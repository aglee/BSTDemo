//
//  BaseNodeView.m
//  BSTDemo
//
//  Created by Andy Lee on 10/4/18.
//  Copyright © 2018 Andy Lee. All rights reserved.
//

#import "BaseNodeView.h"

@implementation BaseNodeView

@synthesize backgroundColor = _backgroundColor;

#pragma mark - Init/awake/dealloc

- (instancetype)initWithValue:(NSInteger)value sortIndex:(NSInteger)sortIndex {
	self = [super initWithFrame:NSZeroRect];
	if (self) {
		self.value = value;
		self.sortIndex = sortIndex;
		self.backgroundColor = self.class.defaultBackgroundColor;
	}
	return self;
}

#pragma mark - Getters and setters

+ (NSColor *)defaultBackgroundColor {
	return NSColor.whiteColor;
}

- (BSTView *)owningView {
	return (BSTView *)self.superview;
}

- (NSColor *)backgroundColor {
	return _backgroundColor;
}

- (void)setBackgroundColor:(NSColor *)backgroundColor {
	_backgroundColor = backgroundColor;
	self.needsDisplay = YES;
}

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

- (void)drawRect:(NSRect)dirtyRect {
	[super drawRect:dirtyRect];

	// Draw the background.
	[self.backgroundColor set];
	NSRectFill(self.bounds);

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
