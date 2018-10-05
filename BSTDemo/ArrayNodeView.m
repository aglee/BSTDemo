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

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

#pragma mark - NSResponder methods

- (void)mouseDown:(NSEvent *)event {
	[self.mainView handleClickOnArrayNodeView:self];
}

@end
