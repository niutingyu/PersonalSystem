//
//  FormChartView.m
//  TestXXX
//
//  Created by Andy on 2021/6/3.
//

#import "FormChartView.h"
#import "FormFlowLayoutView.h"
#import <IQKeyboardManager.h>
static NSString *kMainCVDefaultCellIdentifier = @"kMainCVChartCollectionViewCell";
static NSInteger kMainCVTag = 19979754;

@interface FormChartView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,FormFlowLayoutDataSource>


/**
 主要渲染CollectionView
 */


@property (nonatomic,strong)FormFlowLayoutView *mainLayout;


@property (nonatomic,assign)FormViewType fixationType;

@property (nonatomic,assign)NSInteger suspendRow;

@property (nonatomic,assign)NSInteger suspendSection;

@end
@implementation FormChartView

- (instancetype)initWithFrame:(CGRect)frame type:(FormViewType)type dataSource:(id<FormViewDatasource>)dataSource{
    if (self = [super initWithFrame:frame]) {
        _fixationType = type;
        _dataSource = dataSource;
        [self configUIWithType:type];
       // [IQKeyboardManager sharedManager].enable  =YES;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.mainCV.frame = self.bounds;
}

#pragma mark - Private Methods

- (void)configUIWithType:(FormViewType)type{
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    [self addSubview:self.mainCV];
}

#pragma mark - Public Methods

- (void)reload{
    self.suspendRow = 0;
    self.suspendSection = 0;
    self.mainLayout.suspendRowNum = self.suspendRow;
    self.mainLayout.suspendSectionNum = self.suspendSection;
    [CATransaction setDisableActions:YES];
    [self.mainLayout reload];
    [self.mainCV reloadData];
   
}

- (void)registerClass:(nullable Class)cellClass{
    [self.mainCV registerClass:cellClass forCellWithReuseIdentifier:kMainCVDefaultCellIdentifier];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_dataSource chartView:self numberOfItemsInSection:section];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [_dataSource numberOfSectionsInChartView:self];
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = nil;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMainCVDefaultCellIdentifier forIndexPath:indexPath];
    if (indexPath.section < self.suspendSection) {
        cell.backgroundColor = self.suspendSectionColor;
        cell = [self.dataSource collectionViewCell:cell collectionViewType:FormCollectionViewTypeSuspendSection cellForItemAtIndexPath:indexPath];
        return cell;
    }
    if (indexPath.row <self.suspendRow) {
        cell.backgroundColor = self.suspendRowColor;
        NSIndexPath *indexP = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-self.suspendSection];
        cell = [self.dataSource collectionViewCell:cell collectionViewType:FormCollectionViewTypeSuspendRow cellForItemAtIndexPath:indexP];
        return cell;
    }
    cell.backgroundColor = self.mainColor;
    NSIndexPath *indexP = [NSIndexPath indexPathForRow:indexPath.row-self.suspendRow inSection:indexPath.section-self.suspendSection];
    cell = [self.dataSource collectionViewCell:cell collectionViewType:FormCollectionViewTypeMain cellForItemAtIndexPath:indexP];
    return cell;
}

#pragma mark - FCChartViewDataSource

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [_dataSource chartView:self sizeForItemAtIndexPath:indexPath];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [_dataSource chartView:self sizeForItemAtIndexPath:indexPath];
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate &&[_delegate respondsToSelector:@selector(formCollectionView:didSelectRowAtIndexPath:)]) {
        [_delegate formCollectionView:collectionView didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark - Getter Methods

- (UICollectionView *)mainCV{
    if (!_mainCV) {
        _mainCV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.mainLayout];
        _mainCV.backgroundColor = [UIColor whiteColor];
        _mainCV.directionalLockEnabled = YES;
        _mainCV.tag = kMainCVTag;
        _mainCV.delegate = self;
        _mainCV.dataSource = self;
        _mainCV.bounces = NO;
        _mainCV.showsHorizontalScrollIndicator = NO;
        _mainCV.showsVerticalScrollIndicator = NO;
        _mainCV.scrollEnabled  =NO;
        if (@available(iOS 11.0, *)) {
            _mainCV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
//        [_mainCV registerClass:[FCChartCollectionViewCell class] forCellWithReuseIdentifier:kMainCVDefaultCellIdentifier];

    }
    return _mainCV;
}

- (FormFlowLayoutView *)mainLayout{
    if (!_mainLayout) {
        _mainLayout = [[FormFlowLayoutView alloc] init];
        _mainLayout.suspendRowNum = self.suspendRow;
        _mainLayout.suspendSectionNum = self.suspendSection;
       // _mainLayout.sectionInset  =UIEdgeInsetsMake(0, 5, 0, 5);
        _mainLayout.dataSource = self;
    }
    return _mainLayout;
}

- (NSInteger)suspendRow{
    if (!_suspendRow) {
        if (self.dataSource &&[self.dataSource respondsToSelector:@selector(chartView:numberOfSuspendItemsInSection:)]) {
            _suspendRow = [_dataSource chartView:self numberOfSuspendItemsInSection:0];
        }else{
            switch (_fixationType) {
                case FormTypeSectionAndRowFixation:
                    return 1;
                case FormTypeOnlySectionFixation:
                    return 0;
                case FormTypeOnlyRowFixation:
                    return 1;
                case FormTypeNoFixation:
                    return 0;
            }
            
        }
    }
    return _suspendRow;
}

- (NSInteger)suspendSection{
    if (!_suspendSection) {
        if (self.dataSource &&[self.dataSource respondsToSelector:@selector(numberOfSuspendSectionsInChartView:)])
        {
            _suspendSection = [_dataSource numberOfSuspendSectionsInChartView:self];
        }else{
            switch (_fixationType) {
                case FormTypeSectionAndRowFixation:
                    return 1;
                case FormTypeOnlySectionFixation:
                    return 1;
                case FormTypeOnlyRowFixation:
                    return 0;
                case FormTypeNoFixation:
                    return 0;
            }
        }
    }
    return _suspendSection;
}

- (UIColor *)mainColor{
    if (!_mainColor) {
        _mainColor = [UIColor whiteColor];
    }
    return _mainColor;
}

- (UIColor *)suspendRowColor{
    if (!_suspendRowColor) {
        _suspendRowColor = [UIColor colorWithRed:243.0f/255.0f green:243.0f/255.0f blue:243.0f/255.0f alpha:1.0f];
    }
    return _suspendRowColor;
}

- (UIColor *)suspendSectionColor{
    if (!_suspendSectionColor) {
        _suspendSectionColor = [UIColor colorWithRed:243.0f/255.0f green:243.0f/255.0f blue:243.0f/255.0f alpha:1.0f];
    }
    return _suspendSectionColor;
}

//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    [self endEditing:YES];
//}

@end
