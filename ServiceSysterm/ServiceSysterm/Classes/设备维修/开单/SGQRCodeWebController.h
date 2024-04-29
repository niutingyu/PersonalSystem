//
//  SGQRCodeWebController.h
//  ServiceSysterm
//
//  Created by Andy on 2019/6/21.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SGQRCodeWebController : UIViewController
@property (nonatomic,copy)void(^passScanResultBlock)(NSString*);
@end

NS_ASSUME_NONNULL_END
