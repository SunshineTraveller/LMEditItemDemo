//
//  MoveItemCell.m
//  test
//
//  Created by CBCT_MBP on 2020/7/23.
//  Copyright © 2020 zgcx. All rights reserved.
//

#import "MoveItemCell.h"

@implementation MoveItemCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.2];
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = UIColor.blackColor.CGColor;
        self.layer.borderWidth = 0.5f;
        
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        _title.textColor = UIColor.blackColor;
        _title.font = [UIFont systemFontOfSize:16];
        _title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_title];
        
//        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(UIEdgeInsetsZero);
//        }];
    }
    return self;
}

@end
