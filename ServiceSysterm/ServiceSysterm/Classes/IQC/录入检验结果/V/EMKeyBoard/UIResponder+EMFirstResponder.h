//
//  UIResponder+EMFirstResponder.h
//  XXXXXXXXX
//
//  Created by Andy on 2021/9/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (EMFirstResponder)

+ (void)inputText:(NSString *)text;

+ (UIResponder *)EMTradeCurrentFirstResponder;

+ (UIView <UITextInput> *)firstResponderTextView;

@end

NS_ASSUME_NONNULL_END
