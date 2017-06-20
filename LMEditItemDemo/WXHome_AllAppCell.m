//
//  WXHome_AllAppCell.m
//  WeiXingTianXia
//
//  Created by sunshine on 2017/3/21.
//  Copyright © 2017年 zhanglimin. All rights reserved.
//
#define SCREENWIDTH         [UIScreen mainScreen].bounds.size.width
#define WIDTHCOUNT          SCREENWIDTH/375

#import "WXHome_AllAppModel.h"
#import "WXHome_AllAppCell.h"

@implementation WXHome_AllAppCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.layer.cornerRadius = 14;
        self.clipsToBounds = YES;
        [self.contentView addSubview:self.content];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
-(void)setModel:(WXHome_AllAppModel *)model {
    
    _model = model;
    self.clipsToBounds = YES;
    [self.content setTitle:model.moduleName forState:UIControlStateNormal];
    
}

-(UIButton *)content {
    
    CGFloat btnW = (SCREENWIDTH-40*WIDTHCOUNT-3*8*WIDTHCOUNT)/4;
    CGFloat btnH = 44*WIDTHCOUNT;
    if (_content == nil) {
        _content = [UIButton buttonWithType:UIButtonTypeCustom];
        _content.frame = CGRectMake(0, 0, btnW, btnH);
        [_content setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _content.titleLabel.font = [UIFont systemFontOfSize:13];
        _content.layer.cornerRadius = 14;
        _content.clipsToBounds = YES;
        
    }
    return _content;
}


@end
