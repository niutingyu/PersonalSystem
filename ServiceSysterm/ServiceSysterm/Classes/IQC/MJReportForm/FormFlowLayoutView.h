//
//  FormFlowLayoutView.h
//  TestXXX
//
//  Created by Andy on 2021/6/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FormFlowLayoutDataSource <NSObject>

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
@interface FormFlowLayoutView : UICollectionViewFlowLayout

/**
 需要灵活item 尺寸 就需要遵守
 */
@property (nonatomic,weak)id <FormFlowLayoutDataSource>dataSource;

/**
 锁定行数
 */
@property (nonatomic,assign)NSInteger suspendRowNum;


/**
 锁定列数
 */
@property (nonatomic,assign)NSInteger suspendSectionNum;

- (void)reload;

@end

NS_ASSUME_NONNULL_END
