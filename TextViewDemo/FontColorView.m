//
//  FontColorView.m
//  BeStudent_Teacher
//
//  Created by 花花 on 16/8/17.
//  Copyright © 2016年 花花. All rights reserved.
//

#import "FontColorView.h"
#import "UIColor+Hex.h"

@implementation FontColorView
{
    UIImageView *fontView;
    NSArray *colorArr;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initFontColorViewByFrame:(CGRect)frame
                          fontColorBlock:(FontColorResultBlock)fontColorBlock {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.fontColorBlock = fontColorBlock;
        fontView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        fontView.userInteractionEnabled = YES;
        fontView.image = [UIImage imageNamed:@"fontColorBg"];
        [self addSubview:fontView];
        
        
        CGFloat wdt_btn = 30;
        colorArr = @[@"C10000",@"FF4A38",@"940086",@"FF9D00",@"407600",@"3F7F83",@"006FC4",@"003E82",@"808080",@"010101"];
        
        CGFloat coorY = 5;
        for (int i = 0; i < 2; i++) {
            
            CGFloat coorX = 5;
            
            for (int j = 0; j < 5; j++) {
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(coorX, coorY, wdt_btn, wdt_btn)];
                btn.tag = i*5+j+1;
                btn.backgroundColor = [UIColor colorWithHexString:colorArr[btn.tag-1]];
                [btn addTarget:self
                        action:@selector(chooseTextColor:)
              forControlEvents:UIControlEventTouchUpInside];
                [fontView addSubview:btn];
                
                coorX += wdt_btn + 5;
                if (j == 4) {
                    coorX = 5;
                    coorY = wdt_btn+coorY+5;
                }
                
            }
        }
        
        
        [self show];
    }
    
    return self;
}

#pragma mark -- 选择文字颜色
- (void)chooseTextColor:(UIButton *)btn {
    if (self.fontColorBlock) {
        self.fontColorBlock(colorArr[btn.tag-1]);
    }
    
    [self removeFromSuperview];
    
}

- (void)show {
    [UIView animateWithDuration:0.25 animations:^{
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }];
}

@end
