//
//  ViewController.m
//  LGLBannerView
//
//  Created by temp on 16/7/25.
//  Copyright © 2016年 luoguilin. All rights reserved.
//

#import "ViewController.h"
#import "LGLBannerView.h"

@interface ViewController ()<LGLBannerViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat screenRate = screenWidth / 320;
    
    NSArray *imageUrls = @[@"http://pic10.nipic.com/20101103/5063545_000227976000_2.jpg", @"http://a0.att.hudong.com/15/08/300218769736132194086202411_950.jpg", @"http://img2.3lian.com/img2007/4/22/303952037bk.jpg", @"http://pic15.nipic.com/20110706/7852592_142026142380_2.jpg", @"http://pic2.nipic.com/20090413/406638_125424003_2.jpg"];
    
    LGLBannerView *banner = [[LGLBannerView alloc] initWithFrame:CGRectMake(0, 20, screenWidth, 240 * screenRate)];
    
    banner.bannerDelegate = self;
    
    // imageList支持string、URL、image类型
    banner.imageList = imageUrls;
    
    // pagecontrol的普通颜色，默认白色
    banner.pageIndicatorColor = [UIColor lightGrayColor];
    
    // pagecontrol的当前页颜色，默认黑色
    banner.currentPageIndicatorColor = [UIColor orangeColor];
    
    // 时间间隔
    banner.duration = 2.0;
    
    [self.view addSubview:banner];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LGLBannerViewDelegate

- (void)LGLBannerView:(LGLBannerView *)bannerView selectedImageAtIndex:(NSInteger)index {
    
    NSLog(@"index: %ld", index);
}

@end
