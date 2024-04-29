//
//  DESearchTImeFilterView.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/18.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DESearchTImeFilterView : UIView
@property (nonatomic,strong)UIButton * timeButton;

@property (nonatomic,strong)UIButton *FactoryButton;
@property (nonatomic,copy)void(^timeFilterBlock)(void);

@property (nonatomic,copy)void(^chosFactoryBlock)(void);
@end

NS_ASSUME_NONNULL_END
