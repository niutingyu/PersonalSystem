//
//  DepartmentLayout.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/29.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DepartmentLayout.h"

@implementation DepartmentLayout

- (void)prepareLayout {
    
    // 必须要调用父类(父类也有一些准备操作)
    [super prepareLayout];
    [self cellInitSetting];
}

/**
 cell 一些初始化设置
 */
- (void)cellInitSetting {
    
    // 设置滚动方向(只有流水布局才有这个属性)
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 设置cell的大小
    CGFloat itemW = self.collectionView.frame.size.width - 20;
    CGFloat itemH = self.collectionView.frame.size.height *0.7;
    self.itemSize = CGSizeMake(itemW, itemH);
    self.minimumLineSpacing = 20;
    // 设置内边距
    self.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
   // UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
}

/**
 * 决定了cell怎么排布
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    // 调用父类方法拿到默认的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    NSArray *copyArray = [[NSArray alloc]initWithArray:array copyItems:YES];
    // 获得collectionView最中间的x值
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    // 在默认布局属性基础上进行微调
    for (UICollectionViewLayoutAttributes *attrs in copyArray) {
        // 计算cell中点x 和 collectionView最中间x值  的差距
        CGFloat delta = ABS(centerX - attrs.center.x);
        // 利用差距计算出缩放比例（成反比）根据情况 自定义
        //这里默认 scale = 1.0 - delta / (self.collectionView.frame.size.width + self.itemSize.width）
        CGFloat scaleX = 1.0;
        CGFloat scaleY = 1.0 - delta / (self.collectionView.frame.size.width + self.itemSize.width+200);
        attrs.transform = CGAffineTransformMakeScale(scaleX, scaleY);
    }
    return copyArray;
}

/**
 * 当uicollectionView的bounds发生改变时，是否要刷新布局
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return YES;
}

@end
