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
@property NSMutableArray<ArrayNodeView *> *arrayNodeViews;  // These are in sorted order by value.
@property IBOutlet TreeNodeView *rootNodeView;
@property ArrayNodeView *hoveredArrayNodeView;  // Is set when the mouse hovers over an array node view.
@property TreeNodeView *selectedTreeNodeView;
@end


#define NODE_HEIGHT 30
#define ARRAY_INSET 20
#define ARRAY_SEPARATION 4
#define TREE_TOP_INSET 20
#define DEPTH_SEPARATION 40


@implementation BSTView

- (void)resetWithValues:(NSArray *)values {
	self.rootNodeView = nil;
	self.hoveredArrayNodeView = nil;
	self.selectedTreeNodeView = nil;

	// Construct self.arrayNodeViews.
	NSArray *sortedValues = [values sortedArrayUsingSelector:@selector(compare:)];
	[self setSubviews:@[]];
	self.arrayNodeViews = [NSMutableArray array];
	for (int i = 0; i < sortedValues.count; i++) {
		NSInteger value = ((NSNumber *)sortedValues[i]).integerValue;
		ArrayNodeView *nodeView = [[ArrayNodeView alloc] initWithValue:value sortIndex:i];
		[self.arrayNodeViews addObject:nodeView];
		[self addSubview:nodeView];
	}

	// Lay out all the nodes we just created.
	[self _doLayout];
	self.needsDisplay = YES;
}

#pragma mark - Event handling

- (void)mouseEnteredArrayNodeView:(ArrayNodeView *)arrayNodeView {
	self.hoveredArrayNodeView = arrayNodeView;
	self.needsDisplay = YES;
}

- (void)mouseExitedArrayNodeView:(ArrayNodeView *)arrayNodeView {
	self.hoveredArrayNodeView = nil;
	self.needsDisplay = YES;
}

- (void)handleClickOnArrayNodeView:(ArrayNodeView *)arrayNodeView {
	// If there is already a corresponding tree node view, do nothing.
	if ([self _treeNodeViewWithSortIndex:arrayNodeView.sortIndex]) {
		return;
	}

	// Create a tree node corresponding to the given array node, and insert it
	// into the BST of tree node views.
	TreeNodeView *treeNodeView = [[TreeNodeView alloc] initWithValue:arrayNodeView.value
														   sortIndex:arrayNodeView.sortIndex];
	if (self.rootNodeView == nil) {
		self.rootNodeView = treeNodeView;
	} else {
		TreeNodeView *currentNodeView = self.rootNodeView;
		while (YES) {
			if (treeNodeView.value < currentNodeView.value) {
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
	}

	// Finish up display and layout adjustments.
	[self addSubview:treeNodeView];
	[self _doLayout];
	arrayNodeView.isInTheTree = YES;
	self.hoveredArrayNodeView = nil;
	self.needsDisplay = YES;
}


- (void)handleClickOnTreeNodeView:(TreeNodeView *)treeNodeView {
	self.selectedTreeNodeView = treeNodeView;
	self.needsDisplay = YES;
}


#pragma mark - NSView methods

- (void)resizeSubviewsWithOldSize:(NSSize)oldSize {
	[self _doLayout];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

	// Draw background color so we look the same regardless of Mojave dark mode.
	[NSColor.whiteColor set];
	NSRectFill(self.bounds);

	// If a tree node view is selected, reflect that.
	[self _highlightSelectedTreeNodeView];

	// Draw lines connecting parent nodes to child nodes.
	[self _drawTreeNodeLinesStartingWith:self.rootNodeView];

	// If an array node view is being hovered over, reflect that.
	[self _highlightHoveredArrayNodeView];
}

#pragma mark - NSResponder methods

- (void)mouseUp:(NSEvent *)event {
	NSPoint mousePoint = [self convertPoint:event.locationInWindow fromView:nil];
	if (NSPointInRect(mousePoint, self.bounds)) {
		// If a tree node view was selected, unselect it.
		self.selectedTreeNodeView = nil;
		self.needsDisplay = YES;
	} else {
		[super mouseUp:event];
	}
}

#pragma mark - Private methods - drawing

/// Doesn't set a color.  Uses the graphics context's current color.
- (void)_drawLineFromBottomOf:(NSView *)upperView toTopOf:(NSView *)lowerView {
	// Calculate the two points to connect.
	NSPoint startPoint = NSMakePoint(NSMidX(upperView.frame), NSMinY(upperView.frame));
	NSPoint endPoint = NSMakePoint(NSMidX(lowerView.frame), NSMaxY(lowerView.frame));

	// Construct the path.
	NSBezierPath * path = [NSBezierPath bezierPath];
	[path moveToPoint:startPoint];
	[path lineToPoint:endPoint];

	// Draw the path.
	[path setLineWidth:1];
	[path stroke];
}

- (void)_drawTreeNodeLinesStartingWith:(TreeNodeView *)treeNodeView {
	if (treeNodeView == nil) {
		return;
	}

	[NSColor.blackColor set];
	if (treeNodeView.left) {
		[self _drawLineFromBottomOf:treeNodeView toTopOf:treeNodeView.left];
		[self _drawTreeNodeLinesStartingWith:treeNodeView.left];
	}
	if (treeNodeView.right) {
		[self _drawLineFromBottomOf:treeNodeView toTopOf:treeNodeView.right];
		[self _drawTreeNodeLinesStartingWith:treeNodeView.right];
	}
}

/// Draws an outline to indicate to the user that the view is clickable.
/// Used the current graphics context's drawing color.
- (void)_drawRingAroundView:(NSView *)view {
	NSRect highlightRect = view.frame;
	highlightRect = NSInsetRect(highlightRect, -3, -3);
	NSFrameRectWithWidth(highlightRect, 3);
}

- (void)_highlightHoveredArrayNodeView {
	// If we're not hovering over an array node view, there's nothing to highlight.
	if (self.hoveredArrayNodeView == nil) {
		return;
	}

	// If the array node view is already "in the tree", there's nothing to highlight.
	if (self.hoveredArrayNodeView.isInTheTree) {
		return;
	}

	// Highlight the hovered view to indicate it is clickable.
	[NSColor.redColor set];
	[self _drawRingAroundView:self.hoveredArrayNodeView];

	// Draw a connecting line from the hovered view to its potential parent node view.
	if (self.rootNodeView != nil) {
		TreeNodeView *potentialParentNodeView = self.rootNodeView;
		while (YES) {
			if (self.hoveredArrayNodeView.value < potentialParentNodeView.value) {
				if (potentialParentNodeView.left == nil) {
					break;
				} else {
					potentialParentNodeView = potentialParentNodeView.left;
				}
			} else {
				if (potentialParentNodeView.right == nil) {
					break;
				} else {
					potentialParentNodeView = potentialParentNodeView.right;
				}
			}
		}

		[NSColor.redColor set];
		[self _drawLineFromBottomOf:potentialParentNodeView toTopOf:self.hoveredArrayNodeView];
	}
}

/// Returns nil if treeNodeView is nil, else array of two indexes into the sorted array.
- (NSArray<NSNumber *> *)_minMaxSortIndexesInTree:(TreeNodeView *)treeNodeView {
	if (treeNodeView == nil) {
		return nil;
	}

	// Visit every node in the tree using breadth-first traversal.
	NSInteger minIndex = NSIntegerMax;
	NSInteger maxIndex = NSIntegerMin;
	NSArray<TreeNodeView *> *row = @[ treeNodeView ];
	while (row.count > 0) {
		NSMutableArray<TreeNodeView *> *nextRow = [NSMutableArray array];
		for (TreeNodeView *treeNodeView in row) {
			if (treeNodeView.sortIndex < minIndex) {
				minIndex = treeNodeView.sortIndex;
			}
			if (treeNodeView.sortIndex > maxIndex) {
				maxIndex = treeNodeView.sortIndex;
			}
			if (treeNodeView.left) {
				[nextRow addObject:treeNodeView.left];
			}
			if (treeNodeView.right) {
				[nextRow addObject:treeNodeView.right];
			}
		}
		row = nextRow;
	}

	return @[ @(minIndex), @(maxIndex) ];
}

- (void)_highlightSelectedTreeNodeView {
	// If there isn't a selected tree node view, there's nothing to highlight.
	if (self.selectedTreeNodeView == nil) {
		return;
	}

	// Get the range of sorted array indexes covered by the selected subtree.
	NSArray<NSNumber *> *minMaxIndexes = [self _minMaxSortIndexesInTree:self.selectedTreeNodeView];
	NSInteger minIndex = minMaxIndexes[0].integerValue;
	NSInteger maxIndex = minMaxIndexes[1].integerValue;

	// Draw a fill in the bounding rectangle of three views: the tree node view
	// and the two array node views at the min and max.
	NSRect highlightRect = self.selectedTreeNodeView.frame;
	highlightRect = NSUnionRect(highlightRect, self.arrayNodeViews[minIndex].frame);
	highlightRect = NSUnionRect(highlightRect, self.arrayNodeViews[maxIndex].frame);
	highlightRect = NSInsetRect(highlightRect, -3, -3);
	[[NSColor colorWithCalibratedWhite:0.83 alpha:1.0] set];
	NSRectFill(highlightRect);

	// Highlight the selected tree node view and its array node view counterpart.
	[NSColor.blueColor set];
	[self _drawRingAroundView:self.selectedTreeNodeView];
	[self _drawRingAroundView:self.arrayNodeViews[self.selectedTreeNodeView.sortIndex]];
}

#pragma mark - Private methods - layout

- (void)_doLayout {
	// Lay out the array node views.
	for (NSInteger i = 0; i < self.arrayNodeViews.count; i++) {
		self.arrayNodeViews[i].frame = [self _arrayNodeFrameAtIndex:i];
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

#pragma mark - Private methods - node views

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

@end
