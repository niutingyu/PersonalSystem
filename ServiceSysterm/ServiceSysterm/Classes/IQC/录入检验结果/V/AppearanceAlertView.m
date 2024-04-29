//
//  AppearanceAlertView.m
//  ServiceSysterm
//
//  Created by Andy on 2021/6/4.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "AppearanceAlertView.h"
#import "AssetConst.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "AppearanceCollectionCell.h"
#import "QCUnitCollectionCell.h"
#import "AppranceAlertReusableView.h"

NSString * const AlertReusabledId =@"AlertReusabledId";

@interface AppearanceAlertView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView * collectionView;

/**
 外观检查1
 */
@property (nonatomic,strong)NSMutableArray * selectedist;

/**
 外观检查选中字符串
 */

@property (nonatomic,strong)NSMutableArray *stringSelectedList;



@property (nonatomic,strong)QCSubmitMainModel *mainModel;

@property (nonatomic,assign)NSInteger idxRow;



@end

@implementation AppearanceAlertView

+(void)showassetAlertViewWithMainModel:(QCSubmitMainModel*)model idxRow:(NSInteger)idxRow appranceBlock:(refreshBlcok)appranceBlcok{
    AppearanceAlertView *assetView = [[AppearanceAlertView alloc]initAppranceMainModel:model idxRow:idxRow appranceBlock:appranceBlcok];
    [[UIApplication sharedApplication].delegate.window addSubview:assetView];
    
}

-(instancetype)initAppranceMainModel:(QCSubmitMainModel*)mainModel idxRow:(NSInteger)idxRow appranceBlock:(refreshBlcok)appranceBlock{
    if (self = [super init]) {
        _arrayBlock  =appranceBlock;
        self.mainModel  =mainModel;
        self.idxRow  =idxRow;
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6/1.0];

    //backgroundView
    
    UIView *bgView = [[UIView alloc]init];
   
    bgView.center = CGPointMake(self.center.x, self.center.y);
    
    bgView.bounds = CGRectMake(0, 0, self.frame.size.width , kScreenHeight);
    [self addSubview:bgView];
    
    UIView *updateView = [[UIView alloc]init];
    updateView.center  =CGPointMake(bgView.center.x, bgView.center.y);
    updateView.bounds = CGRectMake(0, 0, bgView.frame.size.width -Ratio(100), kScreenHeight*0.5);
    updateView.backgroundColor = [UIColor whiteColor];
    updateView.layer.masksToBounds = YES;
    updateView.layer.cornerRadius = 4.0f;
    [bgView addSubview:updateView];
    
    UILabel * titleLab =[[UILabel alloc]init];
    titleLab.textAlignment  =NSTextAlignmentCenter;
    titleLab.text =@"外观检查";
    titleLab.font  =[UIFont systemFontOfSize:17 weight:0.5];
    [updateView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(updateView);
        make.top.mas_offset(8);
        make.height.mas_equalTo(30);
    }];
    UICollectionViewLeftAlignedLayout * layout  =[[UICollectionViewLeftAlignedLayout alloc]init];
    layout.minimumLineSpacing  =1;
    layout.minimumInteritemSpacing  =1;
    layout.scrollDirection  =UICollectionViewScrollDirectionVertical;
    layout.sectionInset =UIEdgeInsetsMake(5, 16, 5, 16);
    _collectionView  =[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor  =[UIColor whiteColor];
    _collectionView.delegate =self;
    _collectionView.dataSource =self;
    [updateView addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.mas_equalTo(titleLab.mas_bottom).mas_offset(12);
        make.bottom.mas_offset(0);
    }];
    [_collectionView registerClass:[AppearanceCollectionCell class] forCellWithReuseIdentifier:@"cellId"];
    [_collectionView registerClass:[AppranceAlertReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:AlertReusabledId];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footReusedidtifireId"];
    [_collectionView registerClass:[QCUnitCollectionCell class] forCellWithReuseIdentifier:@"unitReusedIdtifireId"];
    
    //取消
    UIButton * cancelBut  =[UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBut setTitle:@"取消" forState:UIControlStateNormal];
    cancelBut.backgroundColor  =[UIColor whiteColor];
    [cancelBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBut addTarget:self action:@selector(cancelMethod) forControlEvents:UIControlEventTouchUpInside];
    [updateView addSubview:cancelBut];
    [cancelBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(16);
        make.right.mas_offset(-16);
        make.bottom.mas_offset(0);
        make.height.mas_equalTo(60);
    }];
    
    
    UIButton * submitBut  =[UIButton buttonWithType:UIButtonTypeCustom];
    [submitBut setTitle:@"确定" forState:UIControlStateNormal];
    [submitBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    submitBut.titleLabel.font  =[UIFont systemFontOfSize:17];
    submitBut.backgroundColor  = RGBA(103, 137, 204, 1);
    submitBut.layer.cornerRadius  =3;
    submitBut.clipsToBounds  =YES;
    [submitBut addTarget:self action:@selector(sureMethod) forControlEvents:UIControlEventTouchUpInside];
    
    [updateView addSubview:submitBut];
    [submitBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(16);
        make.bottom.mas_equalTo(cancelBut.mas_top).mas_offset(8);
        make.right.mas_offset(-16);
        make.height.mas_equalTo(60);
    }];
    
    
    
    [self showWithAlert:bgView];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    NSNumber *number  = self.mainModel.contentW[indexPath.item];
    
    CGFloat width  = [number floatValue]+40;
    
    return CGSizeMake(width, 45);
    
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(kScreenWidth-Ratio(40), 48);
}

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView =nil;
    if (kind  == UICollectionElementKindSectionHeader) {
        AppranceAlertReusableView * AlertReusableView  =[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:AlertReusabledId forIndexPath:indexPath];
        reusableView.backgroundColor  =[UIColor lightGrayColor];
        AlertReusableView.titleLab.text  =self.mainModel.Name;
        reusableView =AlertReusableView;
        
    }else{
        reusableView  =[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footReusedidtifireId" forIndexPath:indexPath];
        reusableView.backgroundColor  = [UIColor lightGrayColor];
    }
    return reusableView;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.mainModel.appranceCheckStandardList.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    AppearanceCollectionCell * cell  =[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    NSString * title  = self.mainModel.appranceCheckStandardList[indexPath.item];
    NSNumber * number  = self.mainModel.contentW[indexPath.item];
    CGFloat width  = [number floatValue]+40;
    cell.title =title;
    cell.contentW  =width;
    [cell.typeBut addTarget:self action:@selector(typeMethod:) forControlEvents:UIControlEventTouchUpInside];
    for (NSString *str  in self.mainModel.selectedAppranceItemList) {
        if ([str isEqualToString:title]) {
            cell.typeBut.selected  =YES;
        }
    }
        [self.selectedist addObject:cell.typeBut];


    return cell;
   
}

#pragma mark  == = == 确定选择

-(void)sureMethod{
    //外观检查
    QCDetailListModel * detailModel = self.mainModel.detailList[self.idxRow];
    if (self.mainModel.selectedAppranceItemList.count >0) {
        detailModel.Result01  = [self.mainModel.selectedAppranceItemList componentsJoinedByString:@"、"];
        for (NSString * str  in self.mainModel.selectedAppranceItemList) {
            if ([str containsString:@"无缺陷"]) {
               detailModel.DecisionResult =@"合格";
                self.mainModel.DecisionResult =@"1";
            }else{
                detailModel.DecisionResult  =@"不合格";
               
                self.mainModel.DecisionResult =@"0";
                
            }
        }
    }else{
        detailModel.Result01  = @"";
        detailModel.DecisionResult =@"";
        self.mainModel.DecisionResult =@"";
    }
    
    if (self.arrayBlock) {
        self.arrayBlock();
    }
    [self dismissAlert];
   
}

-(void)cancelMethod{
    [self dismissAlert];
}

-(void)typeMethod:(UIButton*)sender{
    for (NSString *str  in self.mainModel.selectedAppranceItemList) {
        if (![self.stringSelectedList containsObject:str]&&![str isEqualToString:@"无缺陷"]) {
            [self.stringSelectedList addObject:str];
        }
    }
    if ([sender.titleLabel.text isEqualToString:@"无缺陷"]) {
        for (UIButton * but in self.selectedist) {
            if (![but.titleLabel.text isEqualToString:@"无缺陷"]) {
                but.selected  =NO;
            }
        }
        [self.stringSelectedList removeAllObjects];
        if (sender.selected ==1) {
            [self.stringSelectedList addObject:sender.titleLabel.text];
        }
    }else{
        //当点击其他状态按钮 无缺陷按钮改为未选中

        for (UIButton * but in self.selectedist) {
            if ([but.titleLabel.text isEqualToString:@"无缺陷"]) {
                but.selected  =NO;
            }
        }
        [self.stringSelectedList removeObject:@"无缺陷"];
        if (sender.selected ==1) {
            [self.stringSelectedList addObject:sender.titleLabel.text];
           
        }else{
            [self.stringSelectedList removeObject:sender.titleLabel.text];
        }
    }

    self.mainModel.selectedAppranceItemList  = self.stringSelectedList;
                
}

- (void)showWithAlert:(UIView*)alert{
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
  //  [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [alert.layer addAnimation:animation forKey:nil];
}


/** 添加Alert出场动画 */
- (void)dismissAlert{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = (CGAffineTransformMakeScale(0.5, 0.5));
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    } ];
    
}



-(NSMutableArray*)selectedist{
    if (!_selectedist) {
        _selectedist  =[NSMutableArray array];
    }return _selectedist;
}


-(NSMutableArray*)stringSelectedList{
    if (!_stringSelectedList) {
        _stringSelectedList  =[NSMutableArray array];
    }return _stringSelectedList;
}


@end
