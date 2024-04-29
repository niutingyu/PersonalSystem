//
//  DEUnfinishDetailModel.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/16.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEUnfinishDetailModel.h"

@implementation DEUnfinishDetailModel
-(instancetype)init{
    if (self =[super init]) {
        _isopen = NO;
    }
    return self;
}
@end

@implementation MaintainModel



@end
@implementation UserOperateModel



@end

@implementation LinkManModel



@end
@implementation DetailMemberModel



@end

@implementation MaintenceStepListModel

//-(void)setValue:(id)value forKey:(NSString *)key{
//    if (_CheckResult ==1) {
//        _checkResultStr =@"通过";
//    }else{
//        _checkResultStr =@"NG";
//    }
//}


@end
@implementation ExceptionModel

-(void)setValue:(id)value forKey:(NSString *)key{
     [super setValue:value forKey:key];
    CGFloat width = [self boundingStr:self.ContentName andFontSize:15];
    self.contentW = width+20;
  
}


- (CGFloat)boundingStr:(NSString *)Str andFontSize:(CGFloat)fontSize{
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    
    CGSize size = [Str boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    
    return size.width;
}
@end
