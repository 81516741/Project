//
//  LDLoginVC.m
//  MainArch_Example
//
//  Created by 令达 on 2018/4/4.
//  Copyright © 2018年 81516741@qq.com. All rights reserved.
//

#import "LDLoginVC.h"
#import "UIViewController+LDNaviBar.h"
#import "UIViewController+LDLogin.h"
#import "LDHTTPToolLogin.h"

@interface LDLoginVC ()

@end

@implementation LDLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ld_hideNavigationBar = YES;
}

- (IBAction)clickLoginBtn:(UIButton *)sender {
    //模拟的一个请求
    [LDHTTPToolLogin getAgreementRequest:[LDHTTPModel model:@"请求法律与协议h5" VCName:@"LDLoginVC" dataClass:nil] parameters:nil success:^(LDHTTPModel *response) {
        [self dismissViewControllerAnimated:YES completion:nil];
        if (self.ld_loginSuccessBlock) {
            self.ld_loginSuccessBlock(@{@"key":@"value"});
        }
    } failure:^(LDHTTPModel *response) {
        
    }];
}
- (IBAction)clickForgetPassword:(UIButton *)sender {
    [LDHTTPToolLogin imageUploadRequest:[LDHTTPModel model:@"上传图片" VCName:@"LDLoginVC" dataClass:nil] parameters:nil success:^(LDHTTPModel *response) {
        
    } failure:^(LDHTTPModel *response) {
        
    }];
}


- (IBAction)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
