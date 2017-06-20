//
//  NSObject+Helper.h
//  WeiXingTianXia
//
//  Created by admin on 2017/4/5.
//  Copyright © 2017年 zhanglimin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Helper)
#pragma mark - remove null objects for array、dictionary
//把传进来的数据为NSNull的对象移除
- (id)nullTonil;
- (id)objcetByRemoveNullObjects;

- (void)saveArchiveredObject:(NSObject *)object forKey:(NSString *)key;
- (id)archiveredObjectForKey:(NSString *)key;

#pragma mark - block
//perform block1 in main thread,when finished perform block2 in background
+(void)perform:(void(^)())block1 withCompletionHandler:(void (^)())block2;
-(void)perform:(void(^)())block1 withCompletionHandler:(void (^)())block2;

//n秒后执行block
+ (void)perform:(void(^)())block afterDelay:(NSTimeInterval)delay;
- (void)perform:(void(^)())block afterDelay:(NSTimeInterval)delay;

#pragma mark - KVO
- (void)addObserverBlockForKeyPath:(NSString*)keyPath block:(void (^)(__weak id obj, id oldVal, id newVal))block;
- (void)removeObserverBlocksForKeyPath:(NSString*)keyPath;
- (void)removeObserverBlocks;

#pragma mark - JSON

/**
 Convert object to json string. return nil if an error occurs.
 NSString/NSNumber/NSDictionary/NSArray
 */
- (NSString *)jsonStringEncoded;

/**
 Convert object to json string formatted. return nil if an error occurs.
 */
- (NSString *)jsonPrettyStringEncoded;

+ (id)turnNullToNilForObject:(id)item;
@end
