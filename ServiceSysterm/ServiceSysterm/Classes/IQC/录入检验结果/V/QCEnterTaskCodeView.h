//
//  QCEnterTaskCodeView.h
//  ServiceSysterm
//
//  Created by Andy on 2021/6/2.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQCListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCEnterTaskCodeView : UIView

@property (nonatomic,copy)void(^selectedMethodBlock)(NSInteger tag);

@property (nonatomic,strong)IQCListModel * listModel;
//@property (weak, nonatomic) IBOutlet UILabel *taskNumberLab;
//@property (weak, nonatomic) IBOutlet UILabel *orderTimeLab;
//@property (weak, nonatomic) IBOutlet UILabel *checkCountLab;
//@property (weak, nonatomic) IBOutlet UILabel *materialNumberLab;
//@property (weak, nonatomic) IBOutlet UILabel *materialNameLab;
//@property (weak, nonatomic) IBOutlet UILabel *supBarCodeLab;
//@property (weak, nonatomic) IBOutlet UILabel *materialInfoLab;
//@property (weak, nonatomic) IBOutlet UILabel *productTimeLab;
//@property (weak, nonatomic) IBOutlet UILabel *expLab;
//@property (weak, nonatomic) IBOutlet UILabel *statusLab;

@end

NS_ASSUME_NONNULL_END
