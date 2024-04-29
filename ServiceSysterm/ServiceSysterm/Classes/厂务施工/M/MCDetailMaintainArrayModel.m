//
//  MCDetailMaintainArrayModel.m
//  ServiceSysterm
//
//  Created by Andy on 2020/10/27.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "MCDetailMaintainArrayModel.h"

@implementation MCDetailMaintainArrayModel

-(void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    if (self.workLog.length >0) {
        self.logHeight  = [self calculateRowHeight:self.workLog]+30;
    }
}

//根据文字计算高度
-(CGFloat)calculateRowHeight:(NSString*)string{
    NSDictionary * dic =@{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    
    CGRect rect  =[string?:@"" boundingRectWithSize:CGSizeMake(kScreenWidth-10, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height;
}
@end
