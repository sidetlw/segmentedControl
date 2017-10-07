//
//  GUTabControl.m
//  GearUI
//
//  Created by sidetang on 2017/10/1.
//

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
        _unselectedColor = [UIColor whiteColor];
        _selectedColor = [UIColor whiteColor];
        _indicatorColor = [UIColor whiteColor];
        _isFirst = false;
    }
    return self;
}

- (void)layoutSubviews {
    [self updateSubViews];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    [self setNeedsLayout];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            if ([button.titleLabel.text isEqualToString:_titles[self.currentPage]]) {
                [button setTitleColor:self.selectedColor forState:UIControlStateNormal];
            }
            else {
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
    }
    
}

- (void)setSelectedColor:(UIColor *)color{
    _selectedColor = color;
    [self setNeedsLayout];
}

- (void)setUnSelectedColor:(UIColor *)color {
    _unselectedColor = color;
    [self setNeedsLayout];
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    NSArray<NSString *> *array = [titles copy];
    _titles = array;
    
    for (UIView *view in self.subviews) {
        if (view != _indicatorView) {
             [view removeFromSuperview];
        }
    }
    
    for (int i = 0; i < _titles.count; i++) {
        CGSize size = self.bounds.size;
        CGFloat buttonWidth = size.width / (CGFloat)_titles.count;
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(buttonWidth * (CGFloat)i, 0, buttonWidth, size.height)];
        button.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [button setTitle:[_titles objectAtIndex:i] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
        button.tag = 100 + i;
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    } //for
}

- (void)buttonTapped:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)sender;
        NSInteger index = [_titles indexOfObject:button.titleLabel.text];
        self.currentPage = index;
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
    CGFloat buttonWidth = self.bounds.size.width / (CGFloat)_titles.count;
    self.indicatorView.center = CGPointMake(buttonWidth * (_currentPage + 1) - (buttonWidth / 2.0), self.bounds.size.height - 1);
 
    if (self.isFirst == false && _indicatorView.center.x < buttonWidth) {
        self.isFirst = true;
        _originCenter = _indicatorView.center;
    }
}

-(void)setIncatorViewCenterWithFactor:(CGFloat)factor direction:(NSInteger)direct {
    if (_indicatorView == nil) {
        return;
    }
    
    if (factor < 0.0 || factor > 1.0) {
        return;
    }
    
    _direction = direct;
    
    CGFloat buttonWidth = self.bounds.size.width / (CGFloat)_titles.count;
    CGFloat delta = (self.bounds.size.width - (0.5 * buttonWidth) - _originCenter.x) * factor;
    CGFloat finalX = _originCenter.x + delta;
    _indicatorView.center = CGPointMake(finalX, _originCenter.y);
    
    [self setTitleColorGradual:factor];
}

-(void)setTitleColorGradual:(CGFloat)factor {
    if (self.direction == GNScrollDirectionLeft) {
        if (self.currentPage == self.titles.count - 1) {
            return;
        }
        
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                if ([button.titleLabel.text isEqualToString:_titles[self.currentPage]]) {
                    UIColor *gradiulColor = [self colorBetween:self.selectedColor and:[UIColor whiteColor] distance:factor];
                    [button setTitleColor:gradiulColor forState:UIControlStateNormal];
                }
                else if ([button.titleLabel.text isEqualToString:_titles[self.currentPage + 1]]) {
                    UIColor *gradiulColor = [self colorBetween:[UIColor whiteColor]  and:self.selectedColor  distance:factor];
                    [button setTitleColor:gradiulColor forState:UIControlStateNormal];
                }
            }
        }
    }
    else if (self.direction == GNScrollDirectionRight) {
        if (self.currentPage == 0) {
            return;
        }
        
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                if ([button.titleLabel.text isEqualToString:_titles[self.currentPage]]) {
                    UIColor *gradiulColor = [self colorBetween:self.selectedColor and:[UIColor whiteColor] distance:1.0 - factor];
                    [button setTitleColor:gradiulColor forState:UIControlStateNormal];
                }
                else if ([button.titleLabel.text isEqualToString:_titles[self.currentPage - 1]]) {
                    UIColor *gradiulColor = [self colorBetween:[UIColor whiteColor]  and:self.selectedColor  distance:1.0 - factor];
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
