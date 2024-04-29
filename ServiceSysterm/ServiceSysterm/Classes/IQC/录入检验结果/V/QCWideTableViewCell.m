//
//  QCWideTableViewCell.m
//  ServiceSysterm
//
//  Created by Andy on 2021/6/3.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "QCWideTableViewCell.h"
#import "FormChartView.h"

#import "FormCollectionViewCell.h"
#import "QCSIzeCollectionCell.h"


@interface QCWideTableViewCell ()<FormViewDelegate,FormViewDatasource>

@property (nonatomic,strong)FormChartView * chartView;


@end

#define LABELH (kScreenWidth-120)/6

@implementation QCWideTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    ///////////////////宽边尺寸/////////////////////////////////////
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

- (__kindof UICollectionViewCell *)collectionViewCell:(UICollectionViewCell *)collectionViewCell collectionViewType:(FormCollectionViewType)type cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    QCSIzeCollectionCell * cell  =(QCSIzeCollectionCell*) collectionViewCell;
    
    if (indexPath.row  ==0) {
        //编号
        cell.text =[NSString stringWithFormat:@"%ld",self.mainModel.pathNumber+1];
    }else if (indexPath.row  ==1){
        //标题
        cell.text =self.mainModel.Name;
    }else if (indexPath.row  ==2){
        //标号
        cell.text  =[NSString stringWithFormat:@"%ld",indexPath.section+1];
    }else if (indexPath.row ==3){
        //检测结果
        cell.holdString = @"请输入实测值";
    }else if (indexPath.row  ==4){
        //单位
        cell.text  =self.mainModel.TestUnit;
    }else{
        //检测结果
        cell.text =@"";
    }
 
   /* if (indexPath.section  ==0) {
        if (indexPath.row  ==0) {
            cell.text  =@"5";
        }else if (indexPath.row  ==1){
            cell.text  =@"宽边尺寸";
        }else if (indexPath.row  ==2){
            cell.text  =@"1";
        }else if (indexPath.row ==3){
            cell.text  = @"实测值";
        }else if (indexPath.row  ==4){
            cell.text  = @"mm";
        }else{
            cell.text  =@"";
        }
    }else if (indexPath.section  ==1){
        if (indexPath.row ==2) {
            cell.text  =@"2";
        }else if (indexPath.row ==3){
            cell.text =@"实测值";
        }else if (indexPath.row ==4){
            cell.text  =@"mm";
        }else{
            cell.text  =@"";
        }
    }else{
        if (indexPath.row ==2) {
            cell.text  =@"3";
        }else if (indexPath.row ==3){
            cell.text =@"实测值";
        }else if (indexPath.row ==4){
            cell.text  =@"mm";
        }else{
            cell.text  =@"";
        }
    }*/
   
    
    return cell;
}

-(NSInteger)numberOfSectionsInChartView:(FormChartView *)chartView{
    //行数
    return self.mainModel.columnList.count;
}

-(CGSize)chartView:(FormChartView *)chartView sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section  ==0) {
        if (indexPath.row  ==0) {
            return CGSizeMake(60, 60*self.mainModel.columnList.count);
        }else if (indexPath.row  ==1){
            return CGSizeMake(LABELH, 60*self.mainModel.columnList.count);
        }else if (indexPath.row  ==2){
            return CGSizeMake(60, 60);
        }
        else if (indexPath.row  ==3){
            return CGSizeMake(LABELH * 3, 60);
        }else if (indexPath.row  ==3){
            return CGSizeMake(LABELH, 60);
        }else if (indexPath.row  ==4){
            return CGSizeMake(LABELH, 60);
        }
        else{
            return CGSizeMake(LABELH-4, 60);
        }
    }
    /*else if (indexPath.section  ==1){
        if (indexPath.row  ==0) {
            return CGSizeMake(60, 0);
        }else if (indexPath.row  ==1){
            return CGSizeMake(LABELH, 0);
        }else if (indexPath.row  ==2){
            return CGSizeMake(60, 60);
        }
        else if (indexPath.row  ==3){
            return CGSizeMake(LABELH *3 , 60);
        }else if (indexPath.row  ==3){
            return CGSizeMake(LABELH, 60);
        }else if (indexPath.row  ==4){
            return CGSizeMake(LABELH, 60);
        }
        else{
            return CGSizeMake(LABELH-4, 60);
        }
    }
     else if (indexPath.section  ==2){
        if (indexPath.row  ==0) {
            return CGSizeMake(60, 0);
        }else if (indexPath.row  ==1){
            return CGSizeMake(LABELH, 0);
        }else if (indexPath.row  ==2){
            return CGSizeMake(60, 60);
        }
        else if (indexPath.row  ==3){
            return CGSizeMake(LABELH * 3, 60);
        }else if (indexPath.row  ==3){
            return CGSizeMake(LABELH, 60);
        }
        else if (indexPath.row  ==4){
            return CGSizeMake(LABELH, 60);
        }else{
            return CGSizeMake(LABELH-4, 60);
        }
    }else if (indexPath.section ==3){
        if (indexPath.row  ==0) {
            return CGSizeMake(60, 0);
        }else if (indexPath.row  ==1){
            return CGSizeMake(LABELH, 0);
        }else if (indexPath.row  ==2){
            return CGSizeMake(60, 60);
        }
        else if (indexPath.row  ==3){
            return CGSizeMake(LABELH *3 , 60);
        }else if (indexPath.row  ==3){
            return CGSizeMake(LABELH, 60);
        }
        else if (indexPath.row  ==4){
            return CGSizeMake(LABELH, 60);
        }else{
            return CGSizeMake(LABELH-4, 60);
        }
    }*/
     else{
         if (indexPath.row  ==0) {
             return CGSizeMake(60, 0);
         }else if (indexPath.row  ==1){
             return CGSizeMake(LABELH, 0);
         }else if (indexPath.row  ==2){
             return CGSizeMake(60, 60);
         }
         else if (indexPath.row  ==3){
             return CGSizeMake(LABELH * 3, 60);
         }else if (indexPath.row  ==3){
             return CGSizeMake(LABELH, 60);
         }else if (indexPath.row  ==4){
             return CGSizeMake(LABELH, 60);
         }
         else{
             return CGSizeMake(LABELH-4, 60);
         }
    }
   
   
}

-(void)setMainModel:(QCSubmitMainModel *)mainModel{
    _mainModel  =mainModel;
    self.chartView.frame  = CGRectMake(2, 0, kScreenWidth-4, mainModel.cellHeight);
}
-(void)setupUI{
    [self.contentView addSubview:self.chartView];
    
}

-(FormChartView*)chartView{
    if (!_chartView) {
        _chartView  =[[FormChartView alloc]initWithFrame:CGRectZero type:FormTypeNoFixation dataSource:self];
        _chartView.delegate  =self;
        [_chartView registerClass:[QCSIzeCollectionCell class]];
    }
    return _chartView;
}
@end
