//
//  ViewController.h
//  ZDScrollerView
//
//  Created by ZMac on 2017/1/5.
//  Copyright © 2017年 ZD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDScrollView.h"

@interface ViewController : UIViewController<ZDScrollViewDelegate>
@property (nonatomic, strong) ZDScrollView *imageScrollView;

@end

