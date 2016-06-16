//
//  ZwImageFileModel.h
//  ImagesQueueDownloadDemo
//
//  Created by DengZw on 16/6/16.
//  Copyright © 2016年 MorningStar. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  图片model
 */

@interface ZwImageFileModel : NSObject

@property (nonatomic, strong) NSString *imgName; /**< 图片名字 */
@property (nonatomic, strong) NSString *imgUrl; /**< 图片url */

/**
 *  初始化方法
 *
 *  @param imgName 图片名
 *  @param imgUrl  图片url
 *
 *  @return self
 */
- (instancetype)initWithImageName:(NSString *)imgName imageURL:(NSString *)imgUrl;

@end
