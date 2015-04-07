//
//  PDFReadController.h
//  Work01
//
//  Created by kwj on 14/12/17.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol hideThumbView <NSObject>

-(void)hideThumbView;

@end

@class TablePdfViewController;//主要

@interface PDFReadController : UIViewController

@property (nonatomic,copy)NSString *coursewareName;

@property (nonatomic,strong)TablePdfViewController *pdfTableView;

@property (weak, nonatomic) IBOutlet UIView *readView;

@end
