//
//  GetXML.h
//  Work01
//
//  Created by kwj on 14/11/20.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol getXmlDelegate <NSObject>

-(void)XMLDidEndDocument:(NSArray *)array;

@end

@interface GetXML : NSObject<NSXMLParserDelegate>

+(instancetype)getXMLWithDelegate:(id)delegate;

-(void)GetXML_Path:(NSString *)path title:(NSArray *)title;

@property (nonatomic,weak) id<getXmlDelegate> delegates;

@end
