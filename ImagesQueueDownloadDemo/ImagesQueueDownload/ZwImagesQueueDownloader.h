//
//  ZwImagesQueueDownloader.h
//  ImagesQueueDownloadDemo
//
//  Created by DengZw on 16/6/16.
//  Copyright © 2016年 MorningStar. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZwImageFileModel.h"

// 下载回调
typedef void(^ZwImageDownloadFinishedBlock)(BOOL isSuccess, NSString *tipsString);

@interface ZwImagesQueueDownloader : NSObject

/**
 *  单例
 *
 *  @return <#return value description#>
 */
+ (instancetype)shareInstance;

/**
 *  队列下载图片
 *
 *  @param array  model数组
 *  @param fBlock 回调
 */

- (void)queueDownloadImagesByArray:(NSArray *)array
                     finishedBlock:(ZwImageDownloadFinishedBlock)fBlock;

/**
 *  全路径
 *
 *  @param fileName 文件名
 *
 *  @return 根据文件名返回全路径
 */
- (NSString *)imageFileFullPathWithFileName:(NSString *)fileName;

@end
