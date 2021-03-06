//
//  BSTView.h
//  BSTDemo
//
//  Created by Andy Lee on 10/4/18.
//  Copyright © 2018 Andy Lee. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ArrayNodeView;
@class TreeNodeView;

NS_ASSUME_NONNULL_BEGIN

/// Displays a binary search tree in both tree form and array form.
///
/// Initially there is no BST, only an array of values in sorted order.  The
/// user can construct the BST by clicking one value at a time to add, in any
/// order.
@interface BSTView : NSView

/// Clears any existing BST nodes and starts fresh using the numbers in nodeValues.
- (void)resetWithValues:(NSArray<NSNumber *> *)nodeValues;

/// Clears any existing BST nodes and starts fresh using the numbers 1, 2, ..., numValues.
- (void)resetWithPositiveIntegersThrough:(NSInteger)numValues;

/// Adds all remaining nodes to the tree, in random order.
- (void)finishTreeRandomly;

#pragma mark - Event handling

- (void)mouseEnteredArrayNodeView:(ArrayNodeView *)arrayNodeView;
- (void)mouseExitedArrayNodeView:(ArrayNodeView *)arrayNodeView;
- (void)mouseClickedArrayNodeView:(ArrayNodeView *)arrayNodeView;

- (void)mouseEnteredTreeNodeView:(TreeNodeView *)treeNodeView;
- (void)mouseExitedTreeNodeView:(TreeNodeView *)treeNodeView;
- (void)mouseClickedTreeNodeView:(TreeNodeView *)treeNodeView;

@end

NS_ASSUME_NONNULL_END
