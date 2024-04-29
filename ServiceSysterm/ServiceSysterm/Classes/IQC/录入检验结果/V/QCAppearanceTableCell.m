//
//  QCAppearanceTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2021/6/3.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "QCAppearanceTableCell.h"
#import "FormChartView.h"

#import "QCAppranceFormCollectionCell.h"

 

@interface QCAppearanceTableCell ()<FormViewDelegate,FormViewDatasource>

@property (nonatomic,strong)FormChartView * chartView;

@end

#define LABELH  (kScreenWidth-40-60-80-4)
@implementation QCAppearanceTableCell


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
    //行数
    
    return self.mainModel.detailList.count;
    
}
- (__kindof UICollectionViewCell *)collectionViewCell:(UICollectionViewCell *)collectionViewCell collectionViewType:(FormCollectionViewType)type cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    QCAppranceFormCollectionCell * cell  =(QCAppranceFormCollectionCell*) collectionViewCell;
    QCDetailListModel * detailModel  = self.mainModel.detailList[indexPath.section];
  
    if (indexPath.row  ==0) {
        //序号
        cell.text =[NSString stringWithFormat:@"%@",detailModel.SampleId];
        cell.labelColor  =[UIColor whiteColor];
    }
    
     else if (indexPath.row  ==1){
         if (self.mainModel.RelateTaskCode.length >0&&[self.mainModel.operationStr isEqualToString:@"录入检验结果"]) {
             cell.labelColor  =RGBA(243, 243, 243, 1);
             
           
         }else{
             cell.labelColor  =[UIColor whiteColor];
         }
         if (detailModel.Result01.length >0) {
             cell.text  = detailModel.Result01;
         }else{
             if (detailModel.DecisionResult.length >0) {
                 if ([detailModel.DecisionResult isEqualToString:@"合格"]) {
                     cell.text  = @"无分层、无起泡、无烧焦、无表面污染";
                 }
             }else{
                 if (self.mainModel.RelateTaskCode >0) {
                     cell.text =@"";
                 }else{
                     cell.text  =@"请选择缺陷项";
                 }
                
             }
             
         }
        
                      
    }else if (indexPath.row  ==2){
        if (self.mainModel.RelateTaskCode.length >0&&[self.mainModel.operationStr isEqualToString:@"录入检验结果"]) {
            cell.labelColor =RGBA(243, 243, 244, 1);
        }else{
            cell.labelColor  =[UIColor whiteColor];
        }
        
        if (self.mainModel.TestUnit.length ==0) {
            cell.text =@"/";
        }else{
            cell.text  =self.mainModel.TestUnit;
        }
       
    }else{
        if (self.mainModel.RelateTaskCode.length >0&&[self.mainModel.operationStr isEqualToString:@"录入检验结果"]) {
            cell.labelColor =RGBA(243, 243, 244, 1);
        }else{
            cell.labelColor  =[UIColor whiteColor];
        }
        
        cell.text  =detailModel.DecisionResult?:@" ";
    }
    
    return cell;
}

-(CGSize)chartView:(FormChartView *)chartView sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section  ==0) {
        if (indexPath.row  ==0) {
            //序号
            return CGSizeMake(40, 60);
        }
         else if (indexPath.row  ==1){
             //检测结果
            return CGSizeMake(LABELH, 60);
        }else if (indexPath.row  ==2){
            //单位
            return CGSizeMake(60, 60);
        }else{
            //判断结果
            return CGSizeMake(80, 60);
        }
    }else{
        if (indexPath.row  ==0) {
            return CGSizeMake(40, 60);
        }
        else if (indexPath.row  ==1){
            //判定结果
            return CGSizeMake(LABELH , 60);
        }else if (indexPath.row  ==2){
            //单位
            return CGSizeMake(60, 60);
        }else{
            //判定结果
            return CGSizeMake(80, 60);
        }
       
    }
   
}

-(void)formCollectionView:(UICollectionView *)collectionView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if ([self.mainModel.operationStr isEqualToString:@"录入检验结果"]||[self.mainModel.operationStr isEqualToString:@"编辑"]) {
        if (indexPath.item  == 1) {
            if (self.mainModel.RelateTaskCode.length ==0) {
                if ([_delegate respondsToSelector:@selector(didSelectedRowAtIndexPath:pathSection:)]) {
                    [_delegate didSelectedRowAtIndexPath:indexPath pathSection:self.mainModel.pathNumber];
                }
            }
           
        }
    }
}

-(void)setupUI{
    [self.contentView addSubview:self.chartView];
    
}
    
-(void)setMainModel:(QCSubmitMainModel *)mainModel{
    _mainModel  =mainModel;
    self.chartView.frame = CGRectMake(2, 0, kScreenWidth-4, mainModel.cellHeight);
    [self.chartView reload];

}
    
-(void)setOperationTypeStr:(NSString *)operationTypeStr{
    _operationTypeStr =operationTypeStr;
}


-(FormChartView*)chartView{
    if (!_chartView) {
        _chartView  =[[FormChartView alloc]initWithFrame:CGRectZero type:FormTypeNoFixation dataSource:self];
        _chartView.delegate  =self;
        [_chartView registerClass:[QCAppranceFormCollectionCell class]];
    }
    return _chartView;
}
@end
