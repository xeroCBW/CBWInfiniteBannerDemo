//
//  CBWInfiniteScrollView.m
//  无限滚动02-UIScrollView
//
//  Created by 1 on 15/12/30.
//  Copyright © 2015年 CBW. All rights reserved.
//

#import "CBWInfiniteBanner.h"
#import <UIImageView+WebCache.h>

@interface CBWInfiniteBanner() <UIScrollViewDelegate>
/** scrollView */
@property (nonatomic, weak) UIScrollView *scrollView;
/** pageControl */
@property (nonatomic, weak) UIPageControl *pageControl;
/** timer */
@property (nonatomic, weak) NSTimer *timer;
/** 更新间隔时间*/
@property (nonatomic ,assign) NSTimeInterval updateInterval;
/** 占位图片*/
@property (nonatomic ,strong) UIImage *placeHoldImage;
@end

@implementation CBWInfiniteBanner

/** imageView的数量 */
static NSUInteger const CBWImageViewCount = 3;

#pragma mark - 初始化方法


- (instancetype)initWithFrame:(CGRect)frame imageUrs:(NSArray *)imageUrls updateInterval:(NSTimeInterval )updateInterval placeHoldImage:(UIImage *)placeHoldImage{
    
    
    //对象本质是一个指针,类本质是一个结构体;指针不停的指向,但是一条一条指过来最终是类这个结构体;
    
    CBWInfiniteBanner *infiniteScrollView = [self initWithFrame:frame];
    
    infiniteScrollView.updateInterval = updateInterval;
    infiniteScrollView.placeHoldImage = placeHoldImage;
    infiniteScrollView.imageUrls = imageUrls;
 
    
    return infiniteScrollView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // scrollView
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        // 3个UIImageView
        for (NSUInteger i = 0; i < CBWImageViewCount; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [scrollView addSubview:imageView];
            
        }
        
        // pageControl
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        
        [self addSubview:pageControl];
        self.pageControl = pageControl;
        
    }
    return self;
}

-(void)setBannerCurrentPageIndicatorTintColor:(UIColor *)bannerCurrentPageIndicatorTintColor{
    
    _bannerCurrentPageIndicatorTintColor = bannerCurrentPageIndicatorTintColor;
    
    _pageControl.currentPageIndicatorTintColor = bannerCurrentPageIndicatorTintColor;
}

-(void)setBannerPageIndicatorTintColor:(UIColor *)bannerPageIndicatorTintColor{
    
    _bannerPageIndicatorTintColor = bannerPageIndicatorTintColor;

    _pageControl.pageIndicatorTintColor = bannerPageIndicatorTintColor;
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // scrollView
    self.scrollView.frame = self.bounds;
    
    // pageControl
    CGFloat pageControlW = 100;
    CGFloat pageControlH = 30;
    CGFloat pageControlX = self.bounds.size.width - pageControlW;
    CGFloat pageControlY = self.bounds.size.height - pageControlH;
    self.pageControl.frame = CGRectMake(pageControlX, pageControlY, pageControlW, pageControlH);
    
    self.pageControl.center = CGPointMake(self.center.x, pageControlY + pageControlH * 0.5);
    
    // 3个UIImageView
    CGFloat imageW = self.scrollView.frame.size.width;
    CGFloat imageH = self.scrollView.frame.size.height;
    for (NSUInteger i = 0; i < CBWImageViewCount; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        CGFloat imageX = i * imageW;
        CGFloat imageY = 0;
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        
        if (i == 1)
        {
            //为中间的图片添加 tap 手势
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
            [imageView addGestureRecognizer:tap];
        }

    }
    self.scrollView.contentSize = CGSizeMake(CBWImageViewCount * imageW, 0);
    
    [self updateContent];
    
}

#pragma mark - 属性setter

-(void)setImageUrls:(NSArray *)imageUrls{
    
    _imageUrls = imageUrls;
    
    [self stopTimer];
    
    //设置总页码
    self.pageControl.numberOfPages = imageUrls.count;
    
    self.pageControl.hidden = (imageUrls.count <= 1)?YES:NO;
    self.scrollView.scrollEnabled = imageUrls.count > 1?YES:NO;
    
    if (imageUrls.count > 1)
    {
        [self startTimer];
    }
    
    // 更新UIImageView内容
    [self updateContent];
}

#pragma mark - 更新界面
/**
 * 1.从左到右重新设置每一个UIImageView的图片
 * 2.重置UIScrollView的contentOffset.width == 1倍宽度
 */
- (void)updateContent
{
    // 1.从左到右重新设置每一个UIImageView的图片
    for (NSUInteger i = 0; i < CBWImageViewCount; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        
        // 求出i位置imageView对应的图片索引
        NSInteger imageIndex = 0; // 这里的imageIndex不能用NSUInteger
        if (i == 0) { // 当前页码 - 1
            imageIndex = self.pageControl.currentPage - 1;
        } else if (i == 2) { // 当前页码 + 1
            imageIndex = self.pageControl.currentPage + 1;
        } else { // // 当前页码
            imageIndex = self.pageControl.currentPage;
        }
        
        // 判断越界
        if (imageIndex == -1) { // 最后一张图片
            imageIndex = self.imageUrls.count - 1;
        } else if (imageIndex == self.imageUrls.count) { // 最前面那张
            imageIndex = 0;
        }
        
        //设置占位图片
        UIImage *placeHoldImage = self.placeHoldImage?self.placeHoldImage:[UIImage imageNamed:@"banner_loading"];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrls[imageIndex]] placeholderImage:placeHoldImage];
        // 绑定图片索引到UIImageView的tag
        imageView.tag = imageIndex;
    }
    
    // 2.重置UIScrollView的contentOffset.width == 1倍宽度
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
}

#pragma mark - <UIScrollViewDelegate>
/**
 * 只要scrollView滚动，就会调用这个方法
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // imageView的x 和 scrollView偏移量x 的最小差值
    CGFloat minDelta = MAXFLOAT;
    
    // 找出显示在最中间的图片索引
    NSInteger centerImageIndex = 0;
    
    for (NSUInteger i = 0; i < CBWImageViewCount; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        
        // ABS : 取得绝对值
        CGFloat delta = ABS(imageView.frame.origin.x - self.scrollView.contentOffset.x);
        if (delta < minDelta) {
            minDelta = delta;
            centerImageIndex = imageView.tag;
        }
    }
    
    // 设置页码
    self.pageControl.currentPage = centerImageIndex;

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
//    scrollView.scrollEnabled = NO;
//    [self updateContent];//强行修改 contentoffset 会导致一跳,一跳的效果;
    //还没有来得及减速,又开始了了拖拽.
    //即:还没有来得及减速完归位,又在拖拽;
//    NSLog(@"%s",__func__);
}
/**
 * 滚动完毕后调用（前提：手松开后继续滚动）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
//    scrollView.scrollEnabled = YES;
    
    [self updateContent];
   
}

/**
 * 当用户即将开始拖拽的时候调用
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

/**
 * 当用户即将结束拖拽的时候调用
 */
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    [self startTimer];
}

#pragma mark - touch 手势

//鸡肋功能就不要去加了.一直按住,就不是 tap, 还是会移动

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    
//    [self stopTimer];
//}
//
//-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    
//    [self startTimer];
//}

#pragma mark - 定时器处理
- (void)startTimer
{
    NSTimeInterval interval = self.updateInterval ? self.updateInterval:3.0;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)nextPage
{
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.contentOffset = CGPointMake(2 * self.scrollView.frame.size.width, 0);
    } completion:^(BOOL finished) {
        [self updateContent];
    }];
}

#pragma mark - 点击中间图片

- (void)tapAction{
    
    if (self.clickBlock) {
        self.clickBlock(self.pageControl.currentPage);
    }
}
@end
