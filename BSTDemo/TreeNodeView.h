//
//  TreeNodeView.h
//  BSTDemo
//
//  Created by Andy Lee on 10/4/18.
//  Copyright © 2018 Andy Lee. All rights reserved.
//

#import "BaseNodeView.h"

NS_ASSUME_NONNULL_BEGIN

/// Used by BSTView to display a node within a binary search tree.
@interface TreeNodeView : BaseNodeView

@property TreeNodeView *left;
@property TreeNodeView *right;

- (TreeNodeView *)minDescendant;
- (TreeNodeView *)maxDescendant;

@end

NS_ASSUME_NONNULL_END
