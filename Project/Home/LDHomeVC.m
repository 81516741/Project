//
//  LDHomeVC.m
//  MainArch_Example
//
//  Created by 令达 on 2018/3/26.
//  Copyright © 2018年 81516741@qq.com. All rights reserved.
//

#import "LDHomeVC.h"
#import "LDOtherVC.h"
#import "UIViewController+LDNaviBar.h"
#import "LDFunctionTool.h"

@interface LDHomeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation LDHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self ld_setNaviBarRightItemText:@"需要登录的跳转" color:[UIColor redColor] sel:@selector(jumpNeedLogin)];
    self.ld_naviBarColor = [UIColor whiteColor];
    self.ld_naviBarColor = [UIColor orangeColor];
}

- (IBAction)jump:(id)sender {
    UIViewController * vc = [LDOtherVC new];
     [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpNeedLogin
{
    [LDFunctionTool gotoFunctionByCode:LDFunctionOtherVC inVC:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"indexPath.row---%ld",(long)indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
