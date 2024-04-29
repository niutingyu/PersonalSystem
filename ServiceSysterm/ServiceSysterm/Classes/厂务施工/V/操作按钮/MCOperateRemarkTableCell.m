//
//  MCOperateRemarkTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2020/10/29.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "MCOperateRemarkTableCell.h"

#import "UITextView+Placeholder.h"

@interface MCOperateRemarkTableCell ()<UITextViewDelegate>

@end
@implementation MCOperateRemarkTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentTextV.delegate  =self;
    self.contentTextV.placeholderColor  =[UIColor lightGrayColor];
    self.contentTextV.placeholder  =@"请填写备注";
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    if (self.contentBlock) {
        self.contentBlock(textView.text);
    }
    
    return YES;
}
@end
