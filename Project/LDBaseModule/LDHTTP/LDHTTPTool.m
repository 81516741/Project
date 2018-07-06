//
//  HTTPTool.m
//  btc
//
//  Created by lingda on 2017/8/25.
//  Copyright © 2017年 btc. All rights reserved.


#import "LDHTTPTool.h"
#import "LDHTTPManager.h"


NSMutableDictionary * taskDescriptions;

@implementation LDHTTPTool

#pragma mark - public method
+(void)sendModel:(LDHTTPModel *)model success:(void (^)(LDHTTPModel * responseObject))success failure:(void (^)(LDHTTPModel * responseObject))failure
{
    if (taskDescriptions == nil) {
        taskDescriptions = [NSMutableDictionary dictionary];
    }
    if (model.VCName != nil  && model.taskDescription != nil) {
        [taskDescriptions setObject:model.VCName forKey:model.taskDescription];
    }
    //打印请求信息
    NSLog(@"[发起请求的类:%@][请求描述:%@][请求URL:%@][请求参数:%@]",model.VCName,model.taskDescription,[model.url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[model.parameters description]);
    [LDHTTPTool cancelHTTPTask:model.taskDescription];//每次请求前先取消相同描述的请求
    [[LDHTTPManager shared] sendMessage:model success:^(LDHTTPModel *responseObject) {
        //打印回调信息
        NSLog(@"[发起请求的类:%@][请求描述:%@][请求URL:%@][请求参数:%@][服务器返回的数据:%@]",responseObject.VCName,responseObject.taskDescription,[responseObject.url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[responseObject.parameters description],responseObject.dataOrigin);
        
        responseObject.status = [responseObject.dataOrigin[@"code"] integerValue];//这里用0代表成功
        
        switch (responseObject.status) {
            case 0://代表成功
            {
                if (success) {
                    if (responseObject.dataClass != nil) {//转模型
                        
                        
                    }
                    success(responseObject);
                }
            }
                break;
            case 402://代表token失效
            {
                //调用重新登录接口 拿到新的token 然后在发起该请求
                NSLog(@"token失效 421，重新发起登录更新token");
                //判断是否已经更新了token
                if([LDHTTPManager shared].updateToken){
                    [LDHTTPTool updateHttpModel:responseObject token:[LDHTTPManager shared].tokenNew];
                    [LDHTTPTool sendModel:responseObject success:success failure:failure];
                    return ;
                }
                //将要发的请求保存先
                LDHTTPUpdateTokenModel * updateTokenModel = [LDHTTPUpdateTokenModel new];
                responseObject.errorOfMy = @"token失效";
                updateTokenModel.httpModel = responseObject;
                updateTokenModel.success = success;
                updateTokenModel.failure = failure;
                [[LDHTTPManager shared].updateTokenRequests addObject:updateTokenModel];
                //如果有请求在获取新的token，就不用发请求了
                if([LDHTTPManager shared].updateTokenRequests.count > 1){
                    return ;
                }
                LDHTTPModel * loginRequestModel = [LDHTTPModel model:@"调用登录接口更新token" VCName:@"无" dataClass:nil];
                NSDictionary * parameters =  @{
                                               @"账号":@"xxx",
                                               @"密码":@"xxx"
                                               };
                [LDHTTPTool loginRequest:loginRequestModel parameters:parameters success:^(LDHTTPModel *response){
                    NSLog(@"调登录接口更新token，获取新的token成功");
                    NSString * tokenNew = @"new token";
                    //1.更新本地数据库登录模型
                    //这里是要写的代码...
                    [LDHTTPManager shared].updateToken = YES;
                    [LDHTTPManager shared].tokenNew = @"tokenNew";
                    
                    //2.将未发送的请求一次发送完
                    for (LDHTTPUpdateTokenModel * updateTokenModel in [LDHTTPManager shared].updateTokenRequests) {
                        [LDHTTPTool updateHttpModel:updateTokenModel.httpModel token:tokenNew];
                        [LDHTTPTool sendModel:updateTokenModel.httpModel success:updateTokenModel.success failure:updateTokenModel.failure];
                    }
                    //3.移除所有model
                    [[LDHTTPManager shared].updateTokenRequests removeAllObjects];
                    
                } failure:^(LDHTTPModel *response) {//重新获取token失败
                    NSLog(@"调登录接口更新token，更新token失败，失败原因：%@",response.errorOfMy);
                    //所有的请求执行失败的回调
                    for (LDHTTPUpdateTokenModel * updateTokenModel in [LDHTTPManager shared].updateTokenRequests) {
                        if (updateTokenModel.failure) {
                            updateTokenModel.failure(updateTokenModel.httpModel);
                        }
                    }
                    //移除所有model
                    [[LDHTTPManager shared].updateTokenRequests removeAllObjects];
                    
                }];
            }
                break;
            
            default:
                break;
        }
        
    } failure:^(LDHTTPModel * responseObject) {
        NSLog(@"服务器返回的错误:%@",responseObject.errorOfAFN);
        NSString * errorStr = responseObject.errorOfAFN.userInfo[NSLocalizedDescriptionKey];
        if([errorStr isEqualToString:@"cancelled"]) {
            NSLog(@"[发起请求的类:%@][请求描述:%@][请求取消]",responseObject.VCName,responseObject.taskDescription);
            if (failure) {
                responseObject.errorOfMy = @"请求取消";
                failure(responseObject);
            }
            return ;
        }
        if (failure) {
            responseObject.errorOfMy = [responseObject.errorOfAFN description];
            failure(responseObject);
        }
    }];
}


+(void)cancelHTTPTask:(NSString *)taskDescription
{
    [[LDHTTPManager shared] cancelHTTPTask:taskDescription];
}

+(void)cancelHTTPTasksByViewControllerName:(NSString *)viewControllerName
{
    [taskDescriptions enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * obj, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:viewControllerName]) {
            [LDHTTPTool cancelHTTPTask:key];
            [taskDescriptions removeObjectForKey:key];
        }
    }];
}

+ (void)updateHttpModel:(LDHTTPModel *)httpModel token:(NSString *)tokenNew
{
    NSString * tokenOld = httpModel.token;
    //1.更新原来的请求参数中的token
    if (httpModel.parameters != nil) {//参数是放在parameters里面的
        NSMutableDictionary * parameters = httpModel.parameters;
        NSString * signValueStrOld = @"jsonString";
        NSString * signValueStrNew = [signValueStrOld stringByReplacingOccurrencesOfString:tokenOld withString:tokenNew];
        [parameters setObject:signValueStrNew forKey:@"sign"];
        httpModel.parameters = parameters;
    } else {//参数是拼接在URL后面的
        NSString * tokenOldEncode = [tokenOld stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString * tokenNewEncode = [tokenNew stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        httpModel.url = [httpModel.url stringByReplacingOccurrencesOfString:tokenOldEncode withString:tokenNewEncode];
    }
}

+ (NSArray *)imageParamsArr:(NSDictionary *)imageDic
{
    __block int i = 0;
    NSMutableArray * imageParamsArr = [NSMutableArray array];
    [imageDic enumerateKeysAndObjectsUsingBlock:^(NSString * imageName, UIImage * image, BOOL * stop) {
        NSMutableDictionary * paramsDic = [NSMutableDictionary dictionary];
        NSData * imageData = UIImageJPEGRepresentation(image, 0.9);
        NSString * name = imageName;
        NSString * filename = [NSString stringWithFormat:@"picture%d.png",i++];
        NSString * mimeType = @"image/png";
        
        [paramsDic setValue:imageData forKey:kLDHTTPImageUploadImageDataKey];
        [paramsDic setValue:name forKey:kLDHTTPImageUploadImageNameKey];
        [paramsDic setValue:filename forKey:kLDHTTPImageUploadFileNameKey];
        [paramsDic setValue:mimeType forKey:kLDHTTPImageUploadMimeTypeKey];
        
        [imageParamsArr addObject:paramsDic];
    }];
    return imageParamsArr;
}

+(NSString *)jsonStringFrom:(NSDictionary *)dic
{
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonStr;
}

+ (LDHTTPModel *)decorate:(LDHTTPModel *)model httpType:(LDHTTPType)httpType url:(NSString *)url parameters:(NSDictionary *)parameters
{
    NSAssert(model != nil, @"网络请求model不能为nil");
    model.httpType = httpType;
    model.url = url;
    if (parameters) {
        NSString * token = parameters[kLDHTTPRequestTokenKey];
        if (token.length > 0) {
            model.token = token;
        }
        model.parameters = @{@"sign":[self jsonStringFrom:parameters]};
    }
    return model;
}

#pragma mark - all request method
+ (void)loginRequest:(LDHTTPModel *)model parameters:(NSDictionary *)parameters success:(void (^)(LDHTTPModel *))success failure:(void (^)(LDHTTPModel *))failure
{
    //1.装饰参数
    parameters =
    @{
        #if TARGET_IPHONE_SIMULATOR
        @"deviceToken":kLDHTTPRequestSimulatorString,
        #elif TARGET_OS_IPHONE
        @"deviceToken":@"deviceTokenReal",
        #endif
        @"parameters":parameters
    };
    //2.装饰请求模型
    model = [LDHTTPTool decorate:model httpType:LDHTTPTypePost url:kHTTPLoginRequest parameters:parameters];
    //3.发送请求
    [LDHTTPTool sendModel:model success:success failure:failure];
}

@end
