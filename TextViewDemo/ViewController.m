//
//  ViewController.m
//  TextViewDemo
//
//  Created by 花花 on 16/8/30.
//  Copyright © 2016年 花花. All rights reserved.
//

#import "ViewController.h"
#import "KeyboardInputAccessView.h"
#import "UIColor+Hex.h"

@interface ViewController () <UITextViewDelegate>
{
    UITextView *tv;
}

@property (assign, nonatomic) BOOL isEdit;//是否在编辑状态
@property (assign, nonatomic) BOOL isDelete;
@property (assign, nonatomic) BOOL isBold; //是否加粗
@property (assign, nonatomic) BOOL isUnderline;
@property (assign, nonatomic) CGFloat fontSize;
@property (copy, nonatomic) NSString * color;
@property (copy, nonatomic) NSString * newstr;
@property (assign, nonatomic) NSRange newRange;
@property (strong, nonatomic) NSMutableAttributedString *locationStr;



@end

@implementation ViewController

- (void)initDefaultInfo {
    self.color = @"010101";
    self.fontSize = 15;
    self.newstr = @"";
    self.newRange = NSMakeRange(0, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initDefaultInfo];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f2f3"];
    
    tv = [[UITextView alloc]initWithFrame:CGRectMake(10, 60, 300, 100)];
    tv.layer.cornerRadius = 8;
    tv.layer.borderColor = [UIColor redColor].CGColor;
    tv.layer.borderWidth = 1.0;
    tv.layer.masksToBounds = YES;
    tv.delegate = self;
    [self.view addSubview:tv];
    
    KeyboardInputAccessView *inputAccessView = [[KeyboardInputAccessView alloc]initKeyboardInputAccessViewWithTextColorBlock:^(NSString *color) {
        //选择字体颜色
        self.color = color;
        if (tv.selectedRange.length > 0) {
            self.isEdit = YES;
            self.newRange = tv.selectedRange;
            self.newstr = [tv.text substringWithRange:self.newRange];
            [self updateTextViewContent];
        }else{
            [self setInitLocation];
        }
        
    } fontSizeBlock:^(CGFloat fontSize) {
        //选择字号
        self.fontSize = fontSize;
//        [self setInitLocation];
        if (tv.selectedRange.length > 0) {
            
            [self updateTextViewContent];
        }else{
            [self setInitLocation];
        }
    } otherBlock:^(BOOL isBold, BOOL isUnderline, NSInteger tag) {
        //点击 加粗，下划线，图片
        switch (tag) {
            case 0:
            {
                //加粗
                self.isBold = isBold;
                break;
            }case 1:
            {
                //下划线
                self.isUnderline = isUnderline;
                break;
            }case 2:
            {
                //图片
                break;
            }
                
            default:
                break;
        }
        [self setInitLocation];
    } clickDoneBlock:^{
        //点击关闭
    }];
    
    tv.inputAccessoryView = inputAccessView;
    
}

//把最新内容都赋给self.locationStr
-(void)setInitLocation
{

    self.locationStr=nil;
    self.locationStr=[[NSMutableAttributedString alloc]initWithAttributedString:tv.attributedText];
//    if (self.textView.textStorage.length>0) {
//        self.placeholderLabel.hidden=YES;
//    }
    
}

#pragma mark -- 更新textview内容
- (void)updateTextViewContent {
    
    [self setInitLocation];
    
    if (self.isDelete) {
        return;
    }
    
    if (self.isEdit) {
        [self.locationStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:self.color] range:self.newRange];
        tv.attributedText = self.locationStr;
        self.isEdit = NO;
    }else{
        NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
        
        [mDic setValue:[UIColor colorWithHexString:self.color] forKey:NSForegroundColorAttributeName];
        if (self.isBold) {
            [mDic setValue:[UIFont boldSystemFontOfSize:self.fontSize] forKey:NSFontAttributeName];
        }else{
            [mDic setValue:[UIFont systemFontOfSize:self.fontSize] forKey:NSFontAttributeName];
        }
        if (self.isUnderline) {
            [mDic setValue:[NSNumber numberWithInteger:1] forKey:NSUnderlineStyleAttributeName];
            [mDic setValue:[UIColor colorWithHexString:self.color] forKey:NSUnderlineColorAttributeName];
        }
        
        
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]initWithString:self.newstr attributes:mDic];
        
        [self.locationStr replaceCharactersInRange:self.newRange withAttributedString:attri];
        
        tv.attributedText = self.locationStr;
    }
    
    
}


- (void)textViewDidChange:(UITextView *)textView {
    NSInteger len = textView.attributedText.length - self.locationStr.length;
    if (len > 0) {
        self.isDelete = NO;
        self.newRange = NSMakeRange(textView.selectedRange.location-len, len);
        self.newstr = [textView.text substringWithRange:self.newRange];
        
    }else{
        //删除
        self.isDelete = YES;
    }
    
    BOOL isChinese;
    if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"en-US"]) {
        isChinese = NO;
    }else{
        isChinese = YES;
    }
    
    NSString *str = [textView.text stringByReplacingOccurrencesOfString:@"?" withString:@""];
    if (isChinese) {
        //中文输入法
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            //            NSLog(@"汉字");
            [self updateTextViewContent];
//            if ( str.length>=MaxLength) {
//                NSString *strNew = [NSString stringWithString:str];
//                [ self.textView setText:[strNew substringToIndex:MaxLength]];
//            }
        }
        else
        {
                NSLog(@"没有转化--%@",str);
//            if ([str length]>=MaxLength+10) {
//                NSString *strNew = [NSString stringWithString:str];
//                [ self.textView setText:[strNew substringToIndex:MaxLength+10]];
//            }
            
        }
    }else{
        [self updateTextViewContent];
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (range.length == 1) {
        //删除
        return YES;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






























@end
