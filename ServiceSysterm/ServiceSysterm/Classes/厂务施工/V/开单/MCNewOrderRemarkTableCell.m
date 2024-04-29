//
//  MCNewOrderRemarkTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2020/10/17.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "MCNewOrderRemarkTableCell.h"
#import "UITextView+Placeholder.h"

@interface MCNewOrderRemarkTableCell ()<UITextViewDelegate>

@end
@implementation MCNewOrderRemarkTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentTextView.placeholderColor  =[UIColor lightGrayColor];
    
    self.contentTextView.placeholder =@"请输入备注";
    
    self.contentTextView.layer.cornerRadius  = 3;
    
    self.contentTextView.clipsToBounds  = YES;
    
    self.contentTextView.delegate  =self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    if (self.textViewBlock) {
        self.textViewBlock(textView.text);
    }
    return YES;
}
-(void)setFrame:(CGRect)frame{
    frame.origin.x +=2;
    frame.size.width -=4;
    [super setFrame:frame];
}

@end
