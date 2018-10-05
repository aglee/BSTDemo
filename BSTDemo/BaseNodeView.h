//
//  BaseNodeView.h
//  BSTDemo
//
//  Created by Andy Lee on 10/4/18.
//  Copyright © 2018 Andy Lee. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BSTView;
@class BSTNode;

NS_ASSUME_NONNULL_BEGIN

/// Base class for views that represent a node in a binary search tree.
@interface BaseNodeView : NSView

/// The owning BSTMainView.
@property (readonly) BSTView *mainView;

@property BSTNode *node;

@end

NS_ASSUME_NONNULL_END
