//
//  SelectCourseController.h
//  Work01
//
//  Created by kwj on 14/11/17.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetXML.h"
#import "KWJCourseAlertView.h"
#import "KWJSectionHeaderView.h"
#import "SectionCell.h"

@interface SelectCourseController : UIViewController<getXmlDelegate,UITableViewDataSource,UITableViewDelegate,KWJSectionHeaderViewDelegate,KWJLableButtonDelegate,KWJCourseAlertDelegete>

@property (nonatomic,copy) NSString *courseId;//课程xml的地址
@property (nonatomic,copy) NSString *courseName;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end
