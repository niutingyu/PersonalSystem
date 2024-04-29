//
//  DEMaterialTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/9.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEMaterialTableCell.h"


@interface DEMaterialTableCell ()<UITextFieldDelegate,UIGestureRecognizerDelegate>

@end
@implementation DEMaterialTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    // 注册通知
   // [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeText:) name:UITextFieldTextDidChangeNotification object:nil];
    //为编码lable添加复制功能
    UILongPressGestureRecognizer * tap =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tap.minimumPressDuration =1.0f;
  
    self.materialCodeLab.userInteractionEnabled = YES;
    [self.materialCodeLab addGestureRecognizer:tap];
   
    
    
}
- (BOOL)canBecomeFirstResponder{
    return YES;
}
// 可以控制响应的方法
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return (action == @selector(copy:));
}

- (void)tap:(UILongPressGestureRecognizer *)sender {
    [self becomeFirstResponder];
    UIMenuItem *copyLink = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copy:)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyLink, nil]];
    [[UIMenuController sharedMenuController] setTargetRect:self.materialCodeLab.frame inView:self.materialCodeLab.superview];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
 
}
- (void)copy:(id)sender{
    
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = self.materialCodeLab.text;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(DEPickChosMaterialModel *)model{
    _model = model;
    self.materialTypeLab.text = [NSString stringWithFormat:@"物料规格:%@",model.MaterialInfo];
    self.materialCodeLab.text = [NSString stringWithFormat:@"物料编码:%@",model.MaterialCode];
    self.materialNameLab.text = [NSString stringWithFormat:@"物料名称:%@",model.MaterialName];
    self.unitLab.text = [NSString stringWithFormat:@"单位:%@",model.UnitPurchaseName];
    self.stockLab.text = [NSString stringWithFormat:@"库存数量:%@",model.CountAll];
    self.countTextField.text = model.applyCount?:@"1";
    self.remarkTextField.text = model.Remark?:@"";
    
   
    
}

-(void)setMaterialArray:(NSMutableArray *)materialArray{
    _materialArray = materialArray;
}
-(void)changeText:(NSNotification*)notification{
   
    UITextField * textField = [notification object];
    DEPickChosMaterialModel * status = _materialArray[textField.tag];
    if ([textField isKindOfClass:[self.countTextField class]]) {
       
        NSInteger wholeCount = [status.CountAll integerValue];
        NSInteger inputCount = [textField.text integerValue];
        
        if (inputCount >wholeCount) {
            NSInteger maxLen = status.CountAll.length;
            if (textField.text.length >maxLen) {
                textField.text = [textField.text substringToIndex:maxLen];
            }
            [Units showErrorStatusWithString:@"库存不足"];
            return;
        }
        inputCount = [textField.text integerValue];
        status.applyCount = [NSString stringWithFormat:@"%ld",inputCount];
    }
    if ([textField isKindOfClass:[self.remarkTextField class]]) {
        status.Remark = textField.text;
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    
    
}
@end
