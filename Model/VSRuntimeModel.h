//
//  VSRuntimeModel.h
//  VSRunTimeStudy
//
//  Created by cooperLink on 16/2/1.
//  Copyright © 2016年 VS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VSRuntimeModel : NSObject
{
    NSString *varOne;
}


@property (nonatomic, copy) NSString *propertyVarTwo;
@property (copy) NSString *propertyVarFour;
//@property (assign, nonatomic, readonly) NSInteger integer;
//@property (assign, nonatomic, readwrite) NSInteger integer1;
//@property (assign, atomic, readwrite) NSInteger integer2;
//
//@property (atomic, readwrite, retain) NSString *str1;
//@property (atomic, readwrite, strong) NSString *str2;
//@property (atomic, readwrite, weak) NSString *str3;


- (void)functionOne;

+ (void)classFunction;


@end
