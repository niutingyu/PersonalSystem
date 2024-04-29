//
//  DEChosMaterialSearchView.m
//  ServiceSysterm
//
//  Created by Andy on 2020/7/21.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "DEChosMaterialSearchView.h"

@interface DEChosMaterialSearchView()<UITextFieldDelegate>


@end
@implementation DEChosMaterialSearchView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.searchButton.layer.cornerRadius =3;
    self.searchButton .clipsToBounds =YES;
    [self.searchButton addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)search{
    [self endEditing:YES];
    if (self.searchBlock) {
        self.searchBlock(self.materialInfoText.text?:@"", self.materialNameText.text?:@"", self.materialCodeText.text?:@"");
    }
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField.tag ==100) {
        self.materialInfoText.text = textField.text;
    }else if (textField.tag ==101){
        self.materialNameText.text =textField.text;
    }
   else{
       self.materialCodeText.text =textField.text;
    }
    
    return YES;
}
@end
