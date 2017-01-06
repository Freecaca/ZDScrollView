//
//  ZDScrollView.h
//  ZDScrollerView
//
//  Created by ZMac on 2017/1/5.
//  Copyright © 2017年 ZD. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  引入网络图片载入的头文件
 */
#import <UIImageView+WebCache.h>

@protocol ZDScrollViewDelegate;//滚动视图代理
@interface ZDScrollView : UIView<UIScrollViewDelegate>

@property (nonatomic, assign) int scrollTime;//轮播时间
@property (nonatomic, strong) NSArray *imageArray;//数据源
@property (strong, nonatomic) UIScrollView *scrollView;//滑动控件
@property (weak, nonatomic) id <ZDScrollViewDelegate> delegate;//代理

@end

#pragma mark - 代理方法
@protocol ZDScrollViewDelegate <NSObject>

/**
 *  选择图片事件
 *
 *  @param cycleScrollView 响应的视图
 *  @param index           点击图片的索引
 */
- (void)cycleScrollView:(ZDScrollView *)cycleScrollView didSelectImageView:(NSInteger)index;

@end
