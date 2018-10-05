//
//  BSTArrayNodeView.m
//  BSTDemo
//
//  Created by Andy Lee on 10/4/18.
//  Copyright © 2018 Andy Lee. All rights reserved.
//

#import "BSTArrayNodeView.h"
#import "BSTMainView.h"

@implementation BSTArrayNodeView


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
