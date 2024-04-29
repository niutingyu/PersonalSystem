//
//  EMCustomKeyboardView.m
//  XXXXXXXXX
//
//  Created by Andy on 2021/9/18.
//

#import "EMCustomKeyboardView.h"
#import "EMKeyBoardButton.h"
#import "UIImage+EMColor.h"
#import "UIResponder+EMFirstResponder.h"
#import "UIView+EMUIView.h"
@interface EMCustomKeyboardView ()

/**
 完成键
 */
@property (nonatomic,strong)EMKeyBoardButton *completeBut;

@end
@implementation EMCustomKeyboardView

-(instancetype)init{
    if (self =[super init]) {
        self.frame = CGRectMake(0, 0, kEMScreenWidth, kEMCustomKeyboardHeight);
        [self createKeyBoard];
    }
    return self;
}



- (void)createKeyBoard{
   
    int col = 0;
    NSArray *keyBoards = nil;
    col = 4;
    keyBoards = @[@(7),@(8),@(9),@(EMKeyboardButtonTypeDelete),@(4),@(5),@(6),@(EMKeyboardButtonTypeNone),@(1),@(2),@(3),@(EMKeyboardButtonTypeDecimal),@(EMKeyboardButtonTypeComplete),@(0),@(EMKeyboardButtonTypeResign),@(EMKeyboardButtonTypeNone)];
    
    CGFloat btnWidth = kEMScreenWidth / col;
    for (int i = 0; i < keyBoards.count; i++) {
        NSInteger keyBoardType = [[keyBoards objectAtIndex:i] integerValue];
        EMKeyBoardButton *btn = [EMKeyBoardButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i % col * btnWidth, i / col * kEMNumberKeyboardBtnHeight, btnWidth, kEMNumberKeyboardBtnHeight);
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:btn];
        
        if (keyBoardType < EMKeyboardButtonTypeNone) {
            btn.KeyboardButtonType = EMKeyboardButtonTypeNumber;
            [btn setTitle:[NSString stringWithFormat:@"%zd",keyBoardType] forState:UIControlStateNormal];
        }else{
            btn.KeyboardButtonType = keyBoardType;
        }
        
        //删除按钮占两格
        if (keyBoardType == EMKeyboardButtonTypeDelete) {
            btn.frame = CGRectMake(i % col * btnWidth, i / col * kEMNumberKeyboardBtnHeight, btnWidth, kEMNumberKeyboardBtnHeight * 2);
            [btn setBackgroundImage:[UIImage imageWithColor:kEMKeyboardBtnWhiteColor] forState:UIControlStateNormal];
        }else if (keyBoardType == EMKeyboardButtonTypeDecimal){
            btn.frame = CGRectMake(i % col * btnWidth, i / col * kEMNumberKeyboardBtnHeight, btnWidth, kEMNumberKeyboardBtnHeight * 2);
        }
        else if (keyBoardType == EMKeyboardButtonTypeNone){
            btn.frame = CGRectZero;
        }else if (keyBoardType == EMKeyboardButtonTypeComplete){
            self.completeBut =btn;
        }
    }
}
- (void)btnClick:(EMKeyBoardButton *)sender{
    UIView <UITextInput> *textView = [UIResponder firstResponderTextView];
    switch (sender.KeyboardButtonType) {
        case EMKeyboardButtonTypeNumber:
        case EMKeyboardButtonTypeDecimal:{
            [self inputNumber:sender.titleLabel.text];
        }
            
            break;
        case EMKeyboardButtonTypeDelete:{
            [textView deleteBackward];
        }
            break;
        case EMKeyboardButtonTypeComplete:{
            [self goToNextResponderOrResign:self.subView];
            
        }
            break;
        case EMKeyboardButtonTypeResign:
            [textView resignFirstResponder];
        default:
            break;
    }
    
}

/**
 输入文字

 @param text text
 */
- (void)inputNumber:(NSString *)text
{
    [UIResponder inputText:text];
}

-(void)setSubView:(UIView *)subView{
    _subView  =subView;
}

-(void)setTextf:(UITextField *)textf{
    _textf  =textf;
}


-(void)goToNextResponderOrResign:(UIView*)textField{
    NSArray<UIView*> *textFields = nil;
    textFields = [textField deepResponderViews];
    NSUInteger index = [textFields indexOfObject:self.textf];
    //If it is not last textField. then it's next object becomeFirstResponder.
    debugLog(@"--%ld %ld",index,textFields.count);
    if (index != NSNotFound && index < textFields.count-1)
    {
        [textFields[index+1] becomeFirstResponder];
        return ;
    }else if (index == textFields.count -1){
        [self.completeBut setTitle:@"完成" forState:UIControlStateNormal];
        [self.textf resignFirstResponder];
    }
    else
    {
        
        [self.textf resignFirstResponder];
    }
    
}
@end
