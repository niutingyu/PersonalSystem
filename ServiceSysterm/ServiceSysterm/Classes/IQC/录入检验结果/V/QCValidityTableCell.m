//
//  QCValidityTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2021/6/2.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "QCValidityTableCell.h"
#import "FormChartView.h"

#import "QCSIzeCollectionCell.h"
#import "QCJudgeMethod.h"
#import "EMCustomKeyboardView.h"
@interface QCValidityTableCell ()<FormViewDelegate,FormViewDatasource,UITextFieldDelegate>

@property (nonatomic,strong)FormChartView * chartView;

@property (nonatomic,strong)NSMutableDictionary *cellDictionary;




@end

#define LABELH (kScreenWidth-40-60-80-4)

@implementation QCValidityTableCell

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
    //列数
    return 4;
}

-(NSInteger)numberOfSectionsInChartView:(FormChartView *)chartView{
    //列数
    return self.mainModel.detailList.count;
}

- (__kindof UICollectionViewCell *)collectionViewCell:(UICollectionViewCell *)collectionViewCell collectionViewType:(FormCollectionViewType)type cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    QCSIzeCollectionCell * cell  =(QCSIzeCollectionCell*) collectionViewCell;
    QCDetailListModel *detailModel = self.mainModel.detailList[indexPath.section];
    if (indexPath.row ==0) {
        cell.isLabHidden =YES;
        cell.isEdit  =NO;
        cell.text =[NSString stringWithFormat:@"%@",detailModel.SampleId];
    }else if (indexPath.row ==1){
//        if ([self.operationTypeStr isEqualToString:@"录入检验结果"]&&self.mainModel.RelateTaskCode.length ==0) {
//            cell.isEdit  =YES;
//            EMCustomKeyboardView *keyboard  =[[EMCustomKeyboardView alloc]init];
//            cell.textfield.inputView  =keyboard;
//            keyboard.subView = self.chartView;
//            keyboard.textf  = cell.textfield;
//
//        }else{
//            cell.isEdit  =NO;
//        }
        
        cell.textColor =[UIColor redColor];
     //   cell.text =detailModel.Result01;
      
        [cell setupCellWithchartView:self.chartView rowIdx:indexPath.item sectionIdx:indexPath.section mainModel:self.mainModel];
     //   QCColumnListModel * columnModel = [self.mainModel.columnList firstObject];
       // [cell setupCellWithHolding:columnModel.ColumnName operationStr:self.operationTypeStr relataionCode:self.mainModel.RelateTaskCode chartView:self.chartView];
      //  cell.holdString =columnModel.ColumnName;
        cell.textfield.subTag =0;
        
        [cell.textfield addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        
        
    }else if (indexPath.row ==2){
        //单位
        
        NSString *unitStr;
        
        if (self.mainModel.TestUnit.length ==0) {
            unitStr =@"月";
        }else{
            unitStr  =self.mainModel.TestUnit;
        }
        cell.text =unitStr;
        cell.isEdit  =NO;
    }else{
        //判定结果
        cell.text =detailModel.DecisionResult?:@" ";
        [self.cellDictionary setObject:cell forKey:@(indexPath.section)];
        cell.textfield.tag =indexPath.section;
        cell.isEdit  =NO;
    }
    return cell;
}

-(void)textFieldChanged:(CustomTextField*)textf{
    QCDetailListModel * detailModel  = [self.mainModel.detailList firstObject];
    QCSIzeCollectionCell *cell  =[self.cellDictionary objectForKey:@(textf.tag)];
    detailModel.Result01  = textf.text;
    [QCJudgeMethod calculateWithName:self.mainModel.Name listModel:detailModel mainModel:self.mainModel idx:textf.subTag];
    cell.text =detailModel.DecisionResult?:@" ";
}
-(CGSize)chartView:(FormChartView *)chartView sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row  ==0) {
        return CGSizeMake(40, 60);
    }else if (indexPath.row  ==1){
        return CGSizeMake(LABELH, 60);
    }else if (indexPath.row  ==2){
        return CGSizeMake(60, 60);
    }else{
        return CGSizeMake(80, 60);
    }
}


-(void)setMainModel:(QCSubmitMainModel *)mainModel{
    _mainModel =mainModel;
}

-(void)setOperationTypeStr:(NSString *)operationTypeStr{
    _operationTypeStr =operationTypeStr;
}
-(void)setupUI{
    [self.contentView addSubview:self.chartView];
    
}

-(FormChartView*)chartView{
    if (!_chartView) {
        _chartView  =[[FormChartView alloc]initWithFrame:CGRectMake(2, 0, kScreenWidth-4, 60) type:FormTypeNoFixation dataSource:self];
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


@end
