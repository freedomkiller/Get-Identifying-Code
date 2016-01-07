//
//  HttpDownLoadBlock.h
//  HttpRequestDemo1_1418
//
//  Created by zhangcheng on 14-8-28.
//  Copyright (c) 2014年 zhangcheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HttpDownLoadBlock : NSObject<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
@property(nonatomic,strong)NSURLConnection*myConnection;
@property(nonatomic,strong)NSMutableData*data;
//文件生成路径
@property(nonatomic,copy)NSString*path;


//结果
@property(nonatomic,strong)NSArray*dataArray;
@property(nonatomic,strong)NSDictionary*dataDic;
@property(nonatomic,strong)UIImage*dataImage;
@property(nonatomic,strong)NSString*dataStr;


//需要block指针
@property(nonatomic,copy)void(^httpDownLoad)(BOOL,HttpDownLoadBlock*);

//外部调用的方法
-(id)initWithStrUrl:(NSString*)strUrl Block:(void(^)(BOOL,HttpDownLoadBlock*))a;
-(id)initWithStrUrl:(NSString*)strUrl Time:(NSInteger)time Block:(void(^)(BOOL,HttpDownLoadBlock*))a;
@end






