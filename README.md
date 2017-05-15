# MyRuntime
Runtime study


Objective-C中的类是由Class类型来表示，也就是 struct结构体封装的，
 
 struct(runtime) -> Object -> NSObject(Root Class)
 
 
 >> Class 是什么？ 结构体 objc_class 类型的指针
 typedef struct objc_class *Class;
 
 >> struct objc_class 是什么？
    
 struct objc_class {
    Class isa  OBJC_ISA_AVAILABILITY;  // 指向自身 Class类型，Class的isa指向其mateClass，mateClass的isa指向 NSObject的mateClass
                                       //  NSObject的mateClass的isa指向 自己，也就是 NSObject的mateClass(看图class.jpg)
    #if !__OBJC2__
    Class super_class                       OBJC2_UNAVAILABLE;  // 父类，RootClass(NSObject,NSProxy)的super_class为NULL
    const char *name                        OBJC2_UNAVAILABLE;  // 类名
    long version                            OBJC2_UNAVAILABLE;  // 类的版本信息，默认为0
    long info                               OBJC2_UNAVAILABLE;  // 类信息，供运行期使用的一些位标识
    long instance_size                      OBJC2_UNAVAILABLE;  // 该类的实例变量大小
    struct objc_ivar_list *ivars            OBJC2_UNAVAILABLE;  // 该类的成员变量链表
    struct objc_method_list **methodLists   OBJC2_UNAVAILABLE;  // 方法定义的链表
    struct objc_cache *cache                OBJC2_UNAVAILABLE;  // 方法缓存,缓存最近使用的方法
    struct objc_protocol_list *protocols    OBJC2_UNAVAILABLE;  // 协议链表
    #endif
 
 } OBJC2_UNAVAILABLE;
 
 // 方法的缓存，方便下次使用，第一次调用方法后，会被缓存到struct objc_cache *cache中，再次调用先从cache中查找，可提高效率
 // 方法的查找 cache -> self.methodLists -> superClass ... -> rootClass, 找不到就抛出异常，
 // 抛出异常前，我们还有机会，做一些操作 避免这种crash，之后会讲
 
 
 >> objc_object ? 表示类实例的结构体
 struct objc_object {
    Class isa  OBJC_ISA_AVAILABILITY; 指向自身 class类型， 运行时根据实例的 isa指针 找到实例对象所属的类，编译时不做检测
 };
 
 >> id ?
 typedef struct objc_object *id;  id 类的泛型指针，可以转换成任何 类型的对象，但运行时会根据isa指针查找所属类， 类似C中 void *
 
 
 >> struct objc_cache ?
 
 struct objc_cache {
    unsigned int mask   // total = mask + 1                  OBJC2_UNAVAILABLE;
    unsigned int occupied                                    OBJC2_UNAVAILABLE;
    Method buckets[1]                                        OBJC2_UNAVAILABLE;
 };
 
 // mask：整数，指定分配的缓存  bucket 总数。
          在方法查找过程中，runtime 使用这个字段来确定开始线性查找数组的索引位置。
          指向方法selector的指针与该字段做一个 & 位操作(index = (mask & selector))。
          这可以作为一个简单的hash散列算法。
 
 // occupied :指定实际占用的缓存 bucket 总数
 
 // buckets：指向Method数据结构指针的数组。这个数组可能包含不超过mask+1个元素。
             需要注意的是，指针可能是NULL，表示这个缓存bucket没有被占用，另外被占用的bucket可能是不连续的。
             这个数组可能会随着时间而增长。


 >> Meta Class 元类 ？
 所有的类(Class)自身也是一个对象，也可以发送消息(类方法的调用)
 Meta Class 是一个 类(Class) 的 类(Class)
 Meta Class 存储这一个类的所有 类方法(即 + 方法)
 Meta Class也是一个类实例，也可以发送消息。OC所有类的 Meta Class的isa指针都指向Root Class的Meta Class，
           Root Class的Meta Class的isa还指向Root Class的Meta Class，
 
           也就是说，所有继承自NSObject的类的Meta Class的isa都指向 NSObject的 Meta Class，
           而NSObject的 Meta Class 的isa还指向 NSObject的 Meta Class，形成一个闭环(图class.jpg)

 -- 看ViewController.m 中 testMateClassWith: 方法

 
 >> 
 
 // 获取类的类名
 const char * class_getName ( Class cls ); // 如果传入 的cls是nil, 则返回nil
 
 // 获取类的父类
 Class class_getSuperclass ( Class cls );
 
 // 判断给定的Class是否是一个元类
 BOOL class_isMetaClass ( Class cls );
 
 // 获取实例大小
 size_t class_getInstanceSize ( Class cls );

 
 >>
 // 获取类中指定名称实例成员变量的信息
 Ivar class_getInstanceVariable ( Class cls, const char *name );
 
 // 获取类成员变量的信息
 Ivar class_getClassVariable ( Class cls, const char *name );
 
 // 添加成员变量, 不能动态给已又的类添加成员变量
 // 动态添加必须在 objc_allocateClassPair 之后，objc_registerClassPair 之前
 BOOL class_addIvar ( Class cls, const char *name, size_t size, uint8_t alignment, const char *types );
 
 类型编码 https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1
 
 property编码 https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html#//apple_ref/doc/uid/TP40008048-CH101-SW6
 
 // 获取整个成员变量列表 使用结束需要 free()
 Ivar * class_copyIvarList ( Class cls, unsigned int *outCount );

 
 
 >>
 
 // 获取指定的属性
 objc_property_t class_getProperty ( Class cls, const char *name );
 
 // 获取属性列表  使用结束需要 free()
 objc_property_t * class_copyPropertyList ( Class cls, unsigned int *outCount );
 
 // 为类添加属性
 BOOL class_addProperty ( Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount );
 
 // 替换类的属性
 void class_replaceProperty ( Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount );

 
 
 >>
 // 添加方法 会覆盖父类的方法，不会取代本类中已经实现的方法，如果本类中有一个同名的实现方法则返回NO
 BOOL class_addMethod ( Class cls, SEL name, IMP imp, const char *types );
 
 // 获取实例方法
 Method class_getInstanceMethod ( Class cls, SEL name );
 
 // 获取类方法
 Method class_getClassMethod ( Class cls, SEL name );
 
 // 获取所有方法的数组  使用结束需要 free()
 Method * class_copyMethodList ( Class cls, unsigned int *outCount );
 
 // 替代方法的实现 ,若类中没有SEL name的方法，则会添加（此时类似class_addMethod）SEL name的方法
 IMP class_replaceMethod ( Class cls, SEL name, IMP imp, const char *types );
 
 // 返回方法的具体实现
 IMP class_getMethodImplementation ( Class cls, SEL name );
 IMP class_getMethodImplementation_stret ( Class cls, SEL name );
 
 // 类实例是否响应指定的selector
 BOOL class_respondsToSelector ( Class cls, SEL sel );
 
 
 >>
 // 添加协议
 BOOL class_addProtocol ( Class cls, Protocol *protocol );
 
 // 返回类是否实现指定的协议
 BOOL class_conformsToProtocol ( Class cls, Protocol *protocol );
 
 // 返回类实现的协议列表 使用结束需要 free()
 Protocol * class_copyProtocolList ( Class cls, unsigned int *outCount );
 
 
 
 >>
 // 获取版本号
 int class_getVersion ( Class cls );
 
 // 设置版本号
 void class_setVersion ( Class cls, int version );
 
 
 >>
 // 创建一个新类和元类 , superclass ＝ nil 则创建根类， extraBytes 通常为 0
 Class objc_allocateClassPair ( Class superclass, const char *name, size_t extraBytes );
 
 // 销毁一个类及其相关联的类
 void objc_disposeClassPair ( Class cls );
 
 // 在应用中注册由objc_allocateClassPair创建的类
 void objc_registerClassPair ( Class cls );
 
 
 >>
 // 创建类实例  ARC环境下无法调用此方法
 id class_createInstance ( Class cls, size_t extraBytes );
 
 // 在指定位置创建类实例
 id objc_constructInstance ( Class cls, void *bytes );
 
 // 销毁类实例
 void * objc_destructInstance ( id obj );
 
 
 
 >>
 // 返回指定对象的一份拷贝
 id object_copy ( id obj, size_t size );
 
 // 释放指定对象占用的内存
 id object_dispose ( id obj );
 
 
 >>
 // 修改类实例的实例变量的值
 Ivar object_setInstanceVariable ( id obj, const char *name, void *value );
 
 // 获取对象实例变量的值
 Ivar object_getInstanceVariable ( id obj, const char *name, void **outValue );
 
 // 返回指向给定对象分配的任何额外字节的指针
 void * object_getIndexedIvars ( id obj );
 
 // 返回对象中实例变量的值
 id object_getIvar ( id obj, Ivar ivar );
 
 // 设置对象中实例变量的值
 void object_setIvar ( id obj, Ivar ivar, id value );
 
 
 >>
 // 返回给定对象的类名
 const char * object_getClassName ( id obj );
 
 // 返回对象的类
 Class object_getClass ( id obj );
 
 // 设置对象的类
 Class object_setClass ( id obj, Class cls );

 
 
 >>
 // 获取已注册的类定义的列表
 int objc_getClassList ( Class *buffer, int bufferCount );
 
 // 创建并返回一个指向所有已注册类的指针列表  使用结束需要 free()
 Class * objc_copyClassList ( unsigned int *outCount );
 
 // 返回指定类的类定义
 Class objc_lookUpClass ( const char *name );
 Class objc_getClass ( const char *name );
 Class objc_getRequiredClass ( const char *name );
 
 // 返回指定类的元类
 Class objc_getMetaClass ( const char *name );
 
 
 

