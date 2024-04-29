//
//  UITextView+Placeholder.h
//  ServiceSysterm
//
//  Created by Andy on 2019/6/20.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (Placeholder)
@property (nonatomic, readonly) UILabel *placeholderLabel;

@property (nonatomic, strong) IBInspectable NSString *placeholder;
@property (nonatomic, strong) NSAttributedString *attributedPlaceholder;
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;
+ (UIColor *)defaultPlaceholderColor;
@end

NS_ASSUME_NONNULL_END
