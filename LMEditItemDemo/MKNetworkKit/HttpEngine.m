//
//  HttpEngine.m
//  WeiXingTianXia
//
//  Created by admin on 2017/4/5.
//  Copyright © 2017年 zhanglimin. All rights reserved.
//

#import "HttpEngine.h"
#import "NSObject+Helper.h"

@implementation HttpEngine
DEFINE_SINGLETON_FOR_CLASS(HttpEngine)
- (instancetype)init
{
    self = [super initWithHostName:HOSTSERVERURL];
    DLog(@"****%@****",HOSTSERVERURL);
    if (self) {
        self.reachabilityChangedHandler = ^(NetworkStatus status){
            if (status != NotReachable) {
                //网络可用
            }
            else {
                //网络不可用
            }
        };
    }
    return self;
}

- (void)startOperation:(MKNetworkOperation *)op s:(MKNKResponseBlock)s f:(MKNKResponseErrorBlock)f
{
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
#ifdef DEBUG
        NSDictionary *dic = [completedOperation responseJSON];
        if (dic) {
            //            NSLog(@"%@",dic);
            //            NSLog(@"%@",[completedOperation responseString]);
        }
        else
        {
            //            NSLog(@"%@",[completedOperation responseString]);
        }
        NSLog(@"%@",completedOperation);
#endif
        if (s) {
            s(completedOperation);
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
#ifdef DEBUG
        // showAlert([error description]);
#endif
        if (f) {
            f(completedOperation,error);
        }
    }];
    [self enqueueOperation:op];
}
//有图片
- (MKNetworkOperation *)startOperationWitPath:(NSString *)string imageDatds:(NSArray *)imageData imageKey:(NSString *)key params:(NSDictionary *)param s:(MKNKResponseBlock)s f:(MKNKResponseErrorBlock)f andNSnineger:(NSInteger)integer{
    MKNetworkOperation *op = [self operationWithPath:string params:param httpMethod:@"POST"];
    
    if (integer == 0) {
        [imageData enumerateObjectsUsingBlock:^(NSData  *obj, NSUInteger idx, BOOL * _Nonnull stop){
            NSString *nowKey = [NSString stringWithFormat:@"file%ld",idx];
            if (key) {
                nowKey = key;
            }
            NSString *fileName = [NSString stringWithFormat:@"%@.png",nowKey];
            [op addData:obj forKey:@"file[]" mimeType:@"image/png" fileName:fileName];
        }];
        //    [op.fieldsToBePosted setValue:op.dataToBePosted forKey:@"file"];
        [self startOperation:op s:s f:f];
        return op;
    }else{
        [imageData enumerateObjectsUsingBlock:^(NSData  *obj, NSUInteger idx, BOOL * _Nonnull stop){
            NSString *nowKey;
            if (idx == 0) {
                nowKey = @"headFile";
            }else{
                nowKey = @"bannerFile";
            }
            //        NSString *nowKey = @"file";
            
            if (key) {
                nowKey = key;
            }
            NSString *fileName = [NSString stringWithFormat:@"%@.png",nowKey];
            [op addData:obj forKey:nowKey mimeType:@"image/png" fileName:fileName];
        }];
        //    [op.fieldsToBePosted setValue:op.dataToBePosted forKey:@"file"];
        [self startOperation:op s:s f:f];
        return op;
    }
}

//没图片
- (MKNetworkOperation *)startOperationWithPath:(NSString *)string type:(RequestType)type params:(NSDictionary *)param s:(MKNKResponseBlock)s f:(MKNKResponseErrorBlock)f
{
    NSString *requestType;
    switch (type) {
        case 0:
            requestType = @"GET";
            break;
        case 1:
            requestType = @"POST";
            break;
        default:
            break;
    }
    MKNetworkOperation *op = [self operationWithPath:string params:param httpMethod:requestType];
    [self startOperation:op s:s f:f];
    return op;
}



-(MKNetworkOperation *)lm_AllApplicationsWithID:(NSString *)memberid Success:(MKNKResponseBlock)response error:(MKNKResponseErrorBlock)error {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValueReal:memberid forKey:@"memberid"];
    return [self startOperationWithPath:@"systemadmin.php/app/module/index" type:RequestTypeGet params:param s:response f:error];
}

-(MKNetworkOperation *)lm_setAllAppOrderWithID:(NSString *)memberid data:(NSString *)data success:(MKNKResponseBlock)response error:(MKNKResponseErrorBlock)error {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValueReal:memberid forKey:@"memberid"];
    [param setValueReal:data forKey:@"data"];
    return [self startOperationWithPath:@"systemadmin.php/app/Module/add" type:RequestTypePost params:param s:response f:error];
    
}

+ (id)getUserData:(NSString *)name
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:name];
}

+ (void)setUserData:(id)value name:(NSString *)name
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:name];
    [defaults synchronize];
}

@end

@implementation MKNetworkOperation(null)

- (id)responseJSONRemoveNull
{
    id result = [self responseJSON];
    return [NSObject turnNullToNilForObject:result];
}

@end

@implementation NSArray(exception)

- (id)objectForKey:(NSString *)key
{
    return nil;
}
- (id)objectForKeyedSubscript:(id)key
{
    return nil;
}
@end

@implementation NSMutableDictionary(turnNil)

- (void)setValueReal:(id)value forKey:(NSString *)key
{
    if (value) {
        [self setValue:value forKey:key];
    }
}


@end
