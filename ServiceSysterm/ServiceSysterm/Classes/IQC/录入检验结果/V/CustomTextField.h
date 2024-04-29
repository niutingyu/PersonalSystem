//
//  CustomTextField.h
//  ServiceSysterm
//
//  Created by Andy on 2021/8/2.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

@interface CustomTextField : UITextField


@property (nonatomic,assign) NSInteger subTag;

@property (nonatomic,strong) NSIndexPath *textIndx;


@end

NS_ASSUME_NONNULL_END
