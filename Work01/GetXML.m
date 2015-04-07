//
//  GetXML.m
//  Work01
//
//  Created by kwj on 14/11/20.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "GetXML.h"
#import "Inn.h"//栈

@interface GetXML()

@property (nonatomic) NSArray *title;
@property (nonatomic) NSMutableData *data;
@property (nonatomic) Inn *inn;

@property (nonatomic) NSMutableArray *xmlArray;
@property (nonatomic) BOOL isKey;

@property (nonatomic) NSMutableString *buffer;

@end

@implementation GetXML

+(instancetype)getXMLWithDelegate:(id)delegate{
    GetXML *getXML = [[GetXML alloc]init];
    getXML.delegates = delegate;
    return getXML;
}

-(id)init{
    if(self = [super init]){
        _inn = [[Inn alloc]init];
    }
    return self;
}

//去除 /t /n " "符号
-(NSString *)clearString:(NSString *)string{
    NSString *stripped = [string stringByReplacingOccurrencesOfString:@"\n"
                                                           withString:@""];
    stripped = [stripped stringByReplacingOccurrencesOfString:@"\t"
                                                   withString:@""];
    stripped = [stripped stringByReplacingOccurrencesOfString:@" "
                                                   withString:@""];
    return stripped;
}

//xml各标签 是否在制定标签里面
-(BOOL)elementNameInTitle:(NSString *)element{
    for (int i =0; i<_title.count; i++) {
        if ([element isEqualToString:_title[i]]) {
            return true;
        }
    }
    return false;
}


//得到 xml 的地址  与 要解析的 title  请求xml  title[0]为开始字符
-(void)GetXML_Path:(NSString *)path title:(NSArray *)title{
    
    _title=title;
    
    NSURL *url = [NSURL URLWithString:path];
    NSXMLParser *parser = [[NSXMLParser alloc]initWithContentsOfURL:url];
    parser.delegate = self;
    [parser parse];
}

//开始解析xml
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    
//    if (_xmlArray == nil) {
//        _xmlArray = [NSMutableArray array];
//    }
//    if (_buffer == nil) {
//        _buffer = [NSMutableString string];
//    }
    _xmlArray = [NSMutableArray array];
    _buffer = [NSMutableString string];
}

//解析到开始符号
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    if ([self elementNameInTitle:elementName]) {
    //为关键标签
        if ([_inn countOfInnArray] == 0) {
            NSMutableArray *Array = [NSMutableArray  array];
            [_inn push:Array];
        }
        NSMutableArray *tempArray = [NSMutableArray  array];
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        [tempDic setObject:tempArray forKey:elementName];
        [[_inn getTopObject] addObject:tempDic];
        [_inn push:tempDic];
        [_inn push:tempArray];
    }else{
        _isKey = false;
    }
    
}

//得到 具体 title 后 提取内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if (!_isKey) {
       [_buffer appendString:[self clearString:string]];
    }
}

//解析到结束符号
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([self elementNameInTitle:elementName]) {
    //关键字
        [_inn pop];
        if ([_inn countOfInnArray] == 2) {
            [_xmlArray addObject:[_inn getTopObject]];
        }
        [_inn pop];
    }else{
    //非关键字
        _isKey = true;
        NSDictionary *dic =@{elementName:_buffer};
        _buffer = [NSMutableString string];
        [[_inn getTopObject] addObject:dic];
    }
}

//xml 解析完成
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    if ([self.delegates respondsToSelector:@selector(XMLDidEndDocument:)]) {
        [self.delegates XMLDidEndDocument:_xmlArray];
    }
}

@end
