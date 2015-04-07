//
//  Inn.h
//  Work01
//
//  Created by kwj on 14/11/20.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Inn : NSObject

@property (nonatomic) NSMutableArray *innArray;

-(id)init;

//1.入栈
-(void)push:(id)object;
//2.出栈
-(void)pop;
//3.输出栈顶元素
-(id)getTopObject;
//4.得到栈中数据个数
-(int)countOfInnArray;
@end
