//
//  QCEnterTaskCodeView.m
//  ServiceSysterm
//
//  Created by Andy on 2021/6/2.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "QCEnterTaskCodeView.h"
#import "ArrowMarkButView.h"

#import "QCDateAlertView.h"

@interface QCEnterTaskCodeView ()
/**
 任务单号
 */
@property (nonatomic,strong)UILabel *taskContentLab;

/**
 收货时间
 */
@property (nonatomic,strong)UILabel *receiveButView;

/**
 收货数量
 */
@property (nonatomic,strong)UILabel *receiveCountContentLab;

/**
 物料编码
 */
@property (nonatomic,strong)UILabel *materialNumberLab;

/**
 物料名称
 */
@property (nonatomic,strong)UILabel *materialNameLab;

/**
 供应商批次
 */
@property (nonatomic,strong)UILabel *supBarCodeLab;

/**
 物料规格
 */
@property (nonatomic,strong)UILabel *materilaLInfoLab;

/**
 生产日期
 */
@property (nonatomic,strong)UILabel * productContentLab;

/**
 有效期
 */
@property (nonatomic,strong)UILabel *expLab;

/**
 状态
 */
@property (nonatomic,strong)UILabel *statusLab;

@end
@implementation QCEnterTaskCodeView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self  =[super initWithFrame:frame]) {
        
        self.backgroundColor  = RGBA(242, 242, 242, 1);
        
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    CGFloat height  = 40;
    
    UIFont *font  =[UIFont systemFontOfSize:17];
    
  //  UIFont *blackFont  =[UIFont systemFontOfSize:16 weight:0.25];
    
    UIView * view1  =[[UIView alloc]init];
    view1.backgroundColor  =[UIColor whiteColor];
    [self addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(3);
        make.top.mas_offset(8);
        make.right.mas_offset(-3);
        make.height.mas_equalTo(height);
    }];
    
    
    
    
  //  CGFloat labWidth  = 80;
    
   // CGFloat width  = (kScreenWidth-3*labWidth-6-32-15)/3;
    CGFloat width  = (kScreenWidth-16-16-8-8)/3;
    
 //   UIColor * labColor  =RGBA(242, 242, 242, 1);
   
    //任务单号
    UILabel *taskLab  =[[UILabel alloc]init];
    taskLab.font  =font;
    taskLab.text =@"任务单号:";
    self.taskContentLab  =taskLab;
    [view1 addSubview:taskLab];
    [taskLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(16);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(width);
    }];
//    UILabel * taskContentLab  =[[UILabel alloc]init];
//    taskContentLab.font  =blackFont;
//    taskContentLab.text  =@"IQC210319207";
//   // taskContentLab.backgroundColor  = labColor;
//    self.taskContentLab  = taskContentLab;
//    [view1 addSubview:taskContentLab];
//    [taskContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(taskLab.mas_right).mas_offset(5);
//        make.top.mas_offset(5);
//        make.bottom.mas_offset(-5);
//
//        make.width.mas_equalTo(width);
//    }];
    
    //收货时间
    
    UILabel * receiveTimeLab  =[[UILabel alloc]init];
    receiveTimeLab.font  =font;
    receiveTimeLab.text =@"录单时间:";
    self.receiveButView  =receiveTimeLab;
    [view1 addSubview:receiveTimeLab];
    [receiveTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(taskLab.mas_right).mas_offset(8);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(width);
    }];
//    UILabel * receiveTimeBut  =[[UILabel alloc]init];
//    receiveTimeBut.font  =blackFont;
//
//    self.receiveButView  = receiveTimeBut;
//    [view1 addSubview:receiveTimeBut];
//
//    [receiveTimeBut mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(receiveTimeLab.mas_right).mas_offset(1);
//        make.top.bottom.mas_offset(0);
//        make.width.mas_equalTo(width);
//    }];

    
    //收货数量

//    UILabel * receiveCountContentLab  =[[UILabel alloc]init];
//    receiveCountContentLab.font  =blackFont;
//    receiveCountContentLab.text = @"300";
//    self.receiveCountContentLab  =receiveCountContentLab;
//    [view1 addSubview:receiveCountContentLab];
//    [receiveCountContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_offset(-8);
//        make.top.bottom.mas_offset(0);
//        make.width.mas_equalTo(width);
//    }];
    
    UILabel * receiveCountLab  =[[UILabel alloc]init];
    receiveCountLab.font  =font;
    receiveCountLab.text =@"检验数量:";
    self.receiveCountContentLab =receiveCountLab;
    [view1 addSubview:receiveCountLab];
    [receiveCountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(receiveTimeLab.mas_right).mas_offset(8);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(width);
    }];
    
    UIView * view2  =[[UIView alloc]init];
    view2.backgroundColor  =[UIColor whiteColor];
    [self addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(3);
        make.top.mas_equalTo(view1.mas_bottom).mas_offset(0);
        make.right.mas_offset(3);
        make.height.mas_equalTo(height);
    }];
    
    //物料编码
    UILabel * codeLab  =[[UILabel alloc]init];
    codeLab.font  =font;
    codeLab.text =@"物料编码:";
    self.materialNumberLab  =codeLab;
    [view2 addSubview:codeLab];
    [codeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(16);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(width);
    }];
    
//    UILabel * codeContentLab  =[[UILabel alloc]init];
//    codeContentLab.font  =blackFont;
//    codeContentLab.text  =@"SZ104033403TU1";
//    self.codeContentLab =codeContentLab;
//    [view2 addSubview:codeContentLab];
//    [codeContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(codeLab.mas_right).mas_offset(5);
//        make.top.bottom.mas_offset(0);
//        make.width.mas_equalTo(width);
//    }];
    
    //物料名称
    UILabel * materialNameLab  =[[UILabel alloc]init];
    materialNameLab.font  =font;
    materialNameLab.text =@"物料名称:";
    self.materialNameLab  =materialNameLab;
    [view2 addSubview:materialNameLab];
    [materialNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(codeLab.mas_right).mas_offset(8);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(width);
    }];
    
//    UILabel * nameContentLab  =[[UILabel alloc]init];
//    nameContentLab.font  =blackFont;
//    nameContentLab.text =@"FR-4板材";
//    self.nameContentLab  =nameContentLab;
//    [view2 addSubview:nameContentLab];
//    [nameContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(materialNameLab.mas_right).mas_offset(5);
//        make.top.bottom.mas_offset(0);
//        make.width.mas_equalTo(width);
//    }];
    
    //供应商批次
    
//    UILabel * applierContentLab  =[[UILabel alloc]init];
//    applierContentLab.font  =blackFont;
//    applierContentLab.text =@"210309B2";
//    self.applierContentLab  =applierContentLab;
//    [view2 addSubview:applierContentLab];
//    [applierContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_offset(-8);
//        make.top.bottom.mas_offset(0);
//        make.width.mas_equalTo(width);
//    }];
    UILabel *applierLab =[[UILabel alloc]init];
    applierLab.font  =font;
    applierLab.text =@"供应商批号:";
    self.supBarCodeLab  =applierLab;
    [view2 addSubview:applierLab];
    [applierLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(materialNameLab.mas_right).mas_offset(8);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(width);
    }];
    

    
    UIView * view3  =[[UIView alloc]init];
    view3.backgroundColor  =[UIColor whiteColor];
    [self addSubview:view3];
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(3);
        make.top.mas_equalTo(view2.mas_bottom).mas_offset(0);
        make.right.mas_offset(-3);
        make.height.mas_equalTo(height);
    }];
    
    //物料规格
    UILabel * typeLab =[[UILabel alloc]init];
    typeLab.font  =font;
    typeLab.text  =@"物料规格:";
    self.materilaLInfoLab  =typeLab;
    [view3 addSubview:typeLab];
    [typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(16);
        make.top.bottom.mas_offset(0);
        make.right.mas_offset(-16);
       // make.width.mas_equalTo(labWidth);
    }];
//    UILabel * typeContentLab  =[[UILabel alloc]init];
//    typeContentLab.font  =blackFont;
//    typeContentLab.text  =@"FR4成品铜厚内外层1OZ 有铅喷锡/OSP";
//    typeContentLab.textAlignment  =NSTextAlignmentLeft;
//    self.infoContentLab  = typeContentLab;
//    [view3 addSubview:typeContentLab];
//    [typeContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(typeLab.mas_right).mas_offset(5);
//        make.top.bottom.mas_offset(0);
//        make.right.mas_offset(-8);
//    }];
    
    UIView * view4 =[[UIView alloc]init];
    view4.backgroundColor  =[UIColor whiteColor];
    [self addSubview:view4];
    [view4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(3);
        make.top.mas_equalTo(view3.mas_bottom).mas_offset(0);
        make.right.mas_offset(-3);
        make.height.mas_equalTo(height);
    }];
    
    //生产日期
    UILabel * productTimeLab  =[[UILabel alloc]init];
    productTimeLab.font  =font;
    productTimeLab.text  =@"生产日期:";
    self.productContentLab  =productTimeLab;
    [view4 addSubview:productTimeLab];
    [productTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(16);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(width);
    }];

    //有效期
    UILabel * validityLab  =[[UILabel alloc]init];
    validityLab.font  =font;
    validityLab.text  =@"有效期:";
    self.expLab  =validityLab;
    [view4 addSubview:validityLab];
    [validityLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(productTimeLab.mas_right).mas_offset(8);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(width);
    }];
    
    UILabel * statusLab  =[[UILabel alloc]init];
    statusLab.font =font;
    self.statusLab  =statusLab;
    [view4 addSubview:statusLab];
    [statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(validityLab.mas_right).mas_offset(8);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(width);
    }];

    
    //检测项目
    UIView * view5 =[[UIView alloc]init];
    view5.backgroundColor  =RGBA(200, 214, 242, 1);
    [self addSubview:view5];
    [view5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(2);
        make.top.mas_equalTo(view4.mas_bottom).mas_offset(0);
        make.right.mas_offset(-2);
        make.height.mas_equalTo(36);
    }];
    
    //序号
    UIFont * fontH  =[UIFont systemFontOfSize:17 weight:0.5];
    
    //序号 50 检验项目 100 单位80  检查结果 100；
    CGFloat labelH  = (kScreenWidth-40-60-80-4);
    UILabel * numberLab  =[[UILabel alloc]init];
    
    numberLab.font  =fontH;
    numberLab.textAlignment  = NSTextAlignmentCenter;
    numberLab.text  =@"序号";
    [view5 addSubview:numberLab];
    [numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_offset(0);
        make.width.mas_equalTo(40);
    }];
    
    UIView * line1  =[[UIView alloc]init];
    line1.backgroundColor  = [UIColor darkGrayColor];
    [view5 addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(numberLab.mas_right).mas_offset(0);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(0.5);
    }];
    
 
    //检验结果
    UILabel * resultLab  =[[UILabel alloc]init];
    resultLab.font  =fontH;
    resultLab.text =@"检验结果";
    resultLab.textAlignment  =NSTextAlignmentCenter;
    [view5 addSubview:resultLab];
    [resultLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line1.mas_right).mas_offset(0);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(labelH );
    }];
    
    UIView * line3  =[[UIView alloc]init];
    line3.backgroundColor =[UIColor darkGrayColor];
    [view5 addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(resultLab.mas_right).mas_offset(0);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(0.5);
    }];
    
    //单位
    UILabel * unitLab =[[UILabel alloc]init];
    unitLab.font  = fontH;
    unitLab.text =@"单位";
    unitLab.textAlignment  =NSTextAlignmentCenter;
    [view5 addSubview:unitLab];
    [unitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line3.mas_right).mas_offset(0);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(60);
    }];
    UIView * line4 =[[UIView alloc]init];
    line4.backgroundColor  = [UIColor darkGrayColor];
    [view5 addSubview:line4];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(unitLab.mas_right).mas_offset(0);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(0.5);
    }];
    //判定结果
    UILabel * checkResultLab  =[[UILabel alloc]init];
    checkResultLab.font = fontH;
    checkResultLab.text  = @"判定结果";
    checkResultLab.textAlignment  =NSTextAlignmentCenter;
    [view5 addSubview:checkResultLab];
    [checkResultLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line4.mas_right).mas_offset(0);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(80);
    }];
    
    
}

-(void)setListModel:(IQCListModel *)listModel{
    
    _listModel  =listModel;

    //任务单号
    self.taskContentLab.text  =[NSString stringWithFormat:@"任务单号:%@",listModel.IQCCode];
    //录单时间
    self.receiveButView.text =[NSString stringWithFormat:@"来料日期:%@",[Units timeWithTime:listModel.IQCOn beforeFormat:@"yyyy-MM-dd HH:mm:ss" andAfterFormat:@"yyyy-MM-dd HH:mm"]];
    //检验数量
    self.receiveCountContentLab.text  = [NSString stringWithFormat:@"检验数量:%@(%@)",listModel.TotalCount,listModel.UnitName];
    //物料编码
    self.materialNumberLab.text =[NSString stringWithFormat:@"物料编码:%@",listModel.MaterialCode];
    //物料名称
    self.materialNameLab.text = [NSString stringWithFormat:@"物料名称:%@",listModel.MaterialName];
    //供应商批号
    self.supBarCodeLab.text =[NSString stringWithFormat:@"供应商批号:%@",listModel.SupBarcode?:@""];
    //物料规格
    self.materilaLInfoLab.text =[NSString stringWithFormat:@"物料规格:%@",listModel.MaterialInfo];
    //生产日期
    self.productContentLab.text  =[NSString stringWithFormat:@"生产日期:%@",[Units timeWithTime:listModel.MfgDate beforeFormat:@"yyyy-MM-dd HH:mm:ss" andAfterFormat:@"yyyy-MM-dd"]];
    //有效期
    self.expLab.text =[NSString stringWithFormat:@"有效期:%@",[Units timeWithTime:listModel.ExpDate beforeFormat:@"yyyy-MM-dd HH:mm:ss" andAfterFormat:@"yyyy-MM-dd"]];
    //状态
    self.statusLab.text = [NSString stringWithFormat:@"状态:%@",listModel.statusStr];
    

}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    frame.origin.x +=2;
    frame.size.width -=4;
    
}
@end
