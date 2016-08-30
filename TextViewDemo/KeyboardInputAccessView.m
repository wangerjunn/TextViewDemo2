//
//  KeyboardInputAccessView.m
//  BeStudent_Teacher
//
//  Created by 花花 on 16/8/17.
//  Copyright © 2016年 花花. All rights reserved.
//

#import "KeyboardInputAccessView.h"
#import "UIColor+Hex.h"
#import "FontColorView.h"//字色
#import "FontSizeView.h"//字号view
@implementation KeyboardInputAccessView
{
    FontColorView *fontColorView;
    FontSizeView *fontSizeView;
    UIColor *curChooseColor;
    
    BOOL isBold;
    BOOL isUnderline;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initKeyboardInputAccessViewWithTextColorBlock:(ChooseTextColorResultBlock)textColorBlock fontSizeBlock:(ChooseFontSizeResultBlock)fontSzieBlock
    otherBlock:(ChooseOtherBlock)otherBlock
    clickDoneBlock:(ClickActDoneBlock)clickDoneBlock{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 35)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.textColorBlock = textColorBlock;
        self.fontSizeBlock = fontSzieBlock;
        self.otherBlock = otherBlock;
        self.clickDoneBlock = clickDoneBlock;
        [self initContentUI];
    }
    
    return self;
}

- (void)initContentUI {
    
    NSArray *arr = @[@"chooseImage",@"fontBold",@"underline",@"fontSize",@"fontColor"];
    for (int i = 0; i < arr.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*50, 0, 40, 35)];
        
        UIImageView *img_icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:arr[i]]];
        
        img_icon.frame = CGRectMake(CGRectGetWidth(btn.frame)/2.0-CGRectGetWidth(img_icon.frame)/2.0,
                                    CGRectGetHeight(btn.frame)/2.0-CGRectGetHeight(img_icon.frame)/2.0,
                                    CGRectGetWidth(img_icon.frame), CGRectGetHeight(img_icon.frame));
        img_icon.tag = 100;
        [btn addSubview:img_icon];
        btn.tag = i+1;
        
        [btn addTarget:self
                action:@selector(chooseOperationType:)
      forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        
    }
    
    UIButton *btn_done = [[UIButton alloc]initWithFrame:CGRectMake(320-30-28, 0, 30+28, self.frame.size.height)];
    
    [btn_done setTitle:@"完成" forState:UIControlStateNormal];
    btn_done.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn_done setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn_done addTarget:self
                 action:@selector(editDone)
       forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btn_done];
    
    UIImageView *img_line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 0.5)];
    img_line.backgroundColor = [UIColor redColor];
    [self addSubview:img_line];
    
}

#pragma mark -- 图片| 加粗 | 下划线 | 字号 | 字色
- (void)chooseOperationType:(UIButton *)btn {
    
    UIImageView *img = (UIImageView *)[btn viewWithTag:100];
    switch (btn.tag) {
        case 1:
        {
            //图片
            if (self.otherBlock) {
                self.otherBlock(isBold,isUnderline,2);
            }
            break;
        }case 2:
        {
            //加粗
            if (btn.selected) {
                btn.selected = NO;
                isBold = NO;
                img.image = [UIImage imageNamed:@"fontBold"];
            }else{
                btn.selected = YES;
                isBold = YES;
                img.image = [UIImage imageNamed:@"fontBoldSelected"];
            }
            
            if (self.otherBlock) {
                self.otherBlock(isBold,isUnderline,0);
            }
            
            break;
        }case 3:
        {
            //下划线
            if (btn.selected) {
                btn.selected = NO;
                isUnderline = NO;
                img.image = [UIImage imageNamed:@"underline"];
            }else{
                btn.selected = YES;
                isUnderline = YES;
                img.image = [UIImage imageNamed:@"underlineSelected"];
            }
            
            if (self.otherBlock) {
                self.otherBlock(isBold,isUnderline,1);
            }
            break;
        }case 4:
        {
            [self removeFontColorView];
            
            //字号
            if (!fontSizeView) {
                CGFloat wdt_view = 105;
                CGFloat hgt_view = 40;
                CGRect rect = CGRectMake(CGRectGetMinX(btn.frame)+CGRectGetWidth(btn.frame)/2.0-wdt_view/2.0, CGRectGetMinY(self.superview.frame)-hgt_view-5, wdt_view, hgt_view);
                fontSizeView = [[FontSizeView alloc]initFontSizeViewByFrame:rect fontColorBlock:^(CGFloat fontSize) {
                    if (self.fontSizeBlock) {
                        self.fontSizeBlock(fontSize);
                        
                    }
                }];
            }else{
                [fontSizeView show];
            }
            
            break;
        }case 5:
        {
            //字色
            [self removeFontSizeView];
            
            if (!fontColorView) {
                CGFloat wdt_view = 185;
                CGFloat hgt_view = 80;
                
                CGRect rect = CGRectMake(CGRectGetMinX(btn.frame)+CGRectGetWidth(btn.frame)/2.0-wdt_view/2.0, CGRectGetMinY(self.superview.frame)-hgt_view-5, wdt_view, hgt_view);
                fontColorView = [[FontColorView alloc]initFontColorViewByFrame:rect fontColorBlock:^(NSString *color) {
                    
                    if (color) {
                        img.image = [UIImage imageNamed:@""];
                        [btn setTitle:@"A" forState:UIControlStateNormal];
                        [btn setTitleColor:[UIColor colorWithHexString:color] forState:UIControlStateNormal];
                        btn.titleLabel.font = [UIFont systemFontOfSize:15];
                    }
                    curChooseColor = [UIColor colorWithHexString:color];
                    if (self.textColorBlock) {
                        self.textColorBlock(color);
                    }
                    
                }];
            }else{
                [fontColorView show];
            }
            
            break;
        }
            
        default:
            break;
    }
}

#pragma mark -- 点击完成
- (void)editDone {
    
    [self removeFontSizeView];
    [self removeFontColorView];
    
    if (self.clickDoneBlock) {
        self.clickDoneBlock();
    }
}

- (void)removeFontSizeView {
    if (fontSizeView) {
        [fontSizeView removeFromSuperview];
//        fontSizeView = nil;
    }
}

- (void)removeFontColorView {
    if (fontColorView) {
        [fontColorView removeFromSuperview];
//        fontColorView = nil;
    }
}

- (void)removeAllView {
    [self removeFontColorView];
    [self removeFontSizeView];
}

@end
