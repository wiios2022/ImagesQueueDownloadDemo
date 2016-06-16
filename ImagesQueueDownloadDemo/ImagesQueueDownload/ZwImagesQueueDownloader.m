//
//  ZwImagesQueueDownloader.m
//  ImagesQueueDownloadDemo
//
//  Created by DengZw on 16/6/16.
//  Copyright © 2016年 MorningStar. All rights reserved.
//

#import "ZwImagesQueueDownloader.h"

#define kDocumentImagesSubFilePathName @"ZwImages"

@interface ZwImagesQueueDownloader ()
{
    // 回调
    ZwImageDownloadFinishedBlock _finishedBlock;
    
    // 下载完成的数量
    NSInteger imgDownloadedCount;
}

@property (nonatomic, strong) NSArray *imgModelArray; /**< model数组 */

@end

@implementation ZwImagesQueueDownloader

+ (instancetype)shareInstance
{
    static ZwImagesQueueDownloader *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZwImagesQueueDownloader alloc] init];
        instance.imgModelArray = [[NSArray alloc] init];
    });
    
    return instance;
}

- (void)queueDownloadImagesByArray:(NSArray *)array
                     finishedBlock:(ZwImageDownloadFinishedBlock)fBlock
{
    _finishedBlock = fBlock;
    imgDownloadedCount = 0;
    
    self.imgModelArray = array;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    for (ZwImageFileModel *model in array)
    {
        NSInteger index = [array indexOfObject:model];
        
        if (![model isKindOfClass:[ZwImageFileModel class]])
        {
            
            NSString *tips = [NSString stringWithFormat:@"ZwImage Download Failed ! Model Error At Index %ld!", index];
            
            NSLog(@"%@", tips);
            
            if (_finishedBlock)
            {
                _finishedBlock(NO, tips);
            }
            
            break;
        }
        
        NSString *imgUrl = model.imgUrl;
        NSString *imgName = model.imgName;
        
        if (!imgName || !imgUrl)
        {
            NSString *tips = [NSString stringWithFormat:@"ZwImage Download Failed ! Name Or Url Is Null At Index %ld!", index];
            NSLog(@"%@", tips);
            
            if (_finishedBlock)
            {
                _finishedBlock(NO, tips);
            }
        }
        
        dispatch_group_async(group, queue, ^{
            // down load image
            [self downImageByModel:model];
        });
    }
    
    dispatch_group_notify(group, queue, ^{
        // down finished
        [self imagesDownloadFinished];
    });
}

- (void)downImageByModel:(ZwImageFileModel *)model
{
    NSURL *url = [NSURL URLWithString:model.imgUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *imgName = [NSString stringWithFormat:@"%@@2x.png", model.imgName];
    NSString *imgFullPath = [self imageFileFullPathWithFileName:imgName];
    
    BOOL isOk = [fileManager createFileAtPath:imgFullPath contents:data attributes:nil];
    if (isOk)
    {
        // 文件下载并储存成功，_imgFilePathArray + 1
        imgDownloadedCount ++;
    }
}

- (void)imagesDownloadFinished
{
    if (imgDownloadedCount == _imgModelArray.count)
    {
        // 全部下载完成
        NSLog(@"ZwImage Download Finished !");
        
        NSString *tips = @"ZwImage Download Finished !";
        
        if (_finishedBlock)
        {
            _finishedBlock(YES, tips);
        }
    }
    else
    {
        NSString *tips = @"Some Image Download Error !";
        
        if (_finishedBlock)
        {
            _finishedBlock(NO, tips);
        }
    }
}

 // 创建一个子目录
- (NSString *)createDirectoryOnDocumentWithSubDirectory:(NSString *)subDir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *screenshotDirectory = [documentsDirectory stringByAppendingPathComponent:subDir];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    if (![fm createDirectoryAtPath: screenshotDirectory withIntermediateDirectories: YES attributes:nil error: &error])
    {
        return nil;
    }
    
    return screenshotDirectory;
}

- (NSString *)productFileFullPathWithSubDirectory:(NSString *)subDir
                                         fileName:(NSString *)fileName
{
    NSString* imgDirectory = [self createDirectoryOnDocumentWithSubDirectory:subDir];
    if (nil == imgDirectory)
    {
        return nil;
    }
    NSString *fileFullPath = [imgDirectory stringByAppendingPathComponent:fileName];
    return fileFullPath;
}

- (NSString *)imageFileFullPathWithFileName:(NSString *)fileName
{
    return [self productFileFullPathWithSubDirectory:kDocumentImagesSubFilePathName
                                            fileName:fileName];
}

@end
