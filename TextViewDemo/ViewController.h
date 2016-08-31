//
//  ViewController.h
//  TextViewDemo
//
//  Created by 花花 on 16/8/30.
//  Copyright © 2016年 花花. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    EditFontBold = 1,
    EditFontUnderline,
    EditFontSize,
    EditFontColor,
} EditFontType;

@interface ViewController : UIViewController

@property (assign, nonatomic) EditFontType editType;

@end

