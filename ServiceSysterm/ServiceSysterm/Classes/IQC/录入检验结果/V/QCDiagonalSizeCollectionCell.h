//
//  QCDiagonalSizeCollectionCell.h
//  ServiceSysterm
//
//  Created by Andy on 2021/9/30.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"
#import "QCSubmitMainModel.h"
#import "FormChartView.h"
#import "EMCustomKeyboardView.h"
#import "CustomLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCDiagonalSizeCollectionCell : UICollectionViewCell

@property (nonatomic,strong)CustomTextField *customTextfield;

@property (nonatomic,strong)CustomLabel *customLabel;

-(void)setupDiagonalSizeCellWithChartView:(FormChartView*)formChartView rowIdx:(NSInteger)rowIdx sectionIdx:(NSInteger)sectionIdx mainModel:(QCSubmitMainModel*)mainModel;

@end

NS_ASSUME_NONNULL_END
