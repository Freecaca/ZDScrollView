//
//  ZDScrollView.m
//  ZDScrollerView
//
//  Created by ZMac on 2017/1/5.
//  Copyright © 2017年 ZD. All rights reserved.
//

#import "ZDScrollView.h"
#define c_width (self.bounds.size.width)
#define c_height (self.bounds.size.height)


@implementation ZDScrollView{
    UIPageControl    *_pageControl; //分页控件
    NSMutableArray *_curImageArray; //当前显示的图片数组
    NSInteger          _curPage;    //当前显示的图片位置
    NSTimer           *_timer;      //定时器
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //滚动视图
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, c_width, c_height)];
        self.scrollView.contentSize = CGSizeMake(c_width*3, 0);
        self.scrollView.contentOffset = CGPointMake(c_width, 0);
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.delegate = self;
        [self addSubview:self.scrollView];
        
        //分页控件
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, c_height-30, self.bounds.size.width, 30)];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.hidesForSinglePage = YES;
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        [self addSubview:_pageControl];
        
        //初始化数据，当前图片默认位置是0
        _curImageArray = [[NSMutableArray alloc] initWithCapacity:0];
        _curPage = 0;
    }
    return self;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //如果scrollView当前偏移位置x大于等于两倍scrollView宽度
    if (scrollView.contentOffset.x >= c_width*2) {
        //当前图片位置+1
        _curPage++;
        //如果当前图片位置超过数组边界，则设置为0
        if (_curPage == [self.imageArray count]) {
            _curPage = 0;
        }
        //刷新图片
        [self reloadData];
        //设置scrollView偏移位置
        [scrollView setContentOffset:CGPointMake(c_width, 0)];
    }
    
    //如果scrollView当前偏移位置x小于等于0
    else if (scrollView.contentOffset.x <= 0) {
        //当前图片位置-1
        _curPage--;
        //如果当前图片位置小于数组边界，则设置为数组最后一张图片下标
        if (_curPage == -1) {
            _curPage = [self.imageArray count]-1;
        }
        //刷新图片
        [self reloadData];
        //设置scrollView偏移位置
        [scrollView setContentOffset:CGPointMake(c_width, 0)];
    }
}

//停止滚动的时候回调
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //设置scrollView偏移位置
    [scrollView setContentOffset:CGPointMake(c_width, 0) animated:YES];
}

#pragma mark - image方法
/**
 *  imageArray set函数重写
 *
 *  @param imageArray 图片Url数组
 */
- (void)setImageArray:(NSMutableArray *)imageArray
{
    _imageArray = imageArray;
    //设置分页控件的总页数
    _pageControl.numberOfPages = imageArray.count;
    //刷新图片
    [self reloadData];
    
    //开启定时器
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    //判断图片长度是否大于1，如果一张图片不开启定时器
    if ([imageArray count] > 1) {
        _timer = [NSTimer timerWithTimeInterval:self.scrollTime target:self selector:@selector(timerScrollImage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] runMode:UITrackingRunLoopMode beforeDate:[NSDate date]];
    }
}

/**
 *  图片重载
 */
- (void)reloadData
{
    
    //设置页数
    _pageControl.currentPage = _curPage;
    //根据当前页取出图片
    [self getDisplayImagesWithCurpage:_curPage];
    
    //从scrollView上移除所有的subview
    NSArray *subViews = [self.scrollView subviews];
    if ([subViews count] > 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    //创建imageView
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(c_width*i, 0, self.bounds.size.width, c_height)];
        imageView.userInteractionEnabled = YES;
        [self.scrollView addSubview:imageView];
        
        //设置网络图片
        NSURL *url = [NSURL URLWithString:_curImageArray[i]];
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"loading"]];
        //设置本地图片
//        imageView.image =[UIImage imageNamed:_curImageArray[i]];
        
        //tap手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        [imageView addGestureRecognizer:tap];
    }
}

/**
 *  获取图片
 *
 *  @param page 当前页面页码
 */
- (void)getDisplayImagesWithCurpage:(NSInteger)page
{
    //取出开头和末尾图片在图片数组里的下标
    NSInteger front = page - 1;
    NSInteger last = page + 1;
    
    //如果当前图片下标是0，则开头图片设置为图片数组的最后一个元素
    if (page == 0) {
        front = [self.imageArray count]-1;
    }
    
    //如果当前图片下标是图片数组最后一个元素，则设置末尾图片为图片数组的第一个元素
    if (page == [self.imageArray count]-1) {
        last = 0;
    }
    
    //如果当前图片数组不为空，则移除所有元素
    if ([_curImageArray count] > 0) {
        [_curImageArray removeAllObjects];
    }
    
    //当前图片数组添加图片
    [_curImageArray addObject:self.imageArray[front]];
    [_curImageArray addObject:self.imageArray[page]];
    [_curImageArray addObject:self.imageArray[last]];
}

/**
 *  定时器方法
 */
- (void)timerScrollImage
{
    //刷新图片
    [self reloadData];
    
    //设置scrollView偏移位置
    [self.scrollView setContentOffset:CGPointMake(c_width*2, 0) animated:YES];
}

/**
 *  tap图片方法
 *
 *  @param tap 点击事件
 */
- (void)tapImage:(UITapGestureRecognizer *)tap
{
    //设置代理
    if ([_delegate respondsToSelector:@selector(cycleScrollView:didSelectImageView:)]) {
        [_delegate cycleScrollView:self didSelectImageView:_curPage];
    }
}

/**
 *  销毁函数
 */
- (void)dealloc
{
    //代理指向nil，关闭定时器
    self.scrollView.delegate = nil;
    [_timer invalidate];
}
@end
