//
//  NSObject+VSAssociatedProperty.m
//  VSRunTimeStudy
//
//  Created by cooperLink on 16/3/9.
//  Copyright © 2016年 VS. All rights reserved.
//

#import "NSObject+VSAssociatedProperty.h"
#import <objc/runtime.h>


/*
 
 // 设置关联对象
 void objc_setAssociatedObject ( id object, const void *key, id value, objc_AssociationPolicy policy );
 
 // 获取关联对象
 id objc_getAssociatedObject ( id object, const void *key );
 
 // 移除关联对象
 void objc_removeAssociatedObjects ( id object );
 
 */


@implementation NSObject (VSAssociatedProperty)

const void *associatedKey = @"ObjectAssociatedKey";

-(void)setAssociatedProperty:(NSString *)associatedProperty
{
    //  关联对象 会在 self 被释放时，根据所用的 objc_AssociationPolicy 进行自动释放， 所以不需要手动释放，即使在MRC环境下也不需要
    objc_setAssociatedObject(self, associatedKey, associatedProperty, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    
    // objc_removeAssociatedObjects(<#id object#>) 用来移除关联对象
}

-(NSString *)associatedProperty
{
    return objc_getAssociatedObject(self, associatedKey);
}


@end
