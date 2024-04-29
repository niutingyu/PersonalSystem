//
//  QCOCTableViewCell.m
//  ServiceSysterm
//
//  Created by Andy on 2021/6/2.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "QCOCTableViewCell.h"
#import "DropDownMenuView.h"
#import "QCJudgeMethod.h"
#import "QCCOCCollectionViewCell.h"
#import "FormChartView.h"

#define LABELH (kScreenWidth-40-60-80-4)

@interface QCOCTableViewCell ()<SLDropdownMenuDelegate,SLDropdownMenuDataSource,FormViewDelegate,FormViewDatasource>

@property (nonatomic,strong)NSArray * typeList;

@property (nonatomic,strong)FormChartView * chartView;

/**
 下拉框
 */
@property (nonatomic,strong)DropDownMenuView * menuView;

/**
 标号
 */
@property (nonatomic,strong)UILabel *numberLab;


/**
 标题
 */
@property (nonatomic,strong)UILabel * titleLab;

/**
 单位
 */
@property (nonatomic,strong)UILabel * unitLab;

/**
 判定结果
 */
@property (nonatomic,strong)UILabel * checkResultLab;


@property (nonatomic,strong)NSMutableDictionary *cellDictionary;

@end



@implementation QCOCTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/*-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self  =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor  =[UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    UIView * bottomView  =[[UIView alloc]init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(2);
        make.top.mas_offset(0.5);
        make.right.mas_offset(-2);
        make.bottom.mas_offset(-0.5);
    }];
    
    UIView * leftLine  =[[UIView alloc]init];
    leftLine.backgroundColor  = [UIColor darkGrayColor];
    [bottomView addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(0.5);

    }];

    UIView * rightLine  =[[UIView alloc]init];
    rightLine.backgroundColor  =[UIColor darkGrayColor];
    [bottomView addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-2);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(0.5);
    }];
    
    UIView * topLine  =[[UIView alloc]init];
    topLine.backgroundColor  =[UIColor darkGrayColor];
    [bottomView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
    UIView *bottomLine  =[[UIView alloc]init];
    bottomLine.backgroundColor  =[UIColor darkGrayColor];
    [bottomView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.height.mas_equalTo(0.5);
    }];
    //序号
    UIFont * fontH  =[UIFont systemFontOfSize:17];
    
   // CGFloat labelH  = (kScreenWidth-120-2)/6;
    CGFloat labelH  = (kScreenWidth-40-60-80-4);
    UILabel * numberLab  =[[UILabel alloc]init];
    
    numberLab.font  =fontH;
    numberLab.textAlignment  = NSTextAlignmentCenter;
    numberLab.text  =@"1";
    self.numberLab  =numberLab;
    [bottomView addSubview:numberLab];
    [numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_offset(0);
        make.width.mas_equalTo(40);
    }];
    
    UIView * line1  =[[UIView alloc]init];
    line1.backgroundColor  = [UIColor darkGrayColor];
    [bottomView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(numberLab.mas_right).mas_offset(0);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(0.5);
    }];
    
  
    //检验结果
    
    DropDownMenuView *menuView  =[[DropDownMenuView alloc]init];
    menuView.backgroundColor  = [UIColor whiteColor];
    
    menuView.delegate =self;
    menuView.dataSource  =self;
    menuView.layer.borderColor  =[UIColor darkGrayColor].CGColor;
    menuView.layer.borderWidth  =0.5;
  //  menuView.layer.cornerRadius  =3;
    menuView.title  =@"请选择";
    menuView.titleAlignment  =NSTextAlignmentCenter;
    menuView.titleFont  =[UIFont systemFontOfSize:16];
    menuView.rotateIcon  =[UIImage imageNamed:@"ios-arrow-down"];
    menuView.rotateIconSize  =CGSizeMake(25, 25);
    menuView.titleColor  =[UIColor blackColor];
    menuView.optionFont =[UIFont systemFontOfSize:16];
    menuView.optionTextColor  =[UIColor blackColor];
    menuView.optionLineColor  =[UIColor lightGrayColor];
    menuView.optionBgColor =RGBA(234, 243, 250, 1);
  
    self.menuView  =menuView;
    [bottomView addSubview:menuView];
    [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line1.mas_right).mas_offset(1);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(labelH);
    }];
    
    UIView * line3  =[[UIView alloc]init];
    line3.backgroundColor =[UIColor darkGrayColor];
    [bottomView addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(menuView.mas_right).mas_offset(0);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(0.5);
    }];
    
    //单位
    UILabel * unitLab =[[UILabel alloc]init];
    unitLab.font  = fontH;
    unitLab.text =@"/";
    unitLab.textAlignment  =NSTextAlignmentCenter;
    self.unitLab  =unitLab;
    [bottomView addSubview:unitLab];
    [unitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line3.mas_right).mas_offset(0);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(60);
    }];
    UIView * line4 =[[UIView alloc]init];
    line4.backgroundColor  = [UIColor darkGrayColor];
    [bottomView addSubview:line4];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(unitLab.mas_right).mas_offset(0);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(0.5);
    }];
    //判定结果
    UILabel * checkResultLab  =[[UILabel alloc]init];
    checkResultLab.font = fontH;
    checkResultLab.text  = @"";
    checkResultLab.textAlignment  =NSTextAlignmentCenter;
    self.checkResultLab  =checkResultLab;
    [bottomView addSubview:checkResultLab];
    [checkResultLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line4.mas_right).mas_offset(0);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(80);
    }];
    
}*/


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.chartView];
    }return self;
}
-(NSInteger)chartView:(FormChartView *)chartView numberOfItemsInSection:(NSInteger)section{
    //列数
    return 4;
}

-(NSInteger)numberOfSectionsInChartView:(FormChartView *)chartView{
    //行数
    return self.mainModel.detailList.count;
}

- (__kindof UICollectionViewCell *)collectionViewCell:(UICollectionViewCell *)collectionViewCell collectionViewType:(FormCollectionViewType)type cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    QCCOCCollectionViewCell * cell  =(QCCOCCollectionViewCell*) collectionViewCell;
    QCDetailListModel *detailModel  = self.mainModel.detailList[indexPath.section];
    if (indexPath.item ==0) {
        //序号
        cell.isedit =NO;
        cell.text = detailModel.SampleId?:@"";
    }else if (indexPath.item ==1){
        //检测结果
        cell.isedit =YES;
        [self setupDropMenuViewWithCell:cell idx:indexPath.section detialModel:detailModel] ;
        
        
    }else if (indexPath.item ==2){
        //单位
        if (self.mainModel.TestUnit.length ==0) {
            cell.text =@"/";
        }else{
            cell.text =self.mainModel.TestUnit;
        }
        cell.isedit =NO;
    }else{
        //判定结果
        cell.isedit  =NO;
        cell.text = detailModel.DecisionResult?:@"";
        [self.cellDictionary setObject:cell forKey:@(indexPath.section)];
        
    }
    
    return cell;
}

-(CGSize)chartView:(FormChartView *)chartView sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item  ==0) {
        return CGSizeMake(40, 60);
    }else if (indexPath.item ==1){
        return CGSizeMake(LABELH, 60);
    }else if (indexPath.item ==2){
        return CGSizeMake(60, 60);
    }else{
        return CGSizeMake(80, 60);
    }
}


//检验结果下拉选择框
-(void)setupDropMenuViewWithCell:(QCCOCCollectionViewCell*)cell idx:(NSInteger)idx detialModel:(QCDetailListModel*)detailModel{
    DropDownMenuView *menuView  =[[DropDownMenuView alloc]init];
 //   menuView.backgroundColor  = [UIColor whiteColor];
    
    menuView.delegate =self;
    menuView.dataSource  =self;
   // menuView.layer.borderColor  =[UIColor darkGrayColor].CGColor;
   // menuView.layer.borderWidth  =0.5;
   // menuView.title  =@"请选择";
    menuView.titleAlignment  =NSTextAlignmentCenter;
    menuView.titleFont  =[UIFont systemFontOfSize:16];
    menuView.rotateIcon  =[UIImage imageNamed:@"ios-arrow-down"];
    menuView.rotateIconSize  =CGSizeMake(25, 25);
    menuView.titleColor  =[UIColor blackColor];
    menuView.optionFont =[UIFont systemFontOfSize:16];
    menuView.optionTextColor  =[UIColor blackColor];
    menuView.optionLineColor  =[UIColor lightGrayColor];
    menuView.optionBgColor =RGBA(234, 243, 250, 1);
    menuView.tag  =idx;
    
    if (detailModel.Result01.length ==0) {
        menuView.title =@"请选择";
    }else{
        menuView.title  = detailModel.Result01;
    }
    if ([self.mainModel.operationStr isEqualToString:@"录入检验结果"]||[self.mainModel.operationStr isEqualToString:@"编辑"]) {
        if (self.mainModel.RelateTaskCode.length ==0) {
            menuView.userInteractionEnabled  =YES;
           
        }else{
            menuView.userInteractionEnabled  =NO;
            menuView.backgroundColor  =RGBA(243, 243, 244, 1);
        }
    }else{
        menuView.userInteractionEnabled  =NO;
        menuView.backgroundColor  =[UIColor whiteColor];
    }
  //  self.menuView =menuView;
    //self.menuView.title =detailModel.Result01?:@"请选择";
    [cell.contentView addSubview:menuView];
    [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(5);
        make.top.bottom.mas_offset(2);
        make.right.mas_offset(-5);
    }];

}
#pragma mark  = = = == = == = = == = = == = = = = =MEnuDownMenu

-(NSUInteger)numberOfOptionsInDropdownMenu:(DropDownMenuView *)menu{
    
    return self.mainModel.dropTypeList.count;
}

-(CGFloat)dropdownMenu:(DropDownMenuView *)menu heightForOptionAtIndex:(NSUInteger)index{
    return 50;
}

-(NSString*)dropdownMenu:(DropDownMenuView *)menu titleForOptionAtIndex:(NSUInteger)index{

    return self.mainModel.dropTypeList[index];
}

-(void)dropdownMenu:(DropDownMenuView *)menu didSelectOptionAtIndex:(NSUInteger)index optionTitle:(NSString *)title{
    QCDetailListModel * listModel = self.mainModel.detailList[menu.tag];
    listModel.Result01  = title;
    [QCJudgeMethod calculateWithName:self.mainModel.Name listModel:listModel mainModel:self.mainModel idx:0];
    QCCOCCollectionViewCell *cell  = [self.cellDictionary objectForKey:@(menu.tag)];
    cell.text  = listModel.DecisionResult;
   //判定结果
 //   [self.chartView reload];
   
  //  self.checkResultLab.text  = listModel.DecisionResult?:@" ";
  
}

-(void)setMainModel:(QCSubmitMainModel *)mainModel{
    _mainModel  =mainModel;
//    NSArray * columnList  =mainModel.columnList;
//
//    for (QCColumnListModel * model in columnList) {
//        if ([model.ColumnName isEqualToString:@"检验结果"]) {
//            NSArray * dataMemberList =[model.DataMember componentsSeparatedByString:@"^"];
//            self.typeList  =dataMemberList;
//
//        }
//    }
 //序号
//    self.numberLab.text  = [NSString stringWithFormat:@"%ld",mainModel.pathNumber+1];
//
//    //检测项目
//    self.titleLab.text  = mainModel.Name;
//
//    //单位
//
//    NSString *unitStr;
//
//    if (mainModel.TestUnit.length ==0) {
//        unitStr =@"/";
//    }else{
//        unitStr  =mainModel.TestUnit;
//    }
//    self.unitLab.text = unitStr;
//
//    //判定结果
//    QCDetailListModel * listModel = [self.mainModel.detailList firstObject];
//    QCColumnListModel *columnModel =[self.mainModel.columnList firstObject];
//    self.checkResultLab.text =listModel.DecisionResult?:@"";
//    self.menuView.title =listModel.Result01?:[NSString stringWithFormat:@"请选择%@",columnModel.ColumnName];
//    [self.menuView reloadOptionsData];
    debugLog(@" ===mmm %@",mainModel.operationStr);
    self.chartView.frame  = CGRectMake(2, 0, kScreenWidth-4, 60*mainModel.detailList.count);
   
}
-(void)setOperationTypeStr:(NSString *)operationTypeStr{
    _operationTypeStr  =operationTypeStr;
    if ([operationTypeStr  isEqualToString:@"录入检验结果"]||[operationTypeStr isEqualToString:@"编辑"]) {
        if (self.mainModel.RelateTaskCode.length ==0) {
            self.menuView.userInteractionEnabled  =YES;
            self.contentView.backgroundColor =RGBA(243, 243, 244, 1);
        }else{
            self.menuView.userInteractionEnabled  =NO;
        }
    }else{
      self.menuView.userInteractionEnabled  =NO;
      self.menuView.titleColor  =[UIColor blackColor];
    }
}
-(FormChartView*)chartView{
    if (!_chartView) {
        _chartView  =[[FormChartView alloc]initWithFrame:CGRectZero type:FormTypeNoFixation dataSource:self];
        _chartView.delegate  =self;
        [_chartView registerClass:[QCCOCCollectionViewCell class]];
        
    }
    return _chartView;
}

-(NSMutableDictionary*)cellDictionary{
    if (!_cellDictionary) {
        _cellDictionary  =[NSMutableDictionary dictionary];
    }return _cellDictionary;
}
@end
