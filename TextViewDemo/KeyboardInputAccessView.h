//
//  KeyboardInputAccessView.h
//  BeStudent_Teacher
//
//  Created by 花花 on 16/8/17.
//  Copyright © 2016年 花花. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChooseTextColorResultBlock)(NSString *color);
typedef void(^ChooseFontSizeResultBlock)(CGFloat fontSize);

/*
    tag = 0，是否加粗
    tag = 1，是否包含下划线
    tag = 2，是否显示相机
 */
typedef void(^ChooseOtherBlock)(BOOL isBold,BOOL isUnderline,NSInteger tag);
typedef void(^ClickActDoneBlock)();

@interface KeyboardInputAccessView : UIView

@property (copy, nonatomic) ChooseTextColorResultBlock textColorBlock;
@property (copy, nonatomic) ChooseFontSizeResultBlock fontSizeBlock;
@property (copy, nonatomic) ChooseOtherBlock otherBlock;
@property (copy, nonatomic) ClickActDoneBlock clickDoneBlock;

- (instancetype)initKeyboardInputAccessViewWithTextColorBlock:(ChooseTextColorResultBlock)textColorBlock
    fontSizeBlock:(ChooseFontSizeResultBlock)fontSzieBlock
    otherBlock:(ChooseOtherBlock)otherBlock
    clickDoneBlock:(ClickActDoneBlock)clickDoneBlock;

- (void)removeAllView;
@end
