//
//  VSRuntimeModel.m
//  VSRunTimeStudy
//
//  Created by cooperLink on 16/2/1.
//  Copyright © 2016年 VS. All rights reserved.
//

#import "VSRuntimeModel.h"

@interface VSRuntimeModel ()
{
    NSString *varThree;
}

@property (nonatomic, copy) NSString *propertyVarFive;

@end

@implementation VSRuntimeModel

@synthesize propertyVarFour;


- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@">> %@",[self class]);      // VSRuntimeModel 消息的发送者是 self
        NSLog(@">> %@",[super class]);     // VSRuntimeModel 消息的发送者是 self
        NSLog(@">> %@",[self.superclass class]); // NSObject 消息的发送者是 self.superclass

        
    }
    return self;
}


- (void)functionOne
{
    NSLog(@"func >> %s",__func__);
    NSLog(@"func >> %s",__FUNCTION__);

}

+ (void)classFunction
{
    NSLog(@"class function");
}









@end
