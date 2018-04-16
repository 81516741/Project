//
//  LDHTTPToolLogin.h
//  Project
//
//  Created by 令达 on 2018/4/11.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "LDHTTPTool.h"
#import "LDHTTPToolLoginConst.h"

@interface LDHTTPToolLogin : LDHTTPTool
+ (void)getAgreementRequest:(LDHTTPModel *)model parameters:(NSDictionary *)parameters success:(void (^)(LDHTTPModel * response))success failure:(void (^)(LDHTTPModel * response))failure;

+ (void)imageUploadRequest:(LDHTTPModel *)model parameters:(NSDictionary *)parameters success:(void (^)(LDHTTPModel * response))success failure:(void (^)(LDHTTPModel * response))failure;
@end
