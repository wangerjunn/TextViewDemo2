//
//  FontSizeView.h
//  BeStudent_Teacher
//
//  Created by 花花 on 16/8/17.
//  Copyright © 2016年 花花. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FontSizeBlock)(CGFloat fontSize);

@interface FontSizeView : UIView

@property (copy, nonatomic) FontSizeBlock fontSizeBlock;
- (instancetype)initFontSizeViewByFrame:(CGRect)frame
                          fontColorBlock:(FontSizeBlock)fontSizeBlock;

- (void)show;

@end
