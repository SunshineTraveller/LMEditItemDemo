//
//  HttpEngine.h
//  WeiXingTianXia
//
//  Created by admin on 2017/4/5.
//  Copyright © 2017年 zhanglimin. All rights reserved.
//


#define DEFINE_SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className

#define DEFINE_SINGLETON_FOR_CLASS(className)\
\
+ (className *)shared##className { \
static className *shared##className =nil;\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
shared##className = [[self alloc]init];\
}); \
return shared##className; \
}


#define DEBUG2
#ifdef DEBUG2

//测试接口
#define HOSTSERVERURL   @"m.minbingtuan.cn"

#else


#endif
#import "MKNetworkEngine.h"

typedef NS_ENUM(NSInteger, RequestType)
{
    RequestTypeGet = 0,
    RequestTypePost,
    
};
@class WX_SecondHouseFilterModel;
@interface HttpEngine : MKNetworkEngine
DEFINE_SINGLETON_FOR_HEADER(HttpEngine);

/**
 所有应用接口

 @param response 成功回调
 @param error 失败回调
 @return MKNetworkOperation
 */
-(MKNetworkOperation *)lm_AllApplicationsWithID:(NSString *)memberid Success:(MKNKResponseBlock)response error:(MKNKResponseErrorBlock)error;



/**
 所有应用排序
 
 @param memberid id
 @param response 成功回调
 @param error 失败回调
 @return MKNetworkOperation
 */
-(MKNetworkOperation *)lm_setAllAppOrderWithID:(NSString *)memberid data:(NSString *)data success:(MKNKResponseBlock)response error:(MKNKResponseErrorBlock)error;



+ (id)getUserData:(NSString *)name;

+ (void)setUserData:(id)value name:(NSString *)name;


@end

@interface MKNetworkOperation(null)
- (id)responseJSONRemoveNull;
@end

//防止数组调用[@"key"]崩溃
@interface NSArray(exception)
- (id)objectForKey:(NSString *)key;
- (id)objectForKeyedSubscript:(id)key;
@end

@interface NSMutableDictionary(turnNil)
- (void)setValueReal:(id)value forKey:(NSString *)key;
@end

















