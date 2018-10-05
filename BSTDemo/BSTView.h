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

/// All-encompassing view that shows BST in both tree form and array form.
@interface BSTView : NSView

/// Initializes the data to consist of the numbers in values, with no root node
/// having been specified.
- (void)setUpWithValues:(NSArray *)values;

- (void)handleClickOnArrayNodeView:(ArrayNodeView *)nodeView;
- (void)handleClickOnTreeNodeView:(TreeNodeView *)nodeView;

@end

NS_ASSUME_NONNULL_END
