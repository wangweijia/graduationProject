//
//	ReaderConstants.h
//	Reader v2.6.0
//
//	Created by Julius Oklamcak on 2011-07-01.
//	Copyright © 2011-2013 Julius Oklamcak. All rights reserved.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights to
//	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//	of the Software, and to permit persons to whom the Software is furnished to
//	do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

//#if !__has_feature(objc_arc)
//	#error ARC (-fobjc-arc) is required to build this code.
//#endif

#import <Foundation/Foundation.h>

#define READER_BOOKMARKS TRUE        //阅读书签
#define READER_ENABLE_MAIL FALSE     //EMAIL功能
#define READER_ENABLE_PRINT FALSE    //打印功能
#define READER_ENABLE_THUMBS TRUE    //是否显示缩略图信息
#define READER_ENABLE_PREVIEW TRUE   //显示预览信息
#define READER_DISABLE_RETINA FALSE  //retina 显示
#define READER_DISABLE_IDLE FALSE    //阅读时是否锁屏
#define READER_SHOW_SHADOWS FALSE     //显示阅读的Shadow
#define READER_STANDALONE FALSE      //是否只阅读 不返回界面信息

extern NSString *const kReaderCopyrightNotice;
