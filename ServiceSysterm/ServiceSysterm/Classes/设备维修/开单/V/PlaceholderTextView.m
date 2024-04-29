//
//  PlaceholderTextView.m
//  FlyWithAll
//
//  Created by andy on 2017/8/8.
//  Copyright © 2017年 Groupfly. All rights reserved.
//

#import "PlaceholderTextView.h"


@interface PlaceholderTextView ()


/**占位文字符号 **/

@property (nonatomic,strong) UIColor *placeholderColor;

@end
@implementation PlaceholderTextView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //设置默认字体
        self.font = [UIFont systemFontOfSize:15];
        
        //设置默认颜色
        self.placeholderColor = [UIColor lightGrayColor];
        self.placeholder =@"请输入回仓原因";
        
        //使用通知监听文字改变
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}
-(void)textDidChange:(NSNotification *)note{
    [self setNeedsDisplay];
}
/**调用drawrect 会把之前的东西清空**/

-(void)drawRect:(CGRect)rect{
    //如果有文字  直接返回
    if (self.hasText) return;
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = self.placeholderColor;
    
    //画文字
    rect.origin.x = 0;
    rect.origin.y = 6;
    rect.size.width -= rect.origin.x;
    [self.placeholder drawInRect:rect withAttributes:attrs];
    self.placeholderColor = RGBA(242, 242, 242, 1);
    
        
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self setNeedsDisplay];
}

#pragma mark = setter
-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = [placeholder copy];
    [self setNeedsDisplay];
}
-(void)setFont:(UIFont *)font{
    [super setFont:font];
    [self setNeedsDisplay];
}
-(void)setText:(NSString *)text{
    [super setText:text];
    [self setNeedsDisplay];
}

-(void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
