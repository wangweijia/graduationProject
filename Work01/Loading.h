//
//  Loading.h
//  Work01
//
//  Created by kwj on 14/11/18.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoadBDConnectionDataDelegate <NSObject>
@optional
//-(void)resultWith:(NSArray *)array WithName:(NSString *)name Sender:(id)sender;
-(void)resultWith:(id)data WithName:(NSString *)name Sender:(id)sender;
@end

@interface Loading : NSObject<NSURLConnectionDataDelegate>

//delegate 回调
@property (nonatomic,weak) id<LoadBDConnectionDataDelegate> delegates;

+(instancetype)LoadDBWithDelegate:(id)delegate;

-(void)LoadDB_GET_WithURL:(NSString *)urlStr WithName:(NSString *)name WithSender:(id)sender;

-(void)LoadDB_GET_WithURL:(NSString *)urlStr WithGet:(NSDictionary *)dic WithName:(NSString *)name WithSender:(id)sender;

-(void)LoadDB_POST_WithURL:(NSString *)urlStr WithPost:(NSDictionary *)dic WithName:(NSString *)name WithSender:(id)sender;

-(void)LoadDB_POST_multipart_form_photo_WithURL:(NSString *)urlStr WithPost:(NSDictionary *)dic WithName:(NSString *)name WithSender:(id)sender;

-(void)LoadDB_POST_multipart_form_photos_WithURL:(NSString *)urlStr WithPost:(NSDictionary *)dic WithName:(NSString *)name WithSender:(id)sender;

@end
