//
//  HTTPTool.h
//  btc
//
//  Created by lingda on 2017/8/25.
//  Copyright © 2017年 btc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDHTTPModel.h"
#import "LDHTTPConst.h"


@interface LDHTTPTool : NSObject
/**
 发送请求
 */
+(void)sendModel:(LDHTTPModel *)message success:(void (^)(LDHTTPModel * responseObject))success failure:(void (^)(LDHTTPModel * responseObject))failure;

/**
 * 取消请求
 */
+(void)cancelHTTPTask:(NSString *)taskDescription;
/**
 * 取消某个控制器的请求
 */
+(void)cancelHTTPTasksByViewControllerName:(NSString *)viewControllerName;

/**
 装饰模型
 */
+ (LDHTTPModel *)decorate:(LDHTTPModel *)model httpType:(LDHTTPType)httpType url:(NSString *)url parameters:(NSDictionary *)parameters;

/**
 上传图片封装数据用的
 */
+ (NSArray *)imageParamsArr:(NSDictionary *)imageDic;

/**
 字典转json字符串
 */
+(NSString *)jsonStringFrom:(NSDictionary *)dic;

/**
 登录请求，登录请求必须放在LDHTTPTool这里，因为如果是有token失效，
 需要重新更新token的app，放在这里最合适，不放在中间件里面是因为，
 我不希望LDHTTP和别模块的产生关联
 */
+ (void)loginRequest:(LDHTTPModel *)model parameters:(NSDictionary *)parameters success:(void (^)(LDHTTPModel * response))success failure:(void (^)(LDHTTPModel * response))failure;

@end
