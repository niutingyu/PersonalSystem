//
//  MTFootAddView.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/29.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTFootAddView : UIView
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (nonatomic,copy)void(^addMaterialBlock)(void);

@end

NS_ASSUME_NONNULL_END
