//
//  TreeNodeView.m
//  BSTDemo
//
//  Created by Andy Lee on 10/4/18.
//  Copyright © 2018 Andy Lee. All rights reserved.
//

#import "TreeNodeView.h"

@implementation TreeNodeView

#pragma mark - Init/awake/dealloc

- (instancetype)initWithValue:(NSInteger)value sortIndex:(NSInteger)sortIndex {
	self = [super initWithValue:value sortIndex:sortIndex];
	if (self) {
		self.backgroundColor = self.class.treeNodeBackgroundColor;
	}
	return self;
}

@end
