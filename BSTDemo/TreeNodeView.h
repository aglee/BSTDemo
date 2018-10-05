//
//  TreeNodeView.h
//  BSTDemo
//
//  Created by Andy Lee on 10/4/18.
//  Copyright © 2018 Andy Lee. All rights reserved.
//

#import "BaseNodeView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TreeNodeView : BaseNodeView

@property TreeNodeView *left;
@property TreeNodeView *right;

@end

NS_ASSUME_NONNULL_END
