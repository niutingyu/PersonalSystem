//
//  DEPickChosMaterialController.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/8.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DERootViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface DEPickChosMaterialController : DERootViewController
@property (nonatomic,copy)void(^chosMaterialBlock)(NSMutableArray *);

@property (nonatomic,strong)NSMutableArray * selectedMaterialArray;//已经选中的物料
@end

NS_ASSUME_NONNULL_END
