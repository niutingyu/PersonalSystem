//
//  QCWideTableViewCell.h
//  ServiceSysterm
//
//  Created by Andy on 2021/6/3.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "QCSubmitMainModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCWideTableViewCell : BaseTableViewCell

@property (nonatomic,strong)QCSubmitMainModel * mainModel;

@end

NS_ASSUME_NONNULL_END
