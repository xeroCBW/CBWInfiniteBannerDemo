//
//  ViewController.m
//  CBWInfiniteBannerDemo
//
//  Created by 陈博文 on 16/8/25.
//  Copyright © 2016年 陈博文. All rights reserved.
//

#import "ViewController.h"
#import "CBWInfiniteBanner.h"

@interface ViewController ()

/** CBWInfiniteBanner*/
@property (nonatomic ,weak) CBWInfiniteBanner *banner;

/** uilabel*/
@property (nonatomic ,weak) UILabel *label;

/** isTouch*/
@property (nonatomic ,assign) BOOL isTouch;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initBaseUI];
    
    [self setUpWithBaseMethod];
    
    
}


- (void)initBaseUI{
    
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 0, self.view.frame.size.width,60);
    label.numberOfLines = 0;
    label.center = CGPointMake(self.view.center.x, 60);
    label.backgroundColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"点击view可以切换图片数组\n点击 banner 可以显示选中的 index";
    self.label = label;
    [self.view addSubview:label];

}


#pragma mark - 初始化方法

/**
 *  全能初始化方法
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

/**
 *  快速创建方法
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


#pragma mark - 切换图片数组
/**
 * 验证切换图片,不会崩溃
 */

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    self.isTouch = !self.isTouch;
    
    
    if (self.isTouch) {
        
        self.banner.imageUrls = @[
                                  @"http://www.qqya.com/qqyaimg/allimg/140227/1KI36229-3.jpg"
                                  
                                  ];
        
    }else{
        
        self.banner.imageUrls = @[
                                  @"http://img04.tooopen.com/images/20130317/tooopen_16483075.jpg",
                                  @"http://imgsrc.baidu.com/forum/pic/item/a8ec8a13632762d073a13908a0ec08fa503dc6ee.jpg",
                                  @"http://pic36.nipic.com/20131128/11748057_141932278338_2.jpg",
                                  @"http://pic8.nipic.com/20100623/55218_100905033361_2.jpg",
                                  @"http://www.qqya.com/qqyaimg/allimg/140227/1KI36229-3.jpg"
                                  ];
    }
    
}

@end

