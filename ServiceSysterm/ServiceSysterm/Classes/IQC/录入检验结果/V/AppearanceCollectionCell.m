//
//  AppearanceCollectionCell.m
//  ServiceSysterm
//
//  Created by Andy on 2021/6/4.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "AppearanceCollectionCell.h"


#define itemHeight 40
@implementation AppearanceCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self buildSubView];
        
    }
    return self;
}



- (void)buildSubView{
    
    UIButton *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [typeBtn setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
    [typeBtn  setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
    [typeBtn setImage:[UIImage imageNamed:@"weixuanzhong"] forState:0];
    typeBtn.tag =1000;
    [typeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    typeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    typeBtn.imageEdgeInsets  =UIEdgeInsetsMake(0, -10, 0, 0);
    [self.contentView  addSubview:typeBtn];
    [typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        // make 代表约束:
        make.top.equalTo(self.contentView).with.offset(0);   // 对当前view的top进行约束,距离参照view的上边界是 :
        // make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(0);  // 对当前view的left进行约束,距离参照view的左边界是 :
        
        make.height.equalTo(@(itemHeight));                // 高度
        
        make.right.equalTo(self.contentView).with.offset(0); // 对当前view的right进行约束,距离参照view的右边界是 :
        
    }];
    typeBtn.selected =NO;
    self.typeBut  =typeBtn;

    [typeBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setContentW:(CGFloat)contentW{
    _contentW  =contentW;
    CGRect frame = self.typeBut.frame;
    frame.size.width  = contentW;
    self.typeBut.frame  = frame;
}
-(void)setTitle:(NSString *)title{
    _title  =title;
    [self.typeBut setTitle:title forState:UIControlStateNormal];
}
-(void)clickAction:(UIButton*)sender{
    sender.selected =!sender.selected;
}
@end
