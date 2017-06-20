//
//  ViewController.m
//  LMEditItemDemo
//
//  Created by sunshine on 2017/6/20.
//  Copyright © 2017年 zhanglimin. All rights reserved.
//

#import "WXHome_AllAppViewController.h"
#import "UIColorString.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"测试";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 150, 44);
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitleColor:[UIColorString colorWithHexString:@"ef9e49"] forState:UIControlStateNormal];
    [btn setTitle:@"点击进入测试" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

-(void)btnSelectAction:(UIButton *)btn {
    
    
    WXHome_AllAppViewController *sortVC = [[WXHome_AllAppViewController alloc] init];
    [self.navigationController pushViewController:sortVC animated:NO];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
