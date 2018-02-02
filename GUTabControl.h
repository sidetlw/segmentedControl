//
//  GUTabControl.h
//  GearUI
//
//  Created by sidetang on 2017/10/1.
//  Copyright © 2017年 Tencent home voice assitance. All rights reserved.

#import <UIKit/UIKit.h>

@interface GUTabControl : UIControl

@property (nonatomic, copy) NSArray<NSString *> *items;

@property (nonatomic) NSInteger selectedIndex;

@property (nonatomic, strong) UIColor *selectedColor;

@property (nonatomic, strong) UIColor *unSelectedColor;

@property (nonatomic, strong) UIColor *indicatorColor;

@property (nonatomic) NSInteger direction;

-(void)setIncatorViewCenterWithFactor:(CGFloat)factor direction:(NSInteger)direct;
@end
