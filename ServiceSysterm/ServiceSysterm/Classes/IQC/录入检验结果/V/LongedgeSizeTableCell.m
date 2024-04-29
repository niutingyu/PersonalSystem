//
//  LongedgeSizeTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2021/6/3.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "LongedgeSizeTableCell.h"
#import "FormChartView.h"

#import "QCSIzeCollectionCell.h"
#import "QCJudgeMethod.h"
#import "EMCustomKeyboardView.h"


@interface LongedgeSizeTableCell ()<FormViewDelegate,FormViewDatasource,UITextFieldDelegate>

@property (nonatomic,strong)FormChartView * chartView;

@property (nonatomic,strong)NSMutableDictionary *cellDictionary;

/**
 列数
 */

@property (nonatomic,assign) NSInteger columns;



@end

#define LABELH (kScreenWidth-40-60-80-4)

@implementation LongedgeSizeTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    
  
    
    return (self.mainModel.columnList.count-1)+3;
}

-(NSInteger)numberOfSectionsInChartView:(FormChartView *)chartView{
    //行数
    return self.mainModel.detailList.count;
}

- (__kindof UICollectionViewCell *)collectionViewCell:(UICollectionViewCell *)collectionViewCell collectionViewType:(FormCollectionViewType)type cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    QCSIzeCollectionCell * cell  =(QCSIzeCollectionCell*) collectionViewCell;
 //   QCDetailListModel * detailModel  = self.mainModel.detailList[indexPath.section];
    
    cell.textfield.textIndx  =indexPath;
   // cell.isLabHidden  =YES;
    if (indexPath.row  ==0) {
        //行号
    
        //标号
//        cell.text  = [NSString stringWithFormat:@"%@",detailModel.SampleId];
//        cell.isEdit  =NO;
        [cell setupCellWithchartView:self.chartView rowIdx:indexPath.item sectionIdx:indexPath.section mainModel:self.mainModel];
        
    }else if (indexPath.row ==self.mainModel.columnList.count-1+3-2){
        //单位
//         if (self.mainModel.TestUnit.length  ==0) {
//             cell.text =@"/";
//         }else{
//             cell.text  =self.mainModel.TestUnit;
//         }
//
//        cell.isEdit  =NO;
        [cell setupCellWithchartView:self.chartView rowIdx:indexPath.item sectionIdx:indexPath.section mainModel:self.mainModel];
    }else if (indexPath.row  == self.mainModel.columnList.count-1+3-1){
        //判定结果
       
//        if (detailModel.DecisionResult.length ==0) {
//            cell.text =@"  ";
//        }else{
//            cell.text  =detailModel.DecisionResult;
//        }
//
//        cell.isEdit  =NO;
//        cell.holdString  =@" ";
//        cell.textfield.tag  = indexPath.section;
//
//        cell.textfield.subTag  =indexPath.item-1;
       
        [cell setupCellWithchartView:self.chartView rowIdx:indexPath.item sectionIdx:indexPath.section mainModel:self.mainModel];
        
        [self.cellDictionary setObject:cell forKey:@(indexPath.section)];
    }
    else{
       
        [cell setupCellWithchartView:self.chartView rowIdx:indexPath.item sectionIdx:indexPath.section mainModel:self.mainModel];
        
      //  cell.text = [self cellTextWithIdx:indexPath.item -1 model:detailModel];
        
        cell.textfield.tag  = indexPath.section;
       
        cell.textfield.subTag  =indexPath.item-1;
        
        [cell.textfield addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return cell;
}




-(CGSize)chartView:(FormChartView *)chartView sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section  ==0) {
        if (indexPath.row  ==0) {
            //序号
            return CGSizeMake(40, 60);
        }else if (indexPath.row  == self.mainModel.columnList.count-1+3-1){
            //判定结果
            return CGSizeMake(80, 60);
        }else if (indexPath.row == self.mainModel.columnList.count-1+3-2){
            //单位
            return CGSizeMake(60, 60);
        }else{
          
            return CGSizeMake(LABELH/(self.mainModel.columnList.count-1), 60);
        }
    }else{
        if (indexPath.row  ==0) {
            
            return CGSizeMake(40, 60);
        }else if (indexPath.row  == self.mainModel.columnList.count-1+3-1){
            //判定结果
            return CGSizeMake(80, 60);
        }else if (indexPath.row == self.mainModel.columnList.count-1+3-2){
            //单位
            return CGSizeMake(60, 60);
        }else{
           
            return CGSizeMake(LABELH/(self.mainModel.columnList.count-1), 60);
        }
    }

}

#pragma mark  = == UITextFieldDelegate

-(void)textFieldChanged:(CustomTextField*)textf{
    
    QCSIzeCollectionCell *cell  = [self.cellDictionary objectForKey:@(textf.textIndx.section)];
    
    QCDetailListModel * listModel  = self.mainModel.detailList[textf.tag];

    [self detailModelRessultWithIdx:textf.subTag model:listModel textStr:textf.text];
    [QCJudgeMethod calculateWithName:self.mainModel.Name listModel:listModel mainModel:self.mainModel idx:textf.subTag];
     cell.labelText  =listModel.DecisionResult?:@"  ";
   // listModel.DecisionResult =textf.text?:listModel.DecisionResult;//重新赋值

    
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
        
        [_chartView registerClass:[QCSIzeCollectionCell class]];
     
    }
    return _chartView;
}

-(NSMutableDictionary*)cellDictionary{
    if (!_cellDictionary) {
        _cellDictionary  =[NSMutableDictionary dictionary];
    }return _cellDictionary;
}

/**
 赋值操作
 */

-(NSString*)cellTextWithIdx:(NSInteger)idx model:(QCDetailListModel*)detailModel{
    NSString *resultStr;
    switch (idx) {
        case 0:
            resultStr  =detailModel.Result01;
            break;
        case 1:
            resultStr  =detailModel.Result02;
            break;
        case 2:
            resultStr  =detailModel.Result03;
            break;
        case 3:
            resultStr  =detailModel.Result04;
            break;
        case 4:
            resultStr  =detailModel.Result05;
            break;
        case 5:
            resultStr  =detailModel.Result06;
            break;
        case 6:
            resultStr  =detailModel.Result07;
            break;
        case 7:
            resultStr  =detailModel.Result08;
            break;
        case 8:
            resultStr  =detailModel.Result09;
            break;
        case 9:
            resultStr =detailModel.Result10;
        default:
            break;
    }
    return resultStr;
}

//输入数值
-(void)detailModelRessultWithIdx:(NSInteger)idx model:(QCDetailListModel*)detailModel textStr:(NSString*)textStr{
  
    
    switch (idx) {
        case 0:
            detailModel.Result01 = textStr;
          
            break;
        case 1:
            detailModel.Result02 =textStr;
           
            break;
        case 2:
            detailModel.Result03 =textStr;
           
            break;
        case 3:
            detailModel.Result04 =textStr;
          
            break;
        case 4:
            detailModel.Result05 =textStr;
          
            break;
        case 5:
            detailModel.Result06 =textStr;
            
            break;
        case 6:
            detailModel.Result07 =textStr;
          
            break;
        case 7:
            detailModel.Result08 =textStr;
        
            break;
        case 8:
            detailModel.Result09 =textStr;
            
            break;
        case 9:
            detailModel.Result10 =textStr;
           
            
        default:
            break;
    }
}
@end
