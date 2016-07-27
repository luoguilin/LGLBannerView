//
//  LGLBannerView.m
//  BanerView
//
//  Created by temp on 16/7/25.
//  Copyright © 2016年 luoguilin. All rights reserved.
//

#import "LGLBannerView.h"
#import "UIImageView+WebCache.h"

#warning 使用时请导入SDWebImage

static const NSInteger leftImageTag = 10000;
static const NSInteger currentImageTag = 10001;
static const NSInteger rightImageTag = 10002;

@interface LGLBannerView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isAddToSupperView;      // 标记变量：是否已经添加到父视图上
@property (nonatomic, assign) CGFloat bannerWidth;
@property (nonatomic, assign) CGFloat bannerHeight;

@end

@implementation LGLBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setDefaultData];
        
        [self initViews];
    }
    
    return self;
}

- (void)setDefaultData {
    
    _bannerWidth = self.frame.size.width;
    
    _bannerHeight = self.frame.size.height;
    
    _currentPage = 0;
    
    _isAddToSupperView = NO;
    
    _pageIndicatorColor = [UIColor lightGrayColor];
    
    _currentPageIndicatorColor = [UIColor blackColor];
    
    _duration = 3.0;
    
    _placeHolderImage = @"phi.jpg";
    
    _sensitivity = 0.3;
    
    _showPageControl = YES;
    
}

- (void)initViews {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _bannerWidth, _bannerHeight)];
    
    _scrollView.delegate = self;
    
    _scrollView.showsVerticalScrollIndicator = NO;
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _scrollView.pagingEnabled = YES;
    
    _scrollView.contentSize = CGSizeMake(_bannerWidth * 3, _bannerHeight);
    
    _scrollView.contentOffset = CGPointMake(_bannerWidth, 0);
    
    [self addSubview:_scrollView];
    
    NSArray *imageViewTags = @[@(leftImageTag), @(currentImageTag), @(rightImageTag)];

    for (int i = 0; i < 3; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_bannerWidth * i, 0, _bannerWidth, _bannerHeight)];
        
        imageView.tag = [imageViewTags[i] integerValue];
        
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(tapImage:)];
        
        [imageView addGestureRecognizer:tap];
        
        [_scrollView addSubview:imageView];
    }
    
    _pageControl = [[UIPageControl alloc] init];
    
    _pageControl.pageIndicatorTintColor = _pageIndicatorColor;
    
    _pageControl.currentPageIndicatorTintColor = _currentPageIndicatorColor;
    
    _pageControl.hidden = !_showPageControl;
    
    [self addSubview:_pageControl];
    
}

// 在addSubviews时触发layoutSubviews，这样确保用户设置的属性生效
- (void)layoutSubviews {
    
    if (_isAddToSupperView == NO) {
        
        _isAddToSupperView = YES;
        
        [self setupTimer];
    }
}

#pragma mark - Setter

- (void)setImageList:(NSArray *)imageList {
    
    _imageList = imageList;
    
    _pageControl.currentPage = 0;
    
    _pageControl.numberOfPages = _imageList.count;
    
    // 设置pagecontrol默认坐标
    CGFloat width = imageList.count * 8 + (imageList.count - 1) * 13;
    
    _pageControl.frame = CGRectMake((_bannerWidth - width) / 2, _bannerHeight - 30, width, 8);

    [self showCurrentImage];
}

- (void)setPlaceHolderImage:(NSString *)placeHolderImage {
    
    _placeHolderImage = placeHolderImage;
}

- (void)setPageIndicatorColor:(UIColor *)pageIndicatorColor {
    
    _pageIndicatorColor = pageIndicatorColor;
    
    _pageControl.pageIndicatorTintColor = _pageIndicatorColor;
}

- (void)setCurrentPageIndicatorColor:(UIColor *)currentPageIndicatorColor {
    
    _currentPageIndicatorColor = currentPageIndicatorColor;
    
    _pageControl.currentPageIndicatorTintColor = _currentPageIndicatorColor;
}

- (void)setDuration:(CGFloat)duration {
    
    _duration = duration;
}

- (void)setPageControlFrame:(CGRect)pageControlFrame {
    
    _pageControlFrame = pageControlFrame;
    
    _pageControl.frame = _pageControlFrame;
}

- (void)setSensitivity:(CGFloat)sensitivity {
    
    _sensitivity = sensitivity;
}

- (void)setShowPageControl:(BOOL)showPageControl {
    
    _showPageControl = showPageControl;
    
    _pageControl.hidden = !_showPageControl;
}

#pragma mark - Action

- (void)setupTimer {
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:_duration target:self selector:@selector(scrollBanner) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)scrollBanner {
    
    [_scrollView setContentOffset:CGPointMake(_bannerWidth * 2, 0) animated:YES];
}

- (void)showCurrentImage {
    
    // 根据偏移量计算当前页
    if (_scrollView.contentOffset.x == 0) {
        
        _currentPage --;
        
        if (_currentPage < 0) {
            
            _currentPage = _imageList.count - 1;
        }
    } else if (_scrollView.contentOffset.x == _bannerWidth * 2) {
        
        _currentPage ++;
        
        if (_currentPage > _imageList.count - 1) {
            
            _currentPage = 0;
        }
    }
    
    NSInteger leftPage = (_currentPage - 1 < 0) ? (_imageList.count - 1) : (_currentPage -1);
    
    NSInteger rightPage = (_currentPage + 1 > _imageList.count - 1) ? 0 : (_currentPage + 1);
    
    UIImageView *leftImage = (UIImageView *)[self viewWithTag:leftImageTag];
    [self showImage:_imageList[leftPage] onImageView:leftImage];
    
    UIImageView *currentImage = (UIImageView *)[self viewWithTag:currentImageTag];
    [self showImage:_imageList[_currentPage] onImageView:currentImage];
    
    UIImageView *rightImage = (UIImageView *)[self viewWithTag:rightImageTag];
    [self showImage:_imageList[rightPage] onImageView:rightImage];
    
    _scrollView.contentOffset = CGPointMake(_bannerWidth, 0);
    
    _pageControl.currentPage = _currentPage;
}

- (void)showImage:(id)image onImageView:(UIImageView *)imageView {
    
    // 如使用SDWebImage不显示图片，请在info.plist里设置App Transport Security Settings
    if ([image isKindOfClass:[NSString class]]) {
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:_placeHolderImage]];
        
    } else if ([image isKindOfClass:[NSURL class]]) {
        
        [imageView sd_setImageWithURL:image placeholderImage:[UIImage imageNamed:_placeHolderImage]];
        
    } else if ([image isKindOfClass:[UIImage class]]) {
        
        imageView.image = image;
    }
}

- (void)tapImage:(UITapGestureRecognizer *)tap {
    
    [self.bannerDelegate LGLBannerView:self selectedImageAtIndex:_currentPage];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    // 滑动时关闭定时器
    [_timer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self setupTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self showCurrentImage];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    [self showCurrentImage];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
