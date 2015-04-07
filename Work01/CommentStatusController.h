//
//  CommentStatusController.h
//  Work01
//
//  Created by kwj on 14/12/19.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 comment	    true	string	评论内容，必须做URLencode，内容不超过140个汉字。
 id	            true	int64	需要评论的微博ID。
 */
@protocol commentStatusDelegate <NSObject>
@optional
-(void)dismissSelf;

@end

@interface CommentStatusController : UIViewController

@property (nonatomic,copy) NSString *statusId;

@property (nonatomic,weak) id<commentStatusDelegate> delegates;

@end
