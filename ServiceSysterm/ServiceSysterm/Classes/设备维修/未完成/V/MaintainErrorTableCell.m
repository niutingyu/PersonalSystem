//
//  MaintainErrorTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2021/7/3.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "MaintainErrorTableCell.h"

@interface MaintainErrorTableCell()<UITextViewDelegate>

@end
@implementation MaintainErrorTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentTextView.delegate = self;
    self.contentTextView.layer.borderWidth  =0.5;
    self.contentTextView.layer.borderColor  =RGBA(242, 242, 242, 1).CGColor;
    self.contentTextView.layer.cornerRadius  =3;
    self.contentTextView.clipsToBounds  =YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (self.textBlock) {
        self.textBlock(textView.text);
    }
    
    return YES;
}
@end
