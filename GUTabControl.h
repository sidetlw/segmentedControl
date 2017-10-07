//
//  GUTabControl.h
//  GearUI
//
//  Created by sidetang on 2017/10/1.
//

#import <UIKit/UIKit.h>

@interface GUTabControl : UIControl

@property (nonatomic, copy) NSArray<NSString *> *titles;

@property (nonatomic) NSInteger currentPage;

@property (nonatomic, strong) UIColor *selectedColor;

@property (nonatomic, strong) UIColor *unselectedColor;

@property (nonatomic, strong) UIColor *indicatorColor;

@property (nonatomic) NSInteger direction;

-(void)setIncatorViewCenterWithFactor:(CGFloat)factor direction:(NSInteger)direct;
@end
