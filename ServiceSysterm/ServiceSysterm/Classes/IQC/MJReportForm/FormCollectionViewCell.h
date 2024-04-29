//
//  FormCollectionViewCell.h
//  TestXXX
//
//  Created by Andy on 2021/6/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    FCChartCollectionViewCellTypeDefault, //正常样式 文字居中
    FCChartCollectionViewCellTypeMax,  //最高标志位
    FCChartCollectionViewCellTypeMin,  //最低标志位
} FormCollectionViewCellType;

typedef enum :NSUInteger{
    TextLeft,
    TextCenter,
    TextRight,
}TextAligment;

@interface FormCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)NSString *text;

@property (nonatomic,strong)UIColor *textColor;

@property (nonatomic,strong)UIColor *backColor;




@property (nonatomic,assign)FormCollectionViewCellType cellType;

@property (nonatomic,assign)TextAligment aligmentType;

@end

NS_ASSUME_NONNULL_END
