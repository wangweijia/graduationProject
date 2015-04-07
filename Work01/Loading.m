//
//  Loading.m
//  Work01
//
//  Created by kwj on 14/11/18.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "Loading.h"

@interface Loading()

@property (nonatomic,copy) NSString *loadName;
@property (nonatomic)NSMutableData *data;
@property (nonatomic)NSArray *array;

@property (nonatomic)NSMutableArray *requestArray;

@property (nonatomic)id sender;

@end

@implementation Loading

+(instancetype)LoadDBWithDelegate:(id)delegate{
    Loading *loads = [[Loading alloc]init];
    loads.delegates=delegate;
    return loads;
}

-(id)init{
    if (self = [super init]){
        _requestArray = [NSMutableArray array];
    }
    return self;
}

/*
 *  使用GET方法访问数据库，得到数据
 */
-(void)LoadDB_GET_WithURL:(NSString *)urlStr WithName:(NSString *)name WithSender:(id)sender{
//    NSLog(@"LoadDB_GET");
    //为本次联接取名字
    _loadName = [NSString stringWithString:name];
    _sender = sender;
    
    NSURL *url = [NSURL URLWithString:urlStr];
//    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    //NSURLRequest初始化方法第一个参数：请求访问路径，第二个参数：缓存协议，第三个参数：网络请求超时时间（秒）
    NSURLRequest *request=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    //每创建一个 request 就加进 数组中 方便一起销毁
    [_requestArray addObject:request];
//    NSLog(@"%@",urlStr);

    [NSURLConnection connectionWithRequest:request delegate:self];
}

/*
 *  使用get方法请求数据
 *
 *  @param urlStr url
 *  @param dic    条件 字典
 *  @param name   联接名字
 *  @param sender 附加参数
 */
-(void)LoadDB_GET_WithURL:(NSString *)urlStr WithGet:(NSDictionary *)dic WithName:(NSString *)name WithSender:(id)sender{
    //为本次联接取名字
    _loadName = [NSString stringWithString:name];
    _sender = sender;
    
    NSString *getStr=urlStr;
    NSArray *key = [dic allKeys];
    NSArray *value = [dic allValues];
    for (int i=0; i<dic.count; i++) {
        NSString *str;
        if (i==0) {
            str=[NSString stringWithFormat:@"?%@=%@",key[i],value[i]];
        }else{
            str=[NSString stringWithFormat:@"&%@=%@",key[i],value[i]];
        }
        getStr=[getStr stringByAppendingString:str];
    }
    
//    NSLog(@"%@",getStr);
    
    NSURL *url = [NSURL URLWithString:getStr];
    //    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    //NSURLRequest初始化方法第一个参数：请求访问路径，第二个参数：缓存协议，第三个参数：网络请求超时时间（秒）
    NSURLRequest *request=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    //每创建一个 request 就加进 数组中 方便一起销毁
    [_requestArray addObject:request];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

/*
 *  使用POST方法访问数据库，得到数据
 */
-(void)LoadDB_POST_WithURL:(NSString *)urlStr WithPost:(NSDictionary *)dic WithName:(NSString *)name WithSender:(id)sender{
//    NSLog(@"LoadDB_PUST");
    //为本次联接取名字
    _loadName = [NSString stringWithString:name];
    _sender = sender;
    
    NSURL *url = [NSURL URLWithString:urlStr];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //NSURLRequest初始化方法第一个参数：请求访问路径，第二个参数：缓存协议，第三个参数：网络请求超时时间（秒）
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];

    //每创建一个 request 就加进 数组中 方便一起销毁
    [_requestArray addObject:request];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *postStr=@"";
    NSArray *key = [dic allKeys];
    NSArray *value = [dic allValues];
    for (int i=0; i<dic.count; i++) {
        NSString *str;
        if (i==0) {
            str=[NSString stringWithFormat:@"%@=%@",key[i],value[i]];
        }else{
            str=[NSString stringWithFormat:@"&%@=%@",key[i],value[i]];
        }
        postStr=[postStr stringByAppendingString:str];
    }
    NSData *data=[postStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

/*
 *  使用POST方法访问数据库，得到数据
 */
-(void)LoadDB_POST_multipart_form_photo_WithURL:(NSString *)urlStr WithPost:(NSDictionary *)dic WithName:(NSString *)name WithSender:(id)sender{
    //    NSLog(@"LoadDB_PUST");
    //为本次联接取名字
    _loadName = [NSString stringWithString:name];
    _sender = sender;
    
    NSURL *url = [NSURL URLWithString:urlStr];
    //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //NSURLRequest初始化方法第一个参数：请求访问路径，第二个参数：缓存协议，第三个参数：网络请求超时时间（秒）
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    //每创建一个 request 就加进 数组中 方便一起销毁
    [_requestArray addObject:request];

    NSString *POST_BOUNDS = @"kwj";
    
//    NSMutableString *postStr = [NSMutableString string];
//    for(NSString *key in dic){
//        [postStr appendFormat:@"--%@\r\n",POST_BOUNDS];
//        id value = [dic objectForKey:key];
//        if ([key isEqualToString:@"pic"]) {
//            [postStr appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",key,@"shell.JPG"];
//            [postStr appendFormat:@"Content-Type: image/JPG\r\nContent-Transfer-Encoding: binary\r\n\r\n"];
//        }else{
//            [postStr appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
//        }
//
//        [postStr appendFormat:@"%@\r\n",value];
//    }
//    [postStr appendFormat:@"--%@--\r\n",POST_BOUNDS];

    //----------------------------------------------------------------------------
    NSMutableData *bodyData = [NSMutableData data];
    for(NSString *key in dic){
        [bodyData appendData:[[NSString stringWithFormat:@"--%@\r\n",POST_BOUNDS] dataUsingEncoding:NSUTF8StringEncoding]];
        id value = [dic objectForKey:key];
        if ([key isEqualToString:@"pic"]) {
            [bodyData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
            [bodyData appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [bodyData appendData:value];
            [bodyData appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }else{
            [bodyData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
            [bodyData appendData:[[NSString stringWithFormat:@"%@\r\n", value] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    [bodyData appendData:[[NSString stringWithFormat:@"--%@--\r\n", POST_BOUNDS] dataUsingEncoding:NSUTF8StringEncoding]];
    //----------------------------------------------------------------------------
//    NSLog(@"%@",postStr);
    
    //multipart/form-data编码 头文件
    [request addValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@",POST_BOUNDS] forHTTPHeaderField:@"Content-Type"];
    //传输方式
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:bodyData];
    //设置长度
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[bodyData length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

/*
 *  使用POST方法访问数据库，得到数据
 */
-(void)LoadDB_POST_multipart_form_photos_WithURL:(NSString *)urlStr WithPost:(NSDictionary *)dic WithName:(NSString *)name WithSender:(id)sender{
    //    NSLog(@"LoadDB_PUST");
    //为本次联接取名字
    _loadName = [NSString stringWithString:name];
    _sender = sender;
    
    NSURL *url = [NSURL URLWithString:urlStr];
    //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //NSURLRequest初始化方法第一个参数：请求访问路径，第二个参数：缓存协议，第三个参数：网络请求超时时间（秒）
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    //每创建一个 request 就加进 数组中 方便一起销毁
    [_requestArray addObject:request];
    
    NSString *POST_BOUNDS = @"kwj";
    
    NSMutableData *bodyData = [NSMutableData data];
    
    NSArray *imageArray = dic[@"pic"];
    
    for(NSString *key in dic){
        [bodyData appendData:[[NSString stringWithFormat:@"--%@\r\n",POST_BOUNDS] dataUsingEncoding:NSUTF8StringEncoding]];
        id value = [dic objectForKey:key];
        if (![key isEqualToString:@"pic"]){
            [bodyData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
            [bodyData appendData:[[NSString stringWithFormat:@"%@\r\n", value] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    for (int i = 0; i < imageArray.count ; i++) {
        NSString *key = @"pic";
        [bodyData appendData:[[NSString stringWithFormat:@"--%@\r\n",POST_BOUNDS] dataUsingEncoding:NSUTF8StringEncoding]];
        [bodyData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image%d.jpg\"\r\n", key,i] dataUsingEncoding:NSUTF8StringEncoding]];
        [bodyData appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [bodyData appendData:imageArray[i]];
        [bodyData appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [bodyData appendData:[[NSString stringWithFormat:@"--%@--\r\n", POST_BOUNDS] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //multipart/form-data编码 头文件
    [request addValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@",POST_BOUNDS] forHTTPHeaderField:@"Content-Type"];
    //传输方式
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:bodyData];
    //设置长度
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[bodyData length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}


//接收 数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if (_data == nil) {
        _data = [NSMutableData data];
    }
    [_data appendData:data];
}

//数据接收完成  
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    //通过代理 实现数据接收完成后的操作
    if ([self.delegates respondsToSelector:@selector(resultWith:WithName:Sender:)]) {
//        [self.delegates resultWith:_array WithName:_loadName Sender:_sender];
        [self.delegates resultWith:
         [NSJSONSerialization JSONObjectWithData:_data options:NSUTF8StringEncoding error:nil] WithName:_loadName Sender:_sender];
        _data=nil;
    }
}

- (void)dealloc{
    
}

@end
