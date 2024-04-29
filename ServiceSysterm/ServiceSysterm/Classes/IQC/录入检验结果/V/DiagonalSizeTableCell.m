//
//  DiagonalSizeTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2021/6/3.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "DiagonalSizeTableCell.h"
#import "FormChartView.h"

#import "FormCollectionViewCell.h"
#import "QCDiagonalSizeCollectionCell.h"
#import "QCJudgeMethod.h"
#import "EMCustomKeyboardView.h"

@interface DiagonalSizeTableCell ()<FormViewDelegate,FormViewDatasource,UITextFieldDelegate>

@property (nonatomic,strong)FormChartView * chartView;

@property (nonatomic,strong)NSMutableDictionary *cellDictionary;

@property (nonatomic,strong)NSMutableDictionary *diagonalCellDictionary;

@end

#define LABELH  (kScreenWidth-40-60-80-4)
@implementation DiagonalSizeTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    ////////////////////对角线尺寸////////////////////
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self  =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
      
        [self setupUI];
    }
    return self;
}

-(NSInteger)chartView:(FormChartView *)chartView numberOfItemsInSection:(NSInteger)section{
    
    //列数
    return 6;
}

-(NSInteger)numberOfSectionsInChartView:(FormChartView *)chartView{
    //行数
    return self.mainModel.detailList.count;
}

- (__kindof UICollectionViewCell *)collectionViewCell:(UICollectionViewCell *)collectionViewCell collectionViewType:(FormCollectionViewType)type cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    QCDiagonalSizeCollectionCell * cell  =(QCDiagonalSizeCollectionCell*) collectionViewCell;
 //   QCDetailListModel * detailModel = self.mainModel.detailList[indexPath.section];
    cell.customTextfield.tag  = indexPath.section;
    if (indexPath.row ==0) {
        //编号
//        cell.isEdit =NO;
//        cell.isLabHidden  =NO;
//        cell.isTextHidden  =YES;
//        cell.labelText =[NSString stringWithFormat:@"%@",detailModel.SampleId];
   //     [cell setupCellWithchartView:self.chartView rowIdx:indexPath.row sectionIdx:indexPath.section mainModel:self.mainModel];
        [cell setupDiagonalSizeCellWithChartView:self.chartView rowIdx:indexPath.item sectionIdx:indexPath.section mainModel:self.mainModel];
    }else if (indexPath.row ==1){
        //对角线1
//         cell.isLabHidden  =YES;
//         cell.isTextHidden  =NO;
       /* if ([self.operationTypeStr isEqualToString:@"录入检验结果"] &&self.mainModel.RelateTaskCode.length ==0) {
            cell.isEdit  =YES;
            EMCustomKeyboardView *keyboard  =[[EMCustomKeyboardView alloc]init];
            cell.textfield.inputView =keyboard;
            keyboard.subView  = self.chartView;
            keyboard.textf =cell.textfield;
            QCColumnListModel * columnModel  = self.mainModel.columnList[indexPath.item -1];
            NSAttributedString *attruStr  =[[NSAttributedString alloc]initWithString:columnModel.ColumnName attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
            cell.textfield.attributedPlaceholder = attruStr;
        }else if (self.mainModel.RelateTaskCode.length >0){
            cell.isEdit  =NO;
            QCColumnListModel * columnModel  = self.mainModel.columnList[indexPath.item -1];
            NSAttributedString *attruStr  =[[NSAttributedString alloc]initWithString:columnModel.ColumnName attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
            cell.textfield.attributedPlaceholder = attruStr;
        }
        else{
            cell.isEdit  =NO;
            QCColumnListModel * columnModel  = self.mainModel.columnList[indexPath.item -1];
            NSAttributedString *attruStr  =[[NSAttributedString alloc]initWithString:columnModel.ColumnName attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
            cell.textfield.attributedPlaceholder = attruStr;
        }*/
//        QCColumnListModel * columnModel = [self.mainModel.columnList firstObject];
//        cell.holdString = columnModel.ColumnName;
//        QCColumnListModel * columnModel  = self.mainModel.columnList[indexPath.item -1];
       // [cell setupCellWithHolding:columnModel.ColumnName operationStr:self.operationTypeStr relataionCode:self.mainModel.RelateTaskCode chartView:self.chartView];
       // cell.text  = detailModel.Result01;
//        [cell setupCellWithchartView:self.chartView rowIdx:indexPath.row sectionIdx:indexPath.section mainModel:self.mainModel];
        [cell setupDiagonalSizeCellWithChartView:self.chartView rowIdx:indexPath.item sectionIdx:indexPath.section mainModel:self.mainModel];
        
        cell.customTextfield.subTag = indexPath.row;
        
        
        [cell.customTextfield addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
       
    }else if (indexPath.row  ==2){
        //对角线2
//        cell.isLabHidden  =YES;
//        cell.isTextHidden  =NO;
       /* if ([self.operationTypeStr isEqualToString:@"录入检验结果"]&&self.mainModel.RelateTaskCode.length  ==0) {
            cell.isEdit  =YES;
            EMCustomKeyboardView *keyboard  =[[EMCustomKeyboardView alloc]init];
            
            cell.textfield.inputView =keyboard;
            keyboard.subView  = self.chartView;
            keyboard.textf =cell.textfield;
            QCColumnListModel * columnModel  = self.mainModel.columnList[indexPath.item -1];
            NSAttributedString *attruStr  =[[NSAttributedString alloc]initWithString:columnModel.ColumnName attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
            cell.textfield.attributedPlaceholder = attruStr;
        }else if (self.mainModel.RelateTaskCode.length >0){
            cell.isEdit  =NO;
            QCColumnListModel * columnModel  = self.mainModel.columnList[indexPath.item -1];
            NSAttributedString *attruStr  =[[NSAttributedString alloc]initWithString:columnModel.ColumnName attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
            cell.textfield.attributedPlaceholder = attruStr;
        }
        else{
            
            cell.isEdit  =NO;
            QCColumnListModel * columnModel  = self.mainModel.columnList[indexPath.item -1];
            NSAttributedString *attruStr  =[[NSAttributedString alloc]initWithString:columnModel.ColumnName attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
            cell.textfield.attributedPlaceholder = attruStr;
        }*/
//        QCColumnListModel * columnModel  = self.mainModel.columnList[indexPath.item-1];
     //   cell.holdString  =columnModel.ColumnName;
     //   [cell setupCellWithHolding:columnModel.ColumnName operationStr:self.operationTypeStr relataionCode:self.mainModel.RelateTaskCode chartView:self.chartView];
       // cell.text  = detailModel.Result02;
       // [cell setupCellWithchartView:self.chartView rowIdx:indexPath.row sectionIdx:indexPath.section mainModel:self.mainModel];
        [cell setupDiagonalSizeCellWithChartView:self.chartView rowIdx:indexPath.item sectionIdx:indexPath.section mainModel:self.mainModel];
        cell.customTextfield.subTag  = indexPath.row;
        
        
        [cell.customTextfield addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    }else if (indexPath.row  ==3){
        //偏差
//        cell.isLabHidden  =YES;
//        cell.isTextHidden  =NO;
 //       QCColumnListModel * columnModel  = [self.mainModel.columnList objectAtIndex:2];
        cell.customTextfield.subTag  =indexPath.row;
       // cell.holdString =columnModel.ColumnName;
//        cell.isEdit =NO;
//        cell.textColor =[UIColor blackColor];
//        NSAttributedString *attruStr  =[[NSAttributedString alloc]initWithString:columnModel.ColumnName attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
//        cell.textfield.attributedPlaceholder = attruStr;
        [self.diagonalCellDictionary setObject:cell forKey:@(indexPath.section)];
//        if (detailModel.Result03.length  ==0) {
//            cell.text  =@"";
//        }else{
//            cell.text =detailModel.Result03;
//        }
     //   [cell setupCellWithchartView:self.chartView rowIdx:indexPath.row sectionIdx:indexPath.section mainModel:self.mainModel];
        [cell setupDiagonalSizeCellWithChartView:self.chartView rowIdx:indexPath.item sectionIdx:indexPath.section mainModel:self.mainModel];
    }else if (indexPath.row  ==4){
        //单位
//        cell.isLabHidden  =YES;
//        cell.isTextHidden  =NO;
//        if (self.mainModel.TestUnit.length ==0) {
//            cell.text =@"/";
//        }else{
//            cell.text  =self.mainModel.TestUnit;
//        }
//
//        cell.isEdit  =NO;
        [cell setupDiagonalSizeCellWithChartView:self.chartView rowIdx:indexPath.item sectionIdx:indexPath.section mainModel:self.mainModel];
    }else if (indexPath.row ==5){
        //判定结果
        
//        cell.isLabHidden  =YES;
//        cell.isTextHidden  =NO;
//        cell.isEdit =NO;
        cell.customTextfield.subTag =indexPath.row;
//        cell.holdString =@" ";
        [self.cellDictionary setObject:cell forKey:@(indexPath.section)];
//        if (detailModel.DecisionResult.length ==0) {
//            cell.text =@"  ";
//        }else{
//            cell.text =detailModel.DecisionResult;
//        }
        [cell setupDiagonalSizeCellWithChartView:self.chartView rowIdx:indexPath.item sectionIdx:indexPath.section mainModel:self.mainModel];
    }
    return cell;
}

#pragma mark  == = = == = = =UITextFieldDelegate

-(void)textFieldChanged:(CustomTextField*)textf{
    QCDetailListModel *detailModel  = self.mainModel.detailList[textf.tag];
    
    if (textf.subTag ==1) {
        detailModel.Result01  =textf.text;
        [QCJudgeMethod diagonalCalculateWithName:self.mainModel.Name listModel:detailModel mainModel:self.mainModel];
        
    }else if (textf.subTag ==2){
        detailModel.Result02  =textf.text;
        [QCJudgeMethod diagonalCalculateWithName:self.mainModel.Name listModel:detailModel mainModel:self.mainModel];
    }
    
    if (textf.subTag+1  ==3 ||textf.subTag +2 ==3) {
        //偏差
        QCDiagonalSizeCollectionCell *cell  = [self.diagonalCellDictionary objectForKey:@(textf.tag)];
        cell.customTextfield.text  = detailModel.Result03?:@"  ";
     
    } if (textf.subTag +3 ==5 || textf.subTag +4 ==5){
        //判定结果
        QCDiagonalSizeCollectionCell *cell  =[self.cellDictionary objectForKey:@(textf.tag)];
        cell.customLabel.text  = detailModel.DecisionResult?:@"  ";
        
    }
}

-(CGSize)chartView:(FormChartView *)chartView sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section  ==0) {
        if (indexPath.row  ==0) {
            if ([self.mainModel.Name isEqualToString:@"尺寸稳定性"]) {
                return CGSizeMake(40, 90);
            }else{
                return CGSizeMake(40, 90);
            }
            
        }else if (indexPath.row  ==4){
            return CGSizeMake(60, 60);
        }else if (indexPath.row  ==5){
            return CGSizeMake(80, 60);
        }
        else{
            return CGSizeMake(LABELH/3, 60);
        }
    }else{
       
         if (indexPath.row  ==0) {
             if ([self.mainModel.Name isEqualToString:@"尺寸稳定性"]) {
                 return CGSizeMake(40, 90);
             }else{
                 return CGSizeMake(40, 90);
             }
             
         }else if (indexPath.row  ==4){
             return CGSizeMake(60, 60);
         }else if (indexPath.row  ==5){
             return CGSizeMake(80, 60);
         }
         else{
             return CGSizeMake(LABELH/3, 60);
         }
    }
}

-(void)setMainModel:(QCSubmitMainModel *)mainModel{
    _mainModel  =mainModel;
    self.chartView.frame  = CGRectMake(2, 0, kScreenWidth-4, mainModel.cellHeight);
    [self.chartView reload];
}
-(void)setupUI{
    [self.contentView addSubview:self.chartView];
    
}

-(void)setOperationTypeStr:(NSString *)operationTypeStr{
    _operationTypeStr =operationTypeStr;
}

-(FormChartView*)chartView{
    if (!_chartView) {
        _chartView  =[[FormChartView alloc]initWithFrame:CGRectZero type:FormTypeNoFixation dataSource:self];
        _chartView.delegate  =self;
        [_chartView registerClass:[QCDiagonalSizeCollectionCell class]];
    }
    return _chartView;
}


-(NSMutableDictionary*)cellDictionary{
    if (!_cellDictionary) {
        _cellDictionary  =[NSMutableDictionary dictionary];
    }
    return _cellDictionary;
}

-(NSMutableDictionary*)diagonalCellDictionary{
    if (!_diagonalCellDictionary) {
        _diagonalCellDictionary  =[NSMutableDictionary dictionary];
    }return _diagonalCellDictionary;
}
@end
