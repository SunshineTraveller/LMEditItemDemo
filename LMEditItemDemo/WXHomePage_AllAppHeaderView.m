//
//  WXHomePage_AllAppHeaderView.m
//  WeiXingTianXia
//
//  Created by sunshine on 2017/3/21.
//  Copyright © 2017年 zhanglimin. All rights reserved.
//
#define SCREENWIDTH         [UIScreen mainScreen].bounds.size.width
#define WIDTHCOUNT          SCREENWIDTH/375


#import "WXHomePage_AllAppHeaderView.h"

@implementation WXHomePage_AllAppHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.sectionTitle];
        [self addSubview:self.yellowBar];
        [self addSubview:self.sep];
    }
    return self;
}

-(UIButton *)yellowBar {
    if (_yellowBar == nil) {
        _yellowBar = [UIButton buttonWithType:UIButtonTypeCustom];
        _yellowBar.frame = CGRectMake(10*WIDTHCOUNT, 0, 4*WIDTHCOUNT, 44*WIDTHCOUNT);
        _yellowBar.imageEdgeInsets = UIEdgeInsetsMake(14.5*WIDTHCOUNT, 0, 14.5*WIDTHCOUNT, 0);
        [_yellowBar setImage:[UIImage imageNamed:@"allapp_yellowbar"] forState:UIControlStateNormal];
        _yellowBar.backgroundColor = [UIColor clearColor];
    }
    return _yellowBar;
}

-(UILabel *)sectionTitle {
    if (_sectionTitle == nil) {
        _sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.yellowBar.frame.origin.x+self.yellowBar.frame.size.width+5*WIDTHCOUNT, 0, 150*WIDTHCOUNT, 44*WIDTHCOUNT)];
        _sectionTitle.textColor = [UIColor blackColor];
        _sectionTitle.backgroundColor = [UIColor clearColor];
        _sectionTitle.font = [UIFont systemFontOfSize:15.0];
    }
    return _sectionTitle;
}

-(UILabel *)sep {
    if (_sep == nil) {
        _sep = [[UILabel alloc] initWithFrame:CGRectMake(0, 44*WIDTHCOUNT, SCREENWIDTH, 1)];
        _sep.backgroundColor = [UIColor lightGrayColor];

    }
    return _sep;
}

@end
