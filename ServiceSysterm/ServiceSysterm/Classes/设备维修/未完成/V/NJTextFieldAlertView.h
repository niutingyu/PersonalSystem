//
//  NJTextFieldAlertView.h
//  ServiceSysterm
//
//  Created by Andy on 2021/10/8.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^textfieldHandle)(NSString *textfieldString);

@interface NJTextFieldAlertView : UIView

@property (nonatomic,copy)textfieldHandle textfieldBlock;

@end

NS_ASSUME_NONNULL_END
