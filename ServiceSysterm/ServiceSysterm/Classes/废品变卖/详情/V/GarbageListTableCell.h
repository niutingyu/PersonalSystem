//
//  GarbageListTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2021/8/23.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "WasterDetailListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GarbageListTableCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *nameContentLab;
@property (weak, nonatomic) IBOutlet UILabel *codeLab;
@property (weak, nonatomic) IBOutlet UILabel *codeContentLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *typeContentLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UILabel *countContentLab;
@property (weak, nonatomic) IBOutlet UILabel *ConcentLab;
@property (weak, nonatomic) IBOutlet UILabel *ConcentContentLab;

@property (nonatomic,strong)GarbageListModel *model;

@end

NS_ASSUME_NONNULL_END
