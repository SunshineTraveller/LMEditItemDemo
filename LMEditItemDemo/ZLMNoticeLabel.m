//
//  ZLMNoticeLabel.m
//  CharmLife
//
//  Created by 60az on 16/8/23.
//  Copyright © 2016年 60az. All rights reserved.
//

#import "ZLMNoticeLabel.h"

@interface ZLMNoticeLabel ()

@end

@implementation ZLMNoticeLabel

+(instancetype)message:(NSString *)message delaySecond:(CGFloat)second{

    CGFloat kwid = [UIScreen mainScreen].bounds.size.width;
    CGFloat khei = [UIScreen mainScreen].bounds.size.height;
    
    dispatch_queue_t queue = dispatch_queue_create("ZLMNoticeLabelQueue", nil);
    dispatch_async(queue, ^{
        
    });
    
    ZLMNoticeLabel *_labelView = nil;
    if (_labelView == nil) {
        
       UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        label.backgroundColor = [UIColor clearColor];
        label.text = message;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        CGFloat wid = [label.text boundingRectWithSize:CGSizeMake(kwid/4*3, 33) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size.width;
        CGFloat hei = [label.text boundingRectWithSize:CGSizeMake(wid, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size.height;
        [label setFrame:CGRectMake(10, 10, wid, hei)];
        
        _labelView = [[ZLMNoticeLabel alloc] initWithFrame:CGRectMake(kwid/2-wid/2, khei/2-hei/2, wid+20, hei+20)];
        [_labelView addSubview:label];
        _labelView.backgroundColor = [UIColor blackColor];
        _labelView.alpha = 0.7;
        _labelView.layer.cornerRadius = 8;
        _labelView.clipsToBounds = YES;
        
    }
    [_labelView removeFromItsSuperView:_labelView second:second];
    Class previousClass = [[NSUserDefaults standardUserDefaults] objectForKey:@"LMNOTICELABELSUPERCLASS"];
    Class superClass = [_labelView.superview class];
    if (previousClass == superClass) {
        
    }
    [[NSUserDefaults standardUserDefaults] setObject:superClass forKey:@"LMNOTICELABELSUPERCLASS"];
    return _labelView;
}

-(void)removeFromItsSuperView:(ZLMNoticeLabel *)labelView second:(CGFloat)second{
    
    __weak typeof(labelView) weakSelf = labelView;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf removeFromSuperview];
        });
    
}


@end
