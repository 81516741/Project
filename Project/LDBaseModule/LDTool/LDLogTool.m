//
//  LDLogTool.m
//  Project
//
//  Created by 令达 on 2018/4/8.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "LDLogTool.h"
#import "CocoaLumberjack.h"

@implementation LDLogTool

+ (void)configDDLog
{
    //输出到控制台
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    //输出到本地
    NSString * documentsDDLog = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"DDLog"];
    DDLogFileManagerDefault * manager = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:documentsDDLog];
    manager.maximumNumberOfLogFiles = 7;
    DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:manager]; 
    fileLogger.rollingFrequency = 60 * 60 * 24;
    [DDLog addLogger:fileLogger];
}

@end
