//
//  TopAlertView.h
//  ServiceSysterm
//
//  Created by Andy on 2019/8/13.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TopAlertView : UIView

- (instancetype)initWithStyle:(UIColor*)color;
@property (nonatomic,strong)NSString *headerTitle;
@property (nonatomic,strong)NSString *contentText;
-(void)beginTimer;
@end

NS_ASSUME_NONNULL_END
