//
//  FontSizeView.m
//  BeStudent_Teacher
//
//  Created by 花花 on 16/8/17.
//  Copyright © 2016年 花花. All rights reserved.
//

#import "FontSizeView.h"
#import "UIColor+Hex.h"

@implementation FontSizeView
{
    UIImageView *fontView;
}

- (instancetype)initFontSizeViewByFrame:(CGRect)frame fontColorBlock:(FontSizeBlock)fontSizeBlock {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.fontSizeBlock = fontSizeBlock;
        fontView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        fontView.userInteractionEnabled = YES;
        fontView.image = [UIImage imageNamed:@"fontSizeBg"];
        [self addSubview:fontView];
        
        
        CGFloat wdt_btn = self.frame.size.width/3.0;
        NSArray *titleArr = @[@"大",@"中",@"小"];
        for (int j = 0; j < titleArr.count; j++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(wdt_btn*j, 8, wdt_btn, 20)];
            btn.tag = j+1;
            [btn setTitle:titleArr[j] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn addTarget:self
                    action:@selector(chooseFontSize:)
          forControlEvents:UIControlEventTouchUpInside];
            [fontView addSubview:btn];
            
        }
        
        
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    
    return self;
    
}

#pragma mark -- 选择字号
- (void)chooseFontSize:(UIButton *)btn {
    
    CGFloat fontSize = 15;
    
    switch (btn.tag) {
        case 1:
        {
            fontSize = 17;
            break;
        }case 2:
        {
            fontSize = 15;
            break;
        }case 3:
        {
            fontSize = 13;
            break;
        }
            
        default:
            break;
    }
    
    if (self.fontSizeBlock) {
        self.fontSizeBlock(fontSize);
    }
    
    [self removeFromSuperview];
}

- (void)show {
    [UIView animateWithDuration:0.25 animations:^{
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }];
}
@end
