//
//  LDHTTPTool+Login.h
//  Project
//
//  Created by lingda on 2018/7/5.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "LDHTTPTool.h"

@interface LDHTTPTool (Login)
+ (void)getGetRequest:(LDHTTPModel *)model parameters:(NSDictionary *)parameters success:(void (^)(LDHTTPModel * response))success failure:(void (^)(LDHTTPModel * response))failure;

+ (void)imageUploadRequest:(LDHTTPModel *)model parameters:(NSDictionary *)parameters success:(void (^)(LDHTTPModel * response))success failure:(void (^)(LDHTTPModel * response))failure;
@end
