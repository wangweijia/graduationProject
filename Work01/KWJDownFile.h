//
//  KWJDownFile.h
//  Work01
//
//  Created by kwj on 14/12/16.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^initProgress)(long long initValue);

typedef void (^loadedData)(long long loadedLength);

typedef void (^loadedPlan)(float);

typedef void (^loadDidEnd)(NSString *path);

@interface KWJDownFile : NSObject<NSURLConnectionDataDelegate>

@property (strong) NSURL *httpURL;

@property (nonatomic,copy)NSString *filePath;

@property (copy) void (^initProgress)(long long initValue);

@property (copy) void (^loadedData)(long long loadedLength);

@property (copy) void (^loadDidEnd)(NSString *path);

@property (copy) loadedPlan downPlan;

+ (instancetype) initWithURL:(NSURL *)url FilePath:(NSString *)path;

+ (instancetype) initWithURL:(NSURL *)url FilePath:(NSString *)path plusName:(NSString *)plus;

- (void) startAsyn;

@end
