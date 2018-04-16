//
//  LDMediator+Login.m
//  MainArch
//
//  Created by 令达 on 2018/4/4.
//

#import "LDMediator+Login.h"

NSString  * const kLDMediatorTargetLogin = @"Login";
NSString  * const kLDMediatorActionNativeFetchLoginVC = @"nativeFetchModuleLoginVC";
NSString  * const kLDMediatorActionCreateLoginTables = @"nativeCreateModuleLoginDBTables";

@implementation LDMediator (Login)

- (id)_performAction:(NSString *)action params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCache
{
    return [self performTarget:kLDMediatorTargetLogin action:action params:params shouldCacheTarget:shouldCache];
}

- (UINavigationController *)login_getLoginController
{
    UIViewController *viewController = [self _performAction:kLDMediatorActionNativeFetchLoginVC
                                                    params:nil
                                         shouldCacheTarget:NO
                                        ];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:viewController];
        return navi;
    } else {
        return nil;
    }
}

- (void)login_createModuleLoginTables
{
    [self _performAction:kLDMediatorActionCreateLoginTables params:nil shouldCacheTarget:NO];
}
@end
