//
//  ViewController.m
//  ZDScrollerView
//
//  Created by ZMac on 2017/1/5.
//  Copyright © 2017年 ZD. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.imageScrollView = [[ZDScrollView alloc] initWithFrame:CGRectMake(0, 200, CGRectGetWidth(self.view.bounds), 200)];
    self.imageScrollView.scrollTime =MAXFLOAT;
    self.imageScrollView.delegate = self;
    [self.view addSubview:self.imageScrollView];
    
    
    self.imageScrollView.imageArray =  @[
                                         @"http://www.guguiche.com/static/imges/banner/wb.png",
                                         @"http://www.guguiche.com/static/imges/banner/bx.png",
                                         @"http://www.guguiche.com/static/imges/banner/wz.png",
                                         @"http://www.guguiche.com/static/imges/banner/gz.png"
                                         ];
//    self.imageScrollView.imageArray =  @[
//                                         @"1",
//                                         @"2",
//                                         @"3",
//                                         @"4",
//                                         ];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置图片循环滚动，如果偏移位置大于330，则设置为330
//    if (self.imageScrollView.scrollView.contentOffset.x > 330) {
//        self.imageScrollView.scrollView.contentOffset = CGPointMake(330*2, 0);
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CycleScrollViewDelegate
- (void)cycleScrollView:(ZDScrollView *)cycleScrollView didSelectImageView:(NSInteger)index
{
    NSLog(@"点击了第%ld张图片",(long)index+1);
}


@end
