//
//  ViewController.m
//  ImagesQueueDownloadDemo
//
//  Created by DengZw on 16/6/16.
//  Copyright © 2016年 MorningStar. All rights reserved.
//

#import "ViewController.h"
#import "ZwImagesQueueDownloader.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self startDownImage];
}

- (void)startDownImage
{
    NSString * url1 = @"https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/bd_logo1_31bdc765.png";
    NSString * url2 = @"https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/bd_logo1_31bdc765.png";
    NSString * url3 = @"https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/bd_logo1_31bdc765.png";
    NSString * url4 = @"https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/bd_logo1_31bdc765.png";
    
    
    ZwImageFileModel *model1 = [[ZwImageFileModel alloc] initWithImageName:@"test1"
                                                                 imageURL:url1];
    ZwImageFileModel *model2 = [[ZwImageFileModel alloc] initWithImageName:@"test2"
                                                                  imageURL:url2];
    ZwImageFileModel *model3 = [[ZwImageFileModel alloc] initWithImageName:@"test3"
                                                                  imageURL:url3];
    ZwImageFileModel *model4 = [[ZwImageFileModel alloc] initWithImageName:@"test4"
                                                                  imageURL:url4];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:model1];
    [array addObject:model2];
    [array addObject:model3];
    [array addObject:model4];
    
    [[ZwImagesQueueDownloader shareInstance] queueDownloadImagesByArray:array finishedBlock:^(BOOL isSuccess, NSString *tipsString) {
        //
        if (isSuccess)
        {
            NSString *filePath = [[ZwImagesQueueDownloader shareInstance] imageFileFullPathWithFileName:model1.imgName];
            NSLog(@"%@", filePath);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imgView.image = [UIImage imageWithContentsOfFile:filePath];
            });
        }
        else
        {
            NSLog(@"%@", tipsString);
        }
    }];
    
    
}

@end
