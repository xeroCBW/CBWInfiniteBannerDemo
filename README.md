# CBWInfiniteBannerDemo



###CBWInfiniteBanner介绍

+ CBWInfiniteBanner可以实现传入一个 图片url数组,实现无限轮播;
+ 设置点击的 block ,可以实现对图片的点击动作;
+ 默认一张图片不会轮播,不显示 pageControl;多张图片开始轮播;
+ 是否实现点击 block, 可以根据用户喜好设置点击事件的 block
+ 可以设置 pageContorl 的 pageIndicatorTintColor 和 currentPageIndicatorTintColor

###CBWInfiniteBanner提供两种方法创建:

- 1.全能初始化方法
  + 全能创建方法需要在初始化的时候传入:
  
	1. Frame
	2. imageUrls
	3. updateInterval(默认3.0s)
	4. placeHoldImage(默认占位图片为图片正在加载中)

- 2.快速创建方法
  + 快速创建方法需要在初始化后设置:
	1. Frame
	2. imageUrls
注意:点击事件是否实现:根据需要



```

/**
 *  全能初始化方法
 */

- (void)setUpWithBaseMethod{
    
    NSArray *imageUrls = @[
                           @"http://img04.tooopen.com/images/20130317/tooopen_16483075.jpg",
                           @"http://imgsrc.baidu.com/forum/pic/item/a8ec8a13632762d073a13908a0ec08fa503dc6ee.jpg",
                           @"http://pic36.nipic.com/20131128/11748057_141932278338_2.jpg",
                           @"http://pic8.nipic.com/20100623/55218_100905033361_2.jpg",
                           @"http://www.qqya.com/qqyaimg/allimg/140227/1KI36229-3.jpg"
                           ];
    
    UIImage *placeHolderImage = [UIImage imageNamed:@"apple_logo"];
    
    CBWInfiniteBanner *infiniteBanner = [[CBWInfiniteBanner alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 150) imageUrs:imageUrls updateInterval:3.0 placeHoldImage:placeHolderImage];
    
    self.banner = infiniteBanner;
    
    __weak typeof(self)weakSelf = self;
    infiniteBanner.clickBlock = ^(NSInteger index){
        
        NSLog(@"%ld",(long)index);
        weakSelf.label.text = [NSString stringWithFormat:@"选中的为第%ld个",(long)index];
        
    };
    
    infiniteBanner.bannerPageIndicatorTintColor = [UIColor whiteColor];
    infiniteBanner.bannerCurrentPageIndicatorTintColor = [UIColor greenColor];
    [self.view addSubview:infiniteBanner];
}
```

```
/**
 *  快速创建方法
 */
- (void)setupWithQucikMethod{
    
    CBWInfiniteBanner *scrollView = [[CBWInfiniteBanner alloc] init];
    scrollView.frame = CGRectMake(0, 100, self.view.frame.size.width, 150);
    scrollView.imageUrls = @[
                             @"http://img04.tooopen.com/images/20130317/tooopen_16483075.jpg",
                             @"http://imgsrc.baidu.com/forum/pic/item/a8ec8a13632762d073a13908a0ec08fa503dc6ee.jpg",
                             @"http://pic36.nipic.com/20131128/11748057_141932278338_2.jpg",
                             @"http://pic8.nipic.com/20100623/55218_100905033361_2.jpg",
                             @"http://www.qqya.com/qqyaimg/allimg/140227/1KI36229-3.jpg"
                             ];
    [self.view addSubview:scrollView];
    
    scrollView.clickBlock = ^(NSInteger index){
        
        NSLog(@"%ld",(long)index);
        
    };
    
}

```



