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

/// Elements are in sorted order by value.  Each element's sortIndex is its
/// index in this array.
@property NSMutableArray<ArrayNodeView *> *arrayNodeViews;

/// The root of the BST that the BSTView allows the user to construct.
@property IBOutlet TreeNodeView *rootNodeView;

/// Is set when the mouse hovers over an array node view.  Is unset when the
/// user unhovers.
@property ArrayNodeView *hoveredArrayNodeView;

/// Is set when the user clicks on a tree node view.  Is unset when the user
/// clicks directly on the BSTView (not a subview).
@property TreeNodeView *selectedTreeNodeView;

@end


// Layout
#define NODE_HEIGHT 30
#define ARRAY_INSET 20
#define ARRAY_SEPARATION 4
#define TREE_TOP_INSET 20
#define DEPTH_SEPARATION 40

// Colors
#define NODE_COLOR_IN_TREE (NSColor.yellowColor)
#define RING_COLOR_CLICKABLE_NODE (NSColor.grayColor)
#define RING_COLOR_SELECTED_TREE_NODE (NSColor.redColor)
#define BACKGROUND_COLOR (NSColor.whiteColor)
#define PARENT_LINE_COLOR (NSColor.blackColor)
#define POTENTIAL_PARENT_LINE_COLOR (NSColor.greenColor)
#define SUBTREE_HIGHLIGHT_RECT_COLOR [NSColor colorWithCalibratedWhite:0.95 alpha:1.0]

@implementation BSTView

- (void)resetWithValues:(NSArray *)values {
	self.rootNodeView = nil;
	self.hoveredArrayNodeView = nil;
	self.selectedTreeNodeView = nil;

	// Create the array node views.
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
	TreeNodeView *treeNodeView = [self _treeNodeViewCounterpartOf:arrayNodeView];
	if (treeNodeView == nil) {
		[self _addToTree:arrayNodeView];
	} else {
		self.selectedTreeNodeView = treeNodeView;
		self.needsDisplay = YES;
	}
}

/// Creates a tree node view corresponding to the given array view, and inserts
/// it into the BST of tree node views.
- (void)_addToTree:(ArrayNodeView *)arrayNodeView {
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
	treeNodeView.backgroundColor = NODE_COLOR_IN_TREE;
	arrayNodeView.backgroundColor = NODE_COLOR_IN_TREE;
	[self addSubview:treeNodeView];
	[self _doLayout];
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
	[BACKGROUND_COLOR set];
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

	[PARENT_LINE_COLOR set];
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

	// If the hovered view is not in the tree, draw a line from it to its
	// potential parent node view.
	TreeNodeView *treeNodeView = [self _treeNodeViewCounterpartOf:self.hoveredArrayNodeView];
	if (treeNodeView == nil && self.rootNodeView != nil) {
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

		[POTENTIAL_PARENT_LINE_COLOR set];
		[self _drawLineFromBottomOf:potentialParentNodeView toTopOf:self.hoveredArrayNodeView];
	}

	// Draw a ring around the hovered view to indicate it is clickable.
	if (self.selectedTreeNodeView == nil || treeNodeView != self.selectedTreeNodeView) {
		[RING_COLOR_CLICKABLE_NODE set];
		[self _drawRingAroundView:self.hoveredArrayNodeView];
	}
}

- (void)_highlightSelectedTreeNodeView {
	// If there isn't a selected tree node view, there's nothing to highlight.
	if (self.selectedTreeNodeView == nil) {
		return;
	}

	// Get the range of sorted array indexes covered by the selected subtree.
	NSInteger minIndex = self.selectedTreeNodeView.minDescendant.sortIndex;
	NSInteger maxIndex = self.selectedTreeNodeView.maxDescendant.sortIndex;

	// Draw a fill color in the bounding rectangle of the tree node view and the
	// two array node views at the min and max.
	NSRect highlightRect = self.selectedTreeNodeView.frame;
	highlightRect = NSUnionRect(highlightRect, self.arrayNodeViews[minIndex].frame);
	highlightRect = NSUnionRect(highlightRect, self.arrayNodeViews[maxIndex].frame);
	highlightRect = NSInsetRect(highlightRect, -3, -3);
	[SUBTREE_HIGHLIGHT_RECT_COLOR set];
	NSRectFill(highlightRect);

	// Highlight the selected tree node view and its array node view counterpart.
	[RING_COLOR_SELECTED_TREE_NODE set];
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

- (TreeNodeView *)_treeNodeViewCounterpartOf:(ArrayNodeView *)arrayNodeView {
	return [self _treeNodeViewWithSortIndex:arrayNodeView.sortIndex startingAt:self.rootNodeView];
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
