//
//  WXHome_AllAppModel.m
//  WeiXingTianXia
//
//  Created by sunshine on 2017/3/21.
//  Copyright © 2017年 zhanglimin. All rights reserved.
//

#import "WXHome_AllAppModel.h"

@implementation WXHome_AllAppModel

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                      @"fid":@"id"
                                                      }];
}

+(BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}


@end
