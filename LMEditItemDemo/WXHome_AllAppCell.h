//
//  WXHome_AllAppCell.h
//  WeiXingTianXia
//
//  Created by sunshine on 2017/3/21.
//  Copyright © 2017年 zhanglimin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WXHome_AllAppModel;
@interface WXHome_AllAppCell : UICollectionViewCell

@property (nonatomic,strong) UIButton *content;

@property (nonatomic,strong) WXHome_AllAppModel *model;
@end
