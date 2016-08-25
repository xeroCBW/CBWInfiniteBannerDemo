//
//  CBWInfiniteScrollView.h
//  无限滚动02-UIScrollView
//
//  Created by 1 on 15/12/30.
//  Copyright © 2015年 CBW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBWInfiniteBanner : UIView
/** 网络图片urls */
@property (nonatomic, strong) NSArray *imageUrls;

/** 点击事件的 block*/
@property (nonatomic ,copy) void(^clickBlock)(NSInteger index);

/** bannerPageIndicatorTintColor*/
@property (nonatomic ,strong) UIColor *bannerPageIndicatorTintColor;

/** bannerCurrentPageIndicatorTintColor*/
@property (nonatomic ,strong) UIColor *bannerCurrentPageIndicatorTintColor;

- (instancetype)initWithFrame:(CGRect)frame imageUrs:(NSArray *)imageUrls updateInterval:(NSTimeInterval )updateInterval placeHoldImage:(UIImage *)placeHoldImage;

@end
