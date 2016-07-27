//
//  LGLBannerView.h
//  BanerView
//
//  Created by temp on 16/7/25.
//  Copyright © 2016年 luoguilin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGLBannerView;

@protocol LGLBannerViewDelegate <NSObject>

- (void)LGLBannerView:(LGLBannerView *)bannerView selectedImageAtIndex:(NSInteger)index;

@end

@interface LGLBannerView : UIView

@property (nonatomic, weak) id<LGLBannerViewDelegate>bannerDelegate;

@property (nonatomic, copy) NSArray *imageList;
@property (nonatomic, copy) NSString *placeHolderImage;                  // 默认图片，默认是 phi.jpg
@property (nonatomic, strong) UIColor *pageIndicatorColor;               // pagecontrol的普通颜色，默认是 lightgraycolor
@property (nonatomic, strong) UIColor *currentPageIndicatorColor;        // pagecontrol的当前页颜色，默认是 blackcolor
@property (nonatomic, assign) CGFloat duration;                          // 滚动事件间隔，默认是 3s
@property (nonatomic, assign) CGRect pageControlFrame;                   // pagecontrol的frame，默认左右居中，距底部22px
@property (nonatomic, assign) CGFloat sensitivity;                       // 滑动轮播图的灵敏度，代表滑动偏移量占轮播图宽度的比例 > 0 && < 1
@property (nonatomic,assign) BOOL showPageControl;                       // 默认显示pageControl

@end
