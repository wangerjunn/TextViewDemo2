//
//  FontColorView.h
//  BeStudent_Teacher
//
//  Created by 花花 on 16/8/17.
//  Copyright © 2016年 花花. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FontColorResultBlock)(NSString *color);

@interface FontColorView : UIView

@property (nonatomic, copy) FontColorResultBlock fontColorBlock;

- (instancetype)initFontColorViewByFrame:(CGRect)frame
                          fontColorBlock:(FontColorResultBlock)fontColorBlock;

- (void)show;
@end
