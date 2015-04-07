//
//  KWJDownFile.m
//  Work01
//
//  Created by kwj on 14/12/16.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "KWJDownFile.h"

@interface KWJDownFile()

@property (nonatomic,assign) long long contentLength;

@property (nonatomic,assign) long long receiveLength;

@property (nonatomic,strong) NSMutableData *receiveData;

@property (nonatomic,strong) NSString *fileName;

@property (nonatomic,strong) NSString *plusName;

@property (nonatomic,strong) NSURLConnection *theConnection;

@property (nonatomic,strong) NSURLRequest *theRequest;

@end

@implementation KWJDownFile

@synthesize receiveData = _receiveData, fileName = _fileName,
theConnection=_theConnection, theRequest=_theRequest;

+ (instancetype) initWithURL:(NSURL *)url FilePath:(NSString *)path plusName:(NSString *)plus{
    KWJDownFile *asynDownload = [[KWJDownFile alloc] init];
    asynDownload.filePath = path;
    asynDownload.plusName = plus;
    asynDownload.theRequest=[NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:180.0];
    // create the connection with the request
    // and start loading the data
    return asynDownload;
}

+ (instancetype) initWithURL:(NSURL *)url FilePath:(NSString *)path{
    KWJDownFile *asynDownload = [[KWJDownFile alloc] init];
    asynDownload.filePath = path;
    asynDownload.theRequest=[NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:180.0];
    // create the connection with the request
    // and start loading the data
    return asynDownload;
}

- (void) startAsyn{
    _contentLength=0;
    _receiveLength=0;
    self.receiveData = [[NSMutableData alloc] init];
    self.theConnection = [[NSURLConnection alloc] initWithRequest:self.theRequest delegate:self];
}

//接收到http响应
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    _contentLength = [response expectedContentLength];
    _fileName = [response suggestedFilename];
    
    if (self.initProgress != nil) {
        self.initProgress(_contentLength);
    }
//        NSLog(@"data length is %lli", _contentLength);
}

//传输数据
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    _receiveLength += data.length;
    [_receiveData appendData:data];
    
    
    if (self.loadedData != nil) {
        self.loadedData(data.length);
    }
    if (self.downPlan != nil) {
        float plan = (float)_receiveLength/(float)_contentLength;
        self.downPlan(plan);
    }
//    NSLog(@"data recvive is %lli", _receiveLength);
}

//错误
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self releaseObjs];
    NSLog(@"%@",error.description);
}

- (void) releaseObjs{
    self.receiveData = nil;
    self.fileName = nil;
    self.theRequest = nil;
    self.theConnection = nil;
}

//成功下载完毕
- (void) connectionDidFinishLoading:(NSURLConnection *)connection{
    //数据写入doument
    //获取完整目录名字
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savePath;
    
    NSString *newName;
    if (self.plusName != nil) {
        newName = [NSString stringWithFormat:@"%@_%@",self.plusName,[_fileName lastPathComponent]];
    }else{
        newName = [NSString stringWithFormat:@"%@",[_fileName lastPathComponent]];
    }
    
    if (self.filePath != nil) {
        savePath = [NSString stringWithFormat:@"%@/%@/%@",documentsDirectory,self.filePath,newName];
        [self getDocumentsDirectoryPath:self.filePath];
    }else{
        savePath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,newName];
    }
    
    //创建文件
    [_receiveData writeToFile:savePath atomically:YES];
    if (self.loadDidEnd != nil) {
        self.loadDidEnd(savePath);
    }
    
    [self releaseObjs];
}

//创建文件夹
- (NSString *)getDocumentsDirectoryPath:(NSString *)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *downloadPath = [cachesDirectory stringByAppendingPathComponent:fileName];
    BOOL fileExists = [fileManager fileExistsAtPath:downloadPath];
    if (!fileExists) {
        [fileManager createDirectoryAtPath:downloadPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }
    return downloadPath;
}

@end
