//
//  BaseNodeView.h
//  BSTDemo
//
//  Created by Andy Lee on 10/4/18.
//  Copyright © 2018 Andy Lee. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BSTView;

NS_ASSUME_NONNULL_BEGIN

/// Base class used by BSTView to represent a node in a binary search tree.
@interface BaseNodeView : NSView

/// The owning BSTMainView.
@property (readonly) BSTView *mainView;

@property NSInteger value;

/// Index of this node within the sort order of nodes in the owning BSTView.
/// This provides the owning BSTView with a unique identifier it can use to
/// correlate "tree node views" and the corresponding "array node views".
@property NSInteger sortIndex;

@property NSColor *backgroundColor;

@property (class, readonly) NSColor *defaultBackgroundColor;
@property (class, readonly) NSColor *treeNodeBackgroundColor;

- (instancetype)initWithValue:(NSInteger)value sortIndex:(NSInteger)sortIndex;

@end

NS_ASSUME_NONNULL_END
