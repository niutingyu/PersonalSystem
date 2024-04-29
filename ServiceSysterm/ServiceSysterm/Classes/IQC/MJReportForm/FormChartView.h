//
//  FormChartView.h
//  TestXXX
//
//  Created by Andy on 2021/6/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



typedef enum : NSUInteger {
    FormTypeSectionAndRowFixation,//行列固定
    FormTypeOnlySectionFixation,//行固定
    FormTypeOnlyRowFixation,//列固定
    FormTypeNoFixation,//无固定
} FormViewType;

typedef enum : NSUInteger {
    FormCollectionViewTypeMain,//非悬浮主区域
    FormCollectionViewTypeSuspendRow,//悬浮列区域
    FormCollectionViewTypeSuspendSection,//悬浮行区域
} FormCollectionViewType;

@class FormChartView;
@protocol FormViewDatasource <NSObject>

@required

- (NSInteger)chartView:(FormChartView *_Nullable)chartView numberOfItemsInSection:(NSInteger)section;

- (__kindof UICollectionViewCell *_Nullable)collectionViewCell:(UICollectionViewCell *_Nullable)collectionViewCell collectionViewType:(FormCollectionViewType)type cellForItemAtIndexPath:(NSIndexPath *_Nullable)indexPath;

/**
 对应item尺寸大小
 */
- (CGSize)chartView:(FormChartView *_Nullable)chartView sizeForItemAtIndexPath:(NSIndexPath *_Nullable)indexPath;


/**
 总列数量 默认为1
 */
- (NSInteger)numberOfSectionsInChartView:(FormChartView *_Nullable)chartView;

@optional


/**
 悬浮锁定列数
 */
- (NSInteger)numberOfSuspendSectionsInChartView:(FormChartView *_Nullable)chartView;


/**
 悬浮锁定行数

 @param chartView 当前对象
 @param section 第几列
 @return 行数
 */
- (NSInteger)chartView:(FormChartView *_Nullable)chartView numberOfSuspendItemsInSection:(NSInteger)section;



@end

@protocol FormViewDelegate <NSObject>

@optional

- (void )formCollectionView:(UICollectionView *_Nullable)collectionView didSelectRowAtIndexPath:(NSIndexPath *_Nullable)indexPath;

@end
@interface FormChartView : UIView

- (instancetype _Nullable )initWithFrame:(CGRect)frame type:(FormViewType)type dataSource:(id<FormViewDatasource>_Nullable)dataSource;

- (void)registerClass:(nullable Class)cellClass;

@property (nonatomic,weak)id <FormViewDatasource> _Nullable dataSource;

@property (nonatomic,weak)id <FormViewDelegate> _Nullable delegate;




/**
 行悬浮区域颜色 默认灰色
 */
@property (nonatomic,strong)UIColor * _Nullable suspendRowColor;

/**
 列悬浮区域颜色 默认灰色
 */
@property (nonatomic,strong)UIColor * _Nullable suspendSectionColor;

/**
 主区域颜色
 */
@property (nonatomic,strong)UIColor * _Nullable mainColor;

@property (nonatomic,strong)UICollectionView *mainCV;


/**
 重新加载
 */
- (void)reload;

@end

NS_ASSUME_NONNULL_END
