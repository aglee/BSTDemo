//
//  BSTNodeView.h
//  BSTDemo
//
//  Created by Andy Lee on 10/4/18.
//  Copyright © 2018 Andy Lee. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BSTMainView;
@class BSTNode;

NS_ASSUME_NONNULL_BEGIN

/// Base class for views that represent a node in a binary search tree.
@interface BSTNodeView : NSView

#pragma mark - "View" properties

/// The owning BSTMainView.
@property (readonly) BSTMainView *mainView;

@property BSTNode *node;

@end

NS_ASSUME_NONNULL_END
