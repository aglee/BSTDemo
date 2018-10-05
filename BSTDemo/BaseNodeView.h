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

/// Base class for views that represent a node in a binary search tree.
@interface BaseNodeView : NSView

/// The owning BSTMainView.
@property (readonly) BSTView *mainView;

/// Index of this node within the sort order of nodes in self.mainView.
@property NSInteger sortIndex;

@property NSInteger value;

@end

NS_ASSUME_NONNULL_END
