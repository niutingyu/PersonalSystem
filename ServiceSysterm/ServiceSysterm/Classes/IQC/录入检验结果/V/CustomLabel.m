//
//  CustomLabel.m
//  ServiceSysterm
//
//  Created by Andy on 2022/1/6.
//  Copyright © 2022 SLPCB. All rights reserved.
//

#import "CustomLabel.h"

@implementation CustomLabel

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        
    }
    return self;
}
-(void)setDetailModel:(QCDetailListModel *)detailModel{
    _detailModel  =detailModel;
}

@end
