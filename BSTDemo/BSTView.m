//
//  BSTView.m
//  BSTDemo
//
//  Created by Andy Lee on 10/4/18.
//  Copyright © 2018 Andy Lee. All rights reserved.
//

#import "BSTView.h"
#import "ArrayNodeView.h"
#import "TreeNodeView.h"


@interface BSTView ()
@property NSMutableArray *arrayNodeViews;  // These are in sorted order by value.
@property IBOutlet TreeNodeView *rootNodeView;
@end


#define NODE_HEIGHT 30
#define ARRAY_INSET 20
#define ARRAY_SEPARATION 4
#define TREE_TOP_INSET 20
#define DEPTH_SEPARATION 40


@implementation BSTView

//TODO: Check what the rule was for duplicate nodes in a binary search tree.

- (TreeNodeView *)_treeNodeViewWithSortIndex:(NSInteger)sortIndex {
	return [self _treeNodeViewWithSortIndex:sortIndex startingAt:self.rootNodeView];
}

- (TreeNodeView *)_treeNodeViewWithSortIndex:(NSInteger)sortIndex startingAt:(TreeNodeView *)nodeView {
	if (nodeView == nil) {
		return nil;
	}
	if (nodeView.sortIndex == sortIndex) {
		return nodeView;
	}
	TreeNodeView *maybe = [self _treeNodeViewWithSortIndex:sortIndex startingAt:nodeView.left];
	if (maybe) {
		return maybe;
	}
	maybe = [self _treeNodeViewWithSortIndex:sortIndex startingAt:nodeView.right];
	if (maybe) {
		return maybe;
	}
	return nil;
}


- (void)handleClickOnArrayNodeView:(ArrayNodeView *)arrayNodeView {
	// Case 1: There is no root yet, so make this node the root.
	if (self.rootNodeView == nil) {
		self.rootNodeView = [[TreeNodeView alloc] init];
		self.rootNodeView.sortIndex = arrayNodeView.sortIndex;
		self.rootNodeView.value = arrayNodeView.value;
		[self addSubview:self.rootNodeView];
		[self _doNodeViewLayout];
		return;
	}

	// Case 2: There is already a corresponding tree node view.
	TreeNodeView *treeNodeView = [self _treeNodeViewWithSortIndex:arrayNodeView.sortIndex startingAt:self.rootNodeView];
	if (treeNodeView) {
		return;
	}

	// Case 3: There is not yet a corresponding tree node view.  Create one.
	treeNodeView = [[TreeNodeView alloc] init];
	treeNodeView.sortIndex = arrayNodeView.sortIndex;
	treeNodeView.value = arrayNodeView.value;

	// Insert the new tree node view into the BST of tree node views.
	TreeNodeView *currentNodeView = self.rootNodeView;
	NSInteger valueToInsert = treeNodeView.value;
	while (YES) {
		if (valueToInsert < currentNodeView.value) {
			if (currentNodeView.left == nil) {
				currentNodeView.left = treeNodeView;
				break;
			} else {
				currentNodeView = currentNodeView.left;
			}
		} else {
			if (currentNodeView.right == nil) {
				currentNodeView.right = treeNodeView;
				break;
			} else {
				currentNodeView = currentNodeView.right;
			}
		}
	}

	// Insert the new tree node view into the view hierarchy.
	[self addSubview:treeNodeView];
	[self _doNodeViewLayout];
	self.needsDisplay = YES;
}


- (void)handleClickOnTreeNodeView:(TreeNodeView *)nodeView {

}


- (void)setUpWithValues:(NSArray *)values {
	// Construct self.arrayNodeViews.
	NSArray *sortedValues = [values sortedArrayUsingSelector:@selector(compare:)];
	[self setSubviews:@[]];
	self.arrayNodeViews = [NSMutableArray array];
	for (int i = 0; i < sortedValues.count; i++) {
		ArrayNodeView *nodeView = [[ArrayNodeView alloc] init];
		nodeView.sortIndex = i;
		nodeView.value = ((NSNumber *)sortedValues[i]).integerValue;
		[self.arrayNodeViews addObject:nodeView];
		[self addSubview:nodeView];
	}

	// Start with no rootNodeView.
	self.rootNodeView = nil;

	// Position all the nodes we just created.
	[self _doNodeViewLayout];
	self.needsDisplay = YES;
}

- (void)_doNodeViewLayout {
	// Lay out the array node views.
	for (NSInteger i = 0; i < self.arrayNodeViews.count; i++) {
		ArrayNodeView *nodeView = self.arrayNodeViews[i];
		nodeView.frame = [self _arrayNodeFrameAtIndex:i];
	}

	// Lay out the tree node views.  Each tree node view will have the same
	// horizontal position as its corresponding array node view.  Vertical
	// positions will depend on the node's depth within the tree.
	[self _doTreeNodeViewLayoutStartingWith:self.rootNodeView depth:0];
}

/// Considers the root to be at depth 0.
- (void)_doTreeNodeViewLayoutStartingWith:(TreeNodeView *)treeNodeView depth:(NSInteger)depth {
	if (treeNodeView == nil) {
		return;
	}

	treeNodeView.frame = [self _frameForTreeNodeView:treeNodeView depth:depth];

	[self _doTreeNodeViewLayoutStartingWith:treeNodeView.left depth:(depth + 1)];
	[self _doTreeNodeViewLayoutStartingWith:treeNodeView.right depth:(depth + 1)];
}

- (NSRect)_frameForTreeNodeView:(TreeNodeView *)treeNodeView depth:(NSInteger)depth {
	NSRect nodeFrame = [self _arrayNodeFrameAtIndex:treeNodeView.sortIndex];
	nodeFrame.origin.y = NSMaxY(self.bounds) - TREE_TOP_INSET - NODE_HEIGHT;  // y for depth 0
	nodeFrame.origin.y -= depth * (NODE_HEIGHT + DEPTH_SEPARATION);  // offset y for actual depth
	return nodeFrame;
}

- (NSRect)_arrayNodeFrameAtIndex:(NSInteger)arrayIndex {
	// Get the bounding rect within which to fit all the array node views.
	NSRect arrayBoundingRect = self.bounds;
	arrayBoundingRect.origin.x += ARRAY_INSET;
	arrayBoundingRect.origin.y += ARRAY_INSET;
	arrayBoundingRect.size.width -= 2*ARRAY_INSET;
	arrayBoundingRect.size.height = NODE_HEIGHT;

	// Get the frame for the first array node view.
	NSInteger numNodes = self.arrayNodeViews.count;
	CGFloat arrayWidth = arrayBoundingRect.size.width;
	CGFloat nodeWidth = floor((arrayWidth - (numNodes - 1)*ARRAY_SEPARATION) / numNodes);
	NSRect nodeFrame = arrayBoundingRect;
	nodeFrame.size.width = nodeWidth;

	// Offset that frame horizontally depending on arrayIndex.
	nodeFrame.origin.x += arrayIndex * (nodeWidth + ARRAY_SEPARATION);
	return nodeFrame;
}


#pragma mark - NSView methods

- (void)resizeSubviewsWithOldSize:(NSSize)oldSize {
	[self _doNodeViewLayout];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
	[self _drawTreeNodeLinesStartingWith:self.rootNodeView depth:0];
}

- (void)_drawLineFrom:(NSPoint)startPoint to:(NSPoint)endPoint {
	// Construct the path.
	NSBezierPath * path = [NSBezierPath bezierPath];
	[path moveToPoint:startPoint];
	[path lineToPoint:endPoint];

	// Draw the path.
	[path setLineWidth:1];
	[NSColor.blackColor set];
	[path stroke];
}

- (void)_drawTreeNodeLinesStartingWith:(TreeNodeView *)treeNodeView depth:(NSInteger)depth {
	if (treeNodeView == nil) {
		return;
	}

	[NSColor.blackColor set];
	NSRect thisFrame = treeNodeView.frame;
	NSPoint parentPoint = NSMakePoint(NSMidX(thisFrame), NSMinY(thisFrame));

	if (treeNodeView.left) {
		NSRect childFrame = [self _frameForTreeNodeView:treeNodeView.left depth:(depth + 1)];
		NSPoint childPoint = NSMakePoint(NSMidX(childFrame), NSMaxY(childFrame));
		[self _drawLineFrom:parentPoint to:childPoint];
		[self _drawTreeNodeLinesStartingWith:treeNodeView.left depth:(depth + 1)];
	}

	if (treeNodeView.right) {
		NSRect childFrame = [self _frameForTreeNodeView:treeNodeView.right depth:(depth + 1)];
		NSPoint childPoint = NSMakePoint(NSMidX(childFrame), NSMaxY(childFrame));
		[self _drawLineFrom:parentPoint to:childPoint];
		[self _drawTreeNodeLinesStartingWith:treeNodeView.right depth:(depth + 1)];
	}
}



@end
