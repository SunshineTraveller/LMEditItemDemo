//
//  ViewController.m
//  LMEditItemDemo
//
//  Created by sunshine on 2017/6/20.
//  Copyright © 2017年 zhanglimin. All rights reserved.
//

#import "MoveItemController.h"
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
    [btn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [btn setTitle:@"点击进入测试" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

-(void)btnSelectAction:(UIButton *)btn {
    
    
    MoveItemController *sortVC = [[MoveItemController alloc] init];
    [self.navigationController pushViewController:sortVC animated:NO];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
