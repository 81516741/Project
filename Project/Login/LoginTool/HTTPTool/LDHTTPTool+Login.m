//
//  LDHTTPTool+Login.m
//  Project
//
//  Created by lingda on 2018/7/5.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "LDHTTPTool+Login.h"
#import "LDHTTPToolLoginConst.h"

@implementation LDHTTPTool (Login)

+ (void)getGetRequest:(LDHTTPModel *)model parameters:(NSDictionary *)parameters success:(void (^)(LDHTTPModel *))success failure:(void (^)(LDHTTPModel *))failure
{
    model = [LDHTTPTool decorate:model httpType:LDHTTPTypeGet url:kHTTPTestRequest parameters:parameters];
    [LDHTTPTool sendModel:model success:success failure:failure];
}

+ (void)imageUploadRequest:(LDHTTPModel *)model parameters:(NSDictionary *)parameters success:(void (^)(LDHTTPModel * response))success failure:(void (^)(LDHTTPModel * response))failure
{
    //1.装饰参数
    parameters =
    @{
      kLDHTTPRequestTokenKey :@"e72807fc-45f8-4d00-afd2-c04f36ae1e24"
      };
    NSString *urlStr = [NSString stringWithFormat:@"%@?sign=%@",kHTTPUploadPicRequest,[[self jsonStringFrom:parameters] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    model = [self decorate:model httpType:LDHTTPTypeUploadImage url:urlStr parameters:parameters];
    
    NSArray * imageParamsArr = [LDHTTPTool imageParamsArr:
                                @{
                                  @"avatar":[UIImage imageNamed:@"logo.png"]
                                  }];
    model.imageParameters = imageParamsArr;
    
    [LDHTTPTool sendModel:model success:success failure:failure];
}

@end
