//
//  WXHome_AllAppModel.h
//  WeiXingTianXia
//
//  Created by sunshine on 2017/3/21.
//  Copyright © 2017年 zhanglimin. All rights reserved.
//

#import "JSONModel.h"

@interface WXHome_AllAppModel : JSONModel

@property (nonatomic,copy) NSString  *moduleName;
@property (nonatomic,copy) NSString  *fid;
@property (nonatomic,copy) NSString  *moduleID;
@property (nonatomic,copy) NSString  *parentID;
@property (nonatomic,copy) NSString  *orders;


@end
