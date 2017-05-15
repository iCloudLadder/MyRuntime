//
//  ViewController.m
//  MyRuntime
//
//  Created by cooperLink on 2017/5/15.
//  Copyright © 2017年 VS. All rights reserved.
//

#import "ViewController.h"

#import "VSHeaders.h"

#import <objc/runtime.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)testRunTimeMethod{
    NSLog(@"---testRunTimeMethod");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.associatedProperty = @"test associated property";
    
    NSLog(@"%@",self.associatedProperty);
    
    
    //    VSRuntimeModel *model = [[VSRuntimeModel alloc] init];
    //    [model functionOne];
    
    NSLog(@"class name = %s",class_getName(nil)); // return nil
    
    // 注册一个类
    // 创建一个新类
    Class runtimeClass = objc_allocateClassPair(objc_getClass("NSObject"), "RunTimeClass", 0);
    // 添加一个方法
    class_addMethod(runtimeClass, @selector(testRunTimeMethod), class_getMethodImplementation([self class], @selector(testRunTimeMethod)), "v@:");
    // 添加一个变量
    class_addIvar(runtimeClass, "_testIvar", sizeof(NSString*), log2f(sizeof(NSString*)), "i");
    
    // 添加一个property
    objc_property_attribute_t type = {"T", "@\"NSString\""}; // type 类型
    objc_property_attribute_t ownership = { "C", "" }; // copy
    objc_property_attribute_t backingivar = { "V", "_testProperty"}; // @synthesize testProperty = _testProperty
    objc_property_attribute_t nonatomic = { "N", ""};  // nonatomic
    
    objc_property_attribute_t attrs[] = {type, ownership, backingivar,nonatomic};
    class_addProperty(runtimeClass, "testProperty", attrs, sizeof(attrs)/sizeof(objc_property_attribute_t));
    
    
    // 注册
    objc_registerClassPair(runtimeClass);
    // 实例化一个对象
    id model = [[runtimeClass alloc] init];
    // 执行方法
    [model performSelector:@selector(testRunTimeMethod)];
    
    
    
    NSLog(@"class size = %zu",class_getInstanceSize(runtimeClass));
    
    // runtime 中有很多函数，可以自己慢慢探索
    //runtimeClass = [VSRuntimeModel class];
    [self getIVar:runtimeClass];
    [self getProperty:runtimeClass];
    [self getMethodList:runtimeClass];
    [self testMateClassWith:model];
}


- (void)getIVar:(Class)class
{
    NSLog(@"******************ivar*****************************\n");
    unsigned int count = 0;
    Ivar *ivar = class_copyIvarList(class, &count);
    for (int index = 0; index < count; ++index) {
        Ivar var = ivar[index];
        
        NSLog(@"ivar name = %s, offset = %td, - type = %s",ivar_getName(var),ivar_getOffset(var),ivar_getTypeEncoding(var));
        
    }
    free(ivar);
    
}

- (void)getProperty:(Class)class
{
    NSLog(@"******************property*****************************\n");
    unsigned int count = 0;
    objc_property_t *property =  class_copyPropertyList(class, &count);//class_copyIvarList([VSRuntimeModel class], &count);
    for (int index = 0; index < count; ++index) {
        objc_property_t pp = property[index];
        
        NSLog(@"ivar name = %s - %s",property_getName(pp),property_getAttributes(pp));
        
        // C : copy
        // N : nonatomic
        // T : 类型
        // V : 默认的变量名字, @synthesize varName = _varName
        
    }
    free(property);
}


- (void)getMethodList:(Class)class
{
    NSLog(@"******************method*****************************\n");
    
    unsigned int count = 0;
    Method *mt = class_copyMethodList(class, &count);
    for (int index = 0; index < count; ++index) {
        Method md = mt[index];
        NSLog(@"name = %s, - %p, - %s, - %d",sel_getName(method_getName(md)),method_getImplementation(md),method_getTypeEncoding(md),method_getNumberOfArguments(md));
    }
    free(mt);
}

- (void)testMateClassWith:(VSRuntimeModel *)model
{
    NSLog(@"******************mate class*****************************\n");
    
    NSLog(@"model = %p",model);
    NSLog(@"model class = %@ - %p, super class = %@ - %p",[model class],[model class],[model superclass],[model superclass]);
    
    int index = 0;
    Class modelClass = [model class];
    while (index < 4) {
        Class superClass = class_getSuperclass(modelClass);
        NSLog(@"<< star %d",index);
        NSLog(@"---- class = %@ - %p, isMateClass = %d",modelClass,modelClass,class_isMetaClass(modelClass));
        NSLog(@"---- super class = %@ - %p, isMateClass = %d",superClass,superClass,class_isMetaClass(superClass));
        NSLog(@">> end %d",index++);
        modelClass = objc_getMetaClass(object_getClassName(modelClass));
        // modelClass = object_getClass((id)modelClass);
    }
    
    NSLog(@"NSObject class = %@ - %p",[NSObject class],[NSObject class]);
    id mateClass = objc_getMetaClass("NSObject");
    NSLog(@"NSObject mate class = %@ - %p",mateClass,mateClass);
    
    id rootMateClass = objc_getMetaClass(object_getClassName(objc_getMetaClass("NSObject")));
    NSLog(@"NSObject mate class mate class = %p",rootMateClass);
    
    NSLog(@"NSObject superclass = %@",[NSObject superclass]); // 父类是nil
    NSLog(@"NSObject mateclass superclass = %@ - %p",[mateClass superclass],[mateClass superclass]);
    
    
}


- (void)createClass
{
    
    
    
    
}


@end
