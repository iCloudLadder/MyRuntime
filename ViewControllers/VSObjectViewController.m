//
//  VSObjectViewController.m
//  VSRunTimeStudy
//
//  Created by cooperLink on 16/2/1.
//  Copyright © 2016年 VS. All rights reserved.
//

#import "VSObjectViewController.h"
#import "VSHeaders.h"

@interface VSObjectViewController ()

@end

@implementation VSObjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // NSObject 是对Object的再次封装
    // 接下来的探究 从 Object 里来
    
    VSRuntimeModel *model = [[VSRuntimeModel alloc] init];
    
    
    NSLog(@"%d",[model isKindOfClass:[VSRuntimeModel class]]); // ........................1
    NSLog(@"%d",[VSRuntimeModel isKindOfClass:[VSRuntimeModel class]]); // ...............0
    NSLog(@"%d",[VSRuntimeModel isKindOfClass:[NSObject class]]); // .....................1
    
    NSLog(@"%d",[[VSRuntimeModel class] isKindOfClass:[VSRuntimeModel class]]); // .......0
    NSLog(@"%d",[[VSRuntimeModel class] isKindOfClass:[NSObject class]]); // .............1
    
    NSLog(@"%d",[NSObject isKindOfClass:[NSObject class]]);  // ..........................1
    NSLog(@"%d",[[NSObject class] isKindOfClass:[NSObject class]]); // ...................1
    
    /*
     
     - (BOOL)isKindOf:aClass
     {
     Class cls;
     for (cls = isa; cls; cls = cls->superclass)
     if (cls == (Class)aClass)
     return YES;
     return NO;
     }
     
     
     -(id)class
     {
     return (id)isa; 实例对象的class 是isa指向的class
     }
     
     + (id)class
     {
     return self; 类的class还是自己，[ClassName class] --> ClassName
     }
     
     model 的isa -> VSRuntimeModel
     VSRuntimeModel 的isa -> VSRuntimeModel mate class
     VSRuntimeModel mate class 的isa -> NSObject mate class
     NSObject mate class 的isa -> NSObject mate class
     
     
     */
    NSLog(@"function  isMemberOf:");
    NSLog(@"%d",[model isMemberOfClass:[VSRuntimeModel class]]); // ........................1
    NSLog(@"%d",[VSRuntimeModel isMemberOfClass:[VSRuntimeModel class]]); // ...............0
    NSLog(@"%d",[VSRuntimeModel isMemberOfClass:[NSObject class]]); // .....................0
    
    NSLog(@"%d",[[VSRuntimeModel class] isMemberOfClass:[VSRuntimeModel class]]); // .......0
    NSLog(@"%d",[[VSRuntimeModel class] isMemberOfClass:[NSObject class]]); // .............0
    
    NSLog(@"%d",[NSObject isMemberOfClass:[NSObject class]]);  // ..........................0
    NSLog(@"%d",[[NSObject class] isMemberOfClass:[NSObject class]]); // ...................0
    
    /*
     - (BOOL)isMemberOf:aClass
     {
     return isa == (Class)aClass;
     }
     
     */
    
    
    
    
    
    /* 看图 class.jpg (从网上拷的)
     mate class 的mate class 是 NSObject 的mate class，
     NSObject 的mate class 还是 NSObject 的mate class， 也就是mate class 自身
              nil                       ↓←←←←←←←←←↑
               ↑                        ↓         ↑
               NSObject     ->    NSObject mate class←←←↑←←←←↑
               ↑                   ↑              ↑     ↑    ↑
               .......     ->      .......     →→→→     ↑    ↑
               ↑                   ↑                    ↑    ↑
               SuperClass   ->  SuperClass mate class →→→    ↑
               ↑                   ↑                         ↑
     model -> VSRuntimeModel -> VSRuntimeModel mate class →→→→
     
     
     这里可以体现 面向对象编程  万事万物皆对象 的思想
     */
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
