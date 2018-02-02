//
//  GUTabControl.m
//  GearUI
//
//  Created by sidetang on 2017/10/1.
//  Copyright © 2017年 Tencent home voice assitance. All rights reserved.

#import "GUTabControl.h"

@interface GUTabControl()
typedef NS_ENUM(NSInteger, GNScrollDirection) {
    GNScrollDirectionNone = 0,
    GNScrollDirectionRight = 1,
    GNScrollDirectionLeft = 2,
    GNScrollDirectionUp,
    GNScrollDirectionDown,
    GNScrollDirectionCrazy,
};

@property (nonatomic,strong) UIView *indicatorView;
@property (nonatomic) CGPoint originCenter;
@property (nonatomic) BOOL isFirst;
@end

@implementation GUTabControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _unSelectedColor = [UIColor whiteColor];
        _selectedColor = [UIColor whiteColor];
        _indicatorColor = [UIColor whiteColor];
        _isFirst = false;
        
    }
    return self;
}

- (void)layoutSubviews {
    [self updateSubViews];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    [self setNeedsLayout];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            if ([button.titleLabel.text isEqualToString:_items[self.selectedIndex]]) {
                [button setTitleColor:self.selectedColor forState:UIControlStateNormal];
            }
            else {
                [button setTitleColor:self.unSelectedColor forState:UIControlStateNormal];
            }
        }
    }
}

- (void)setSelectedColor:(UIColor *)color{
    _selectedColor = color;
    [self setNeedsLayout];
//    [self setSelectedIndex:_selectedIndex];
}

- (void)setUnSelectedColor:(UIColor *)color {
    _unSelectedColor = color;
    [self setNeedsLayout];
//    [self setSelectedIndex:_selectedIndex];
}

- (void)setItems:(NSArray<NSString *> *)titles {
    NSArray<NSString *> *array = [titles copy];
    _items = array;
    
    for (UIView *view in self.subviews) {
        if (view != _indicatorView) {
             [view removeFromSuperview];
        }
    }
    
    CGSize size = self.bounds.size;
    CGFloat buttonWidth = size.width / (CGFloat)_items.count;
    for (int i = 0; i < _items.count; i++) {
       
        
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(buttonWidth * (CGFloat)i, 0, buttonWidth, size.height)];
        button.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [button setTitle:[_items objectAtIndex:i] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
        button.tag = 100 + i;
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    } //for
    
    _originCenter = CGPointMake(buttonWidth / 2.0, self.bounds.size.height - 1);
}

- (void)buttonTapped:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)sender;
        NSInteger index = [_items indexOfObject:button.titleLabel.text];
        self.selectedIndex = index;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (UIView *)indicatorView {
    if (_indicatorView == nil) {
        _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 33, 2)];
        _indicatorView.backgroundColor = _indicatorColor;
        [self addSubview:_indicatorView];
    }
    return _indicatorView;
}

- (void)updateSubViews {
    CGFloat buttonWidth = self.bounds.size.width / (CGFloat)_items.count;
    self.indicatorView.center = CGPointMake(buttonWidth * (_selectedIndex + 1) - (buttonWidth / 2.0), self.bounds.size.height - 1);
}

-(void)setIncatorViewCenterWithFactor:(CGFloat)factor direction:(NSInteger)direct {
    if (_indicatorView == nil) {
        return;
    }
    
    if (factor < 0.0 || factor > 1.0) {
        return;
    }
    
    _direction = direct;
    
    CGFloat buttonWidth = self.bounds.size.width / (CGFloat)_items.count;
    CGFloat delta = buttonWidth * factor;
    NSInteger index = self.selectedIndex;
    if (self.selectedIndex >= 1 && direct == 1) {
        index = self.selectedIndex - 1;
    }
    CGFloat finalX = _originCenter.x + delta + (buttonWidth * index);
    _indicatorView.center = CGPointMake(finalX, _originCenter.y);
    
    [self setTitleColorGradual:factor];
}

-(void)setTitleColorGradual:(CGFloat)factor {
    if (self.direction == GNScrollDirectionLeft) {
        if (self.selectedIndex == self.items.count - 1) {
            return;
        }
        
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                if ([button.titleLabel.text isEqualToString:_items[self.selectedIndex]]) {
                    UIColor *gradiulColor = [self colorBetween:self.selectedColor and:self.unSelectedColor distance:factor];
                    [button setTitleColor:gradiulColor forState:UIControlStateNormal];
                }
                else if ([button.titleLabel.text isEqualToString:_items[self.selectedIndex + 1]]) {
                    UIColor *gradiulColor = [self colorBetween:self.unSelectedColor  and:self.selectedColor distance:factor];
                    [button setTitleColor:gradiulColor forState:UIControlStateNormal];
                }
            }
        }
    }
    else if (self.direction == GNScrollDirectionRight) {
        if (self.selectedIndex == 0) {
            return;
        }
        
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                if ([button.titleLabel.text isEqualToString:_items[self.selectedIndex]]) {
                    UIColor *gradiulColor = [self colorBetween:self.selectedColor and:self.unSelectedColor distance:1.0 - factor];
                    [button setTitleColor:gradiulColor forState:UIControlStateNormal];
                }
                else if ([button.titleLabel.text isEqualToString:_items[self.selectedIndex - 1]]) {
                    UIColor *gradiulColor = [self colorBetween:self.unSelectedColor  and:self.selectedColor distance:1.0 - factor];
                    [button setTitleColor:gradiulColor forState:UIControlStateNormal];
                }
            }
        }
    }
}

- (UIColor *)colorBetween:(UIColor *)colorA and:(UIColor *)colorB distance:(CGFloat)pct {
    CGFloat aR, aG, aB, aA;
    [colorA getRed:&aR green:&aG blue:&aB alpha:&aA];
    
    CGFloat bR, bG, bB, bA;
    [colorB getRed:&bR green:&bG blue:&bB alpha:&bA];
    
    CGFloat rR = (1.0-pct)*aR + pct*bR;
    CGFloat rG = (1.0-pct)*aG + pct*bG;
    CGFloat rB = (1.0-pct)*aB + pct*bB;
    CGFloat rA = (1.0-pct)*aA + pct*bA;
    
    return [UIColor colorWithRed:rR green:rG blue:rB alpha:rA];
}
@end
