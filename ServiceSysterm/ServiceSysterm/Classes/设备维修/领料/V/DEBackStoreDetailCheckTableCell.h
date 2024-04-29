//
//  DEBackStoreDetailCheckTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2019/6/4.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "DEMaterialDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DEBackStoreDetailCheckTableCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *materialTypeLab;

@property (weak, nonatomic) IBOutlet UILabel *materialCodeLab;

@property (weak, nonatomic) IBOutlet UITextField *backstoreNumberTextField;
@property (weak, nonatomic) IBOutlet UILabel *materialIdLab;
@property (weak, nonatomic) IBOutlet UILabel *checkoutNumberLab;

@property (weak, nonatomic) IBOutlet UITextView *reasonTextField;


@property (nonatomic,strong)DEReturnBillDetailModel *model;
@end

NS_ASSUME_NONNULL_END
