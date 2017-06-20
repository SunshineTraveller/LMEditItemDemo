//
//  NSObject+Helper.m
//  WeiXingTianXia
//
//  Created by admin on 2017/4/5.
//  Copyright © 2017年 zhanglimin. All rights reserved.
//

#import "NSObject+Helper.h"

#import <objc/runtime.h>

static const int block_key;

@interface _YSNSObjectKVOBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(__weak id obj, id oldVal, id newVal);

- (id)initWithBlock:(void (^)(__weak id obj, id oldVal, id newVal))block;

@end

@implementation _YSNSObjectKVOBlockTarget

- (id)initWithBlock:(void (^)(__weak id obj, id oldVal, id newVal))block {
    self = [super init];
    if (self) {
        self.block = block;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (!self.block) return;
    
    BOOL isPrior = [[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue];
    if (isPrior) return;
    
    NSKeyValueChange changeKind = [[change objectForKey:NSKeyValueChangeKindKey] integerValue];
    if (changeKind != NSKeyValueChangeSetting) return;
    
    id oldVal = [change objectForKey:NSKeyValueChangeOldKey];
    id newVal = [change objectForKey:NSKeyValueChangeNewKey];
    
    self.block(object, [oldVal nullTonil], [newVal nullTonil]);
}

@end

@implementation NSObject(Helper)

+ (id)turnNullToNilForObject:(id)item
{
    if([item isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:item];
        for (NSString *key in [dic allKeys]) {
            id value = [dic objectForKey:key];
            id o = [self turnNullToNilForObject:value];
            if (o) {
                [dic setObject:o forKey:key];
            }
            else {
                [dic removeObjectForKey:key];
            }
        }
        return dic;
    }
    else if([item isKindOfClass:[NSArray class]]){
        NSMutableArray *arr= [NSMutableArray arrayWithArray:item];
        for (NSInteger i = [arr count]-1; i >= 0; i--) {
            id value = [arr objectAtIndex:i];
            id o = [self turnNullToNilForObject:value];
            if (o) {
                [arr replaceObjectAtIndex:i withObject:o];
            }
            else {
                [arr removeObjectAtIndex:i];
            }
        }
        return arr;
    }
    return [item nullTonil];
}
- (id)nullTonil
{
    if ([self isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return self;
}
- (id)objcetByRemoveNullObjects
{
    return [NSObject turnNullToNilForObject:self];
}
- (void)saveArchiveredObject:(NSObject *)object forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:object] forKey:key];
}
- (id)archiveredObjectForKey:(NSString *)key
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:key]];
}

+(void)perform:(void(^)())block1 withCompletionHandler:(void (^)())block2
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        block1();
        dispatch_async(dispatch_get_main_queue(),^{
            block2();
        });
    });
}
-(void)perform:(void(^)())block1 withCompletionHandler:(void (^)())block2
{
    [[self class] perform:block1 withCompletionHandler:block2];
}
+ (void)perform:(void(^)())block afterDelay:(NSTimeInterval)delay
{
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
    dispatch_after(when,
                   dispatch_get_main_queue(),
                   block);
}
- (void)perform:(void(^)())block afterDelay:(NSTimeInterval)delay
{
    [[self class] perform:block afterDelay:delay];
}

- (void)addObserverBlockForKeyPath:(NSString *)keyPath block:(void (^)(__weak id obj, id oldVal, id newVal))block {
    if (!keyPath || !block) return;
    _YSNSObjectKVOBlockTarget *target = [[_YSNSObjectKVOBlockTarget alloc] initWithBlock:block];
    NSMutableDictionary *dic = [self _ys_allNSObjectObserverBlocks];
    NSMutableArray *arr = dic[keyPath];
    if (!arr) {
        arr = [NSMutableArray new];
        dic[keyPath] = arr;
    }
    [arr addObject:target];
    [self addObserver:target forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}

- (void)removeObserverBlocksForKeyPath:(NSString *)keyPath {
    if (!keyPath) return;
    NSMutableDictionary *dic = [self _ys_allNSObjectObserverBlocks];
    NSMutableArray *arr = dic[keyPath];
    [arr enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        [self removeObserver:obj forKeyPath:keyPath];
    }];
}

- (void)removeObserverBlocks {
    NSMutableDictionary *dic = [self _ys_allNSObjectObserverBlocks];
    [dic enumerateKeysAndObjectsUsingBlock: ^(NSString *key, NSArray *arr, BOOL *stop) {
        [arr enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
            [self removeObserver:obj forKeyPath:key];
        }];
    }];
}

- (NSMutableDictionary *)_ys_allNSObjectObserverBlocks {
    NSMutableDictionary *targets = objc_getAssociatedObject(self, &block_key);
    if (!targets) {
        targets = [NSMutableDictionary new];
        objc_setAssociatedObject(self, &block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}

#pragma mark -
- (NSString *)jsonStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error) return json;
    }
    return nil;
}

- (NSString *)jsonPrettyStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error) return json;
    }
    return nil;
}

@end
