//
//  WX_HomeSectionOneModel.h
//  WeiXingTianXia
//
//  Created by sunshine on 2017/3/31.
//  Copyright © 2017年 zhanglimin. All rights reserved.
//

#import "JSONModel.h"

@class WXHome_AllAppModel;
@interface WX_HomeSectionOneModel : JSONModel

@property (nonatomic,copy) WXHome_AllAppModel  *one;
@property (nonatomic,copy) WXHome_AllAppModel  *two;
@property (nonatomic,copy) WXHome_AllAppModel  *three;
@property (nonatomic,copy) WXHome_AllAppModel  *four;
@property (nonatomic,copy) WXHome_AllAppModel  *five;

@end
