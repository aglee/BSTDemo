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

/// Initializes the view using the numbers in values.  Resets the BST to nil.
- (void)resetWithValues:(NSArray *)values;

- (void)handleClickOnArrayNodeView:(ArrayNodeView *)nodeView;
- (void)handleClickOnTreeNodeView:(TreeNodeView *)nodeView;

@end

NS_ASSUME_NONNULL_END
