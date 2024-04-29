//
//  EMKeyBoardButton.m
//  XXXXXXXXX
//
//  Created by Andy on 2021/9/18.
//

#import "EMKeyBoardButton.h"
#import "UIImage+EMColor.h"
@implementation EMKeyBoardButton

- (void)setKeyboardButtonType:(EMKeyboardButtonType)KeyboardButtonType{
    _KeyboardButtonType = KeyboardButtonType;
    
    [self setBackgroundImage:[UIImage imageWithColor:kEMKeyboardBtnHighhlightColor] forState:UIControlStateSelected];
    switch (KeyboardButtonType) {
        case EMKeyboardButtonTypeNumber:{
            [self configKeyboardButtonTypeWithIsFunctionKeyBoard:NO];
            [self configKeyboardButtonTypeWithisNumberKeyBoard:YES];
        }
            break;
            
        case EMKeyboardButtonTypeDelete:{
            [self setImage:[UIImage imageNamed:@"button_backspace_delete"] forState:UIControlStateNormal];
            [self configKeyboardButtonTypeWithIsFunctionKeyBoard:YES];
            [self configKeyboardButtonTypeWithisNumberKeyBoard:YES];
        }
            break;
            
    
            
        case EMKeyboardButtonTypeResign:{
            [self setImage:[UIImage imageNamed:@"button_keyboard_shouqi"] forState:UIControlStateNormal];
            [self configKeyboardButtonTypeWithIsFunctionKeyBoard:YES];
            [self configKeyboardButtonTypeWithisNumberKeyBoard:YES];
        }
            break;
            
        case EMKeyboardButtonTypeComplete:{
            [self setTitle:@"下一项" forState:UIControlStateNormal];
            [self configKeyboardButtonTypeWithIsFunctionKeyBoard:YES];
            [self configKeyboardButtonTypeWithisNumberKeyBoard:YES];
        }
            break;
            
        case EMKeyboardButtonTypeDecimal:{
            [self setTitle:@"." forState:UIControlStateNormal];
            [self configKeyboardButtonTypeWithIsFunctionKeyBoard:NO];
            [self configKeyboardButtonTypeWithisNumberKeyBoard:YES];
        }
            break;
            
            
            
        default:
            break;
    }
}
- (void)configKeyboardButtonTypeWithisNumberKeyBoard:(BOOL)isNumberKeyBoard{
    self.layer.borderWidth = kEMASCIIKeyboardBtnBorderWith;
    self.layer.borderColor = [kEMKeyboardBtnLayerColor CGColor];
}

/**
 功能按钮和可输入按钮样式

 @param isFunctionKeyBoard 是否是功能按钮
 */
- (void)configKeyboardButtonTypeWithIsFunctionKeyBoard:(BOOL)isFunctionKeyBoard
{
    if (isFunctionKeyBoard) {
        [self setTitleColor:kEMKeyboardBtnLightTitleColor forState:UIControlStateNormal];
        self.titleLabel.font = kEMKeyboardBtnSmallFont;
        [self setBackgroundImage:[UIImage imageWithColor:kEMKeyboardBtnDefaultColor] forState:UIControlStateNormal];
        
    }else{
        [self setTitleColor:kEMKeyboardBtnDarkTitleColor forState:UIControlStateNormal];
        self.titleLabel.font = kEMKeyboardBtnBigFont;
        [self setBackgroundImage:[UIImage imageWithColor:kEMKeyboardBtnWhiteColor] forState:UIControlStateNormal];
    }
}
@end
