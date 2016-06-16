//
//  ZwImageFileModel.m
//  ImagesQueueDownloadDemo
//
//  Created by DengZw on 16/6/16.
//  Copyright © 2016年 MorningStar. All rights reserved.
//

#import "ZwImageFileModel.h"

@implementation ZwImageFileModel

- (instancetype)initWithImageName:(NSString *)imgName imageURL:(NSString *)imgUrl
{
    if (self = [super init])
    {
        self.imgUrl = imgUrl;
        self.imgName = imgName;
    }
    
    return self;
}

@end
