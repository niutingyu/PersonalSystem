//
//  QCSIzeCollectionCell.h
//  ServiceSysterm
//
//  Created by Andy on 2021/6/5.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"
#import "QCSubmitMainModel.h"
#import "FormChartView.h"
#import "CustomLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCSIzeCollectionCell : UICollectionViewCell

@property (nonatomic,strong)CustomTextField *textfield;

/**
 文本值
 */
@property (nonatomic,copy)NSString * text;

/**
 占位字符
 */

@property (nonatomic,copy)NSString * holdString;

/**
 是否能编辑
 */
@property (nonatomic,assign)BOOL isEdit;

/**
 文字颜色
 */
@property (nonatomic,strong) UIColor *textColor;


/**
 label是否隐藏
 */
@property (nonatomic,assign)BOOL isLabHidden;

/**
 textfield输入框是否隐藏
 */
@property (nonatomic,assign)BOOL isTextHidden;

/**
 label文本值
 */

@property (nonatomic,copy)NSString *labelText;

-(void)setupCellWithchartView:(FormChartView*)chartView rowIdx:(NSInteger)idx sectionIdx:(NSInteger)sectionIdx mainModel:(QCSubmitMainModel*)mainModel;

@end

NS_ASSUME_NONNULL_END
