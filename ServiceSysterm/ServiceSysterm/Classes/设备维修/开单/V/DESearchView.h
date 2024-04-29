//
//  DESearchView.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/7.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^SearchBlock)(void);

@interface DESearchView : UIView
@property (weak, nonatomic) IBOutlet UITextField *searchContentTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (nonatomic,copy) SearchBlock searchBlock;





@end

NS_ASSUME_NONNULL_END
