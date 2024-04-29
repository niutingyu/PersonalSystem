//
//  UILabel+LabelSize.m
//  ServiceSysterm
//
//  Created by Andy on 2019/6/24.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "UILabel+LabelSize.h"

@implementation UILabel (LabelSize)
- (CGFloat)getRectWidth{
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:self.font}
                                          context:nil];
    return rect.size.width;
}
- (CGFloat)getRectHeight{
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width,MAXFLOAT )
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:self.font}
                                          context:nil];
    return rect.size.height;
}
@end
