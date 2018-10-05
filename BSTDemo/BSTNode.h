//
//  BSTNode.h
//  BSTDemo
//
//  Created by Andy Lee on 10/4/18.
//  Copyright © 2018 Andy Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BSTNode : NSObject

@property NSInteger value;
//@property BSTNode *left;
//@property BSTNode *right;
//@property BSTNode *parent;

+ (instancetype)nodeWithInteger:(NSInteger)nodeValue;

@end

NS_ASSUME_NONNULL_END
