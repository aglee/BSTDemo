//
//  BSTNode.m
//  BSTDemo
//
//  Created by Andy Lee on 10/4/18.
//  Copyright © 2018 Andy Lee. All rights reserved.
//

#import "BSTNode.h"

@implementation BSTNode

+ (instancetype)nodeWithInteger:(NSInteger)nodeValue {
	BSTNode *node = [[self alloc] init];
	node.value = nodeValue;
	return node;
}

@end
