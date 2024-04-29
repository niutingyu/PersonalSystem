//
//  DEBackStockAlertTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2019/6/4.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "DEMaterialDetailModel.h"
#import "PlaceholderTextView.h"
NS_ASSUME_NONNULL_BEGIN

@interface DEBackStockAlertTableCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *materialLab;
@property (weak, nonatomic) IBOutlet UILabel *materialCodeLab;

@property (weak, nonatomic) IBOutlet UILabel *stockLocationLab;
@property (weak, nonatomic) IBOutlet UILabel *saleCountLab;
@property (weak, nonatomic) IBOutlet UITextField *backStockTextField;


@property (weak, nonatomic) IBOutlet PlaceholderTextView *backStockReasonTextField;
@property (nonatomic,strong)DEMaterialDetailModel * model;
@end

NS_ASSUME_NONNULL_END
