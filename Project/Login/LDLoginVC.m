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
#import "LDHTTPTool+Login.h"

@interface LDLoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *countField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LDLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ld_hideNavigationBar = YES;
}

- (IBAction)clickLoginBtn:(UIButton *)sender {
    LDHTTPModel * request = [LDHTTPModel model:@"登录"
                                        VCName:@"LDLoginVC"
                                     dataClass:nil];
    NSDictionary * parameters = @{
                                  @"count":self.countField.text,
                                  @"password":self.passwordField.text
                                  };
    [LDHTTPTool loginRequest:request parameters:parameters success:^(LDHTTPModel *response) {
        [self dismissViewControllerAnimated:YES completion:nil];
        if (self.ld_loginSuccessBlock) {
            self.ld_loginSuccessBlock(@{@"key":@"value"});
        }
    } failure:^(LDHTTPModel *response) {
        
    }];
}
- (IBAction)clickForgetPassword:(UIButton *)sender {
    [LDHTTPTool imageUploadRequest:[LDHTTPModel model:@"上传图片" VCName:@"LDLoginVC" dataClass:nil] parameters:nil success:^(LDHTTPModel *response) {
        
    } failure:^(LDHTTPModel *response) {
        
    }];
}

- (IBAction)clickRegister:(UIButton *)sender {
    //模拟的一个请求
    [LDHTTPTool getGetRequest:[LDHTTPModel model:@"test请求" VCName:@"LDLoginVC" dataClass:nil] parameters:@{@"lingda":@"shuai"} success:^(LDHTTPModel *response) {
        
    } failure:^(LDHTTPModel *response) {
        
    }];
}

- (IBAction)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
