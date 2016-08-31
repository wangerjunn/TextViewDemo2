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
#import "EJTextAttachment.h"
@interface ViewController () <
    UITextViewDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate>
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
            self.editType = EditFontColor;
            self.newRange = tv.selectedRange;
            self.newstr = [tv.text substringWithRange:self.newRange];
            [self updateTextViewContent];
        }else{
            [self setInitLocation];
        }
        
    } fontSizeBlock:^(CGFloat fontSize) {
        //选择字号
        self.fontSize = fontSize;
        if (tv.selectedRange.length > 0) {
            self.isEdit = YES;
            self.editType = EditFontSize;
            self.newRange = tv.selectedRange;
            self.newstr = [tv.text substringWithRange:self.newRange];
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
                self.editType = EditFontBold;
                break;
            }case 1:
            {
                //下划线
                self.isUnderline = isUnderline;
                self.editType = EditFontUnderline;
                break;
            }case 2:
            {
                //图片
                [self chooseCameraType];
                break;
            }
                
            default:
                break;
        }
        
        if (tv.selectedRange.length > 0 && tag != 2) {
            self.isEdit = YES;
            self.newRange = tv.selectedRange;
            self.newstr = [tv.text substringWithRange:self.newRange];
            [self updateTextViewContent];
        }else{
            [self setInitLocation];
        }
        
    } clickDoneBlock:^{
        //点击关闭
        [self.view endEditing:YES];
        [self updateTextViewContent];
    }];
    
    tv.inputAccessoryView = inputAccessView;
    
}

- (void)chooseCameraType {
    [self.view endEditing:YES];
    
    
    __weak typeof(self) weakSelf=self;
    UIAlertController * alertVC=[UIAlertController alertControllerWithTitle:@"选择照片" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf selectedImage];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

-(void)selectedImage
{
    
    NSUInteger sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    
    imagePickerController.allowsEditing = NO;
    
    imagePickerController.sourceType = sourceType;
    
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}


#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    //    // 保存图片至本地，方法见下文
    //    NSLog(@"img = %@",image);
    
    if (tv.attributedText.length>0) {
        [self appenReturn];
    }
    
    EJTextAttachment *ejTextAttachment = [[EJTextAttachment alloc]initWithData:nil ofType:nil];
    ejTextAttachment.image = image;
    
    NSMutableAttributedString *mutableAttri = [[NSMutableAttributedString alloc]initWithAttributedString:tv.attributedText];
    
    [mutableAttri insertAttributedString:[NSAttributedString attributedStringWithAttachment:ejTextAttachment]
                                 atIndex:tv.selectedRange.location];
    tv.attributedText = mutableAttri;
    [self setInitLocation];
    
     [self appenReturn];
    
    tv.selectedRange = NSMakeRange(self.locationStr.length, 0);
    //图片添加后 自动换行
//    [self setImageText:image withRange:self.textView.selectedRange appenReturn:YES];
    
//    [self.textView becomeFirstResponder];
    
}

-(void)appenReturn
{
    NSAttributedString * returnStr=[[NSAttributedString alloc]initWithString:@"\n"];
    NSMutableAttributedString * att=[[NSMutableAttributedString alloc]initWithAttributedString:tv.attributedText];
    [att appendAttributedString:returnStr];
    
    tv.attributedText=att;
}


//把最新内容都赋给self.locationStr
-(void)setInitLocation
{

    self.locationStr=nil;
    self.locationStr=[[NSMutableAttributedString alloc]initWithAttributedString:tv.attributedText];
    
}

#pragma mark -- 更新textview内容
- (void)updateTextViewContent {
    
    [self setInitLocation];
    
    if (self.isDelete) {
        return;
    }
    
    if (self.isEdit) {
        
        if (self.editType == EditFontUnderline) {
            [self.locationStr enumerateAttribute:NSForegroundColorAttributeName inRange:self.newRange options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
                
                if (self.isUnderline) {
                    NSString *colorValue = [NSString stringWithFormat:@"%@",value];
                    NSArray *colorArr = [colorValue componentsSeparatedByString:@" "];
                    UIColor *color = [UIColor colorWithRed:[colorArr[1] floatValue] green:[colorArr[2] floatValue] blue:[colorArr[3] floatValue] alpha:[[colorArr lastObject] floatValue]];
                    [self.locationStr addAttribute:NSUnderlineColorAttributeName value:color range:range];
                    [self.locationStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:1] range:range];
                }else{
                    [self.locationStr removeAttribute:NSUnderlineColorAttributeName range:range];
                    [self.locationStr removeAttribute:NSUnderlineStyleAttributeName range:range];
                }
                
            }];
        }else if (self.editType == EditFontColor){
            [self.locationStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:self.color] range:self.newRange];
        }else{
            [self.locationStr enumerateAttribute:NSFontAttributeName inRange:self.newRange options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
                UIFont *font = (UIFont *)value;
                NSString *fontValue = [NSString stringWithFormat:@"%@",value];
                NSRange boldRange = [fontValue rangeOfString:@"bold"];
                
                switch (self.editType) {
                    case EditFontBold:
                    {
                        //加粗
                        if (self.isBold) {
                            [self.locationStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:font.pointSize] range:range];
                        }else{
                            [self.locationStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font.pointSize] range:range];
                        }
                        break;
                    }case EditFontSize:{
                        //字号
                        if (boldRange.location != NSNotFound) {
                            [self.locationStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:self.fontSize] range:range];
                        }else{
                            [self.locationStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.fontSize] range:range];
                        }
                        break;
                    }
                        
                    default:
                        break;
                }
                
            }];
        }
        
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

        }
        else
        {
                NSLog(@"没有转化--%@",str);
            
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
