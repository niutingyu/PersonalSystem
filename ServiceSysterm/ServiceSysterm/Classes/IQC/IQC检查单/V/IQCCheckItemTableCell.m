//
//  IQCCheckItemTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2021/7/9.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "IQCCheckItemTableCell.h"
#import "CustomRectLabel.h"
#import "IQCDatePickerView.h"
#import "YBPopupMenu.h"
#import "QCDateController.h"
@interface IQCCheckItemTableCell ()<YBPopupMenuDelegate,UIPopoverPresentationControllerDelegate>

/**
 检验单号
 */

@property (nonatomic,strong)UILabel * codeContentLab;

/**
 检验类型
 */
@property (nonatomic,strong)UILabel * typeContentLab;

/**
 所属工厂
 */
@property (nonatomic,strong)UILabel * factoryContentLab;

/**
 物料名称
 */
@property (nonatomic,strong)UILabel * nameContentLab;

/**
 物料编码
 */
@property (nonatomic,strong)UILabel * numberContentLab;

/**
 收货数量
 */
@property (nonatomic,strong)UILabel * countContentLab;

/**
 合格数量
 */
@property (nonatomic,strong)UILabel * passContentLab;

/**
 物料规格
 */
@property (nonatomic,strong)UILabel * infoContentLab;

/**
 不合格数量
 */
@property (nonatomic,strong)UILabel * nonConformityContentLab;

/**
 特采数量
 */
@property (nonatomic,strong)UILabel * specialContentLab;

/**
 有限期
 */
@property (nonatomic,strong)UIButton * expContentLab;

/**
 生产日期
 */
@property (nonatomic,strong)UILabel * productContentLab;

@property (nonatomic,strong)UIImageView *arrowMark;

@end
@implementation IQCCheckItemTableCell

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

-(void)setupUI{
    self.contentView.backgroundColor  =[UIColor whiteColor];
    self.layer.cornerRadius  =3;
    self.clipsToBounds  =YES;
    
    UIView * bottomView  =[[UIView alloc]init];
    bottomView.backgroundColor  =RGBA(242, 242, 242, 1);
    [self.contentView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_offset(0);
    }];
   // CGFloat labWidth = 85;
   // CGFloat cellWidth  = (kScreenWidth -16-5-8-5-8-5-16-85-85-85)/3;
    CGFloat cellWidth  =(kScreenWidth -16-16-8-8)/3;
    CGFloat labHeight =40;
    
    
    UIView * view1  =[[UIView alloc]init];
    view1.backgroundColor  = [UIColor whiteColor];
    [bottomView addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(2);
        make.top.mas_offset(6);
        make.right.mas_offset(-2);
        make.height.mas_equalTo(labHeight+2);
    }];
   //检验单号
    UILabel * sampleNumberLab  =[[UILabel alloc]init];
    sampleNumberLab.text  =@"检验单号:";
    
    self.codeContentLab =sampleNumberLab;
    [bottomView addSubview:sampleNumberLab];
    [sampleNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(16);
        make.top.mas_offset(8);
        make.width.mas_equalTo(cellWidth);
        make.height.mas_equalTo(labHeight);
    }];
//    CustomRectLabel * codeContentLab  =[[CustomRectLabel alloc]init];
//    codeContentLab.font  =[UIFont systemFontOfSize:16];
//    codeContentLab.backgroundColor  =labColor;
//   // codeContentLab.layer.borderWidth  =0.5;
//   // codeContentLab.layer.borderColor =[UIColor darkGrayColor].CGColor;
//    codeContentLab.layer.cornerRadius  =3;
//    codeContentLab.clipsToBounds  =YES;
//    codeContentLab.text  =@"IQC210319207";
//    codeContentLab.textInsets  =UIEdgeInsetsMake(0, 10, 0, 0);
//    self.codeContentLab  = codeContentLab;
//    [bottomView addSubview:codeContentLab];
//    [codeContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(sampleNumberLab.mas_right).mas_offset(5);
//        make.top.mas_offset(8);
//        make.width.mas_equalTo(cellWidth);
//        make.height.mas_equalTo(labHeight);
//    }];
    //检查类型
    UILabel * typeLab  =[[UILabel alloc]init];
    typeLab.text  = @"检查类型:";
    self.typeContentLab =typeLab;
    [bottomView addSubview:typeLab];
    [typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sampleNumberLab.mas_right).mas_offset(8);
        make.top.mas_offset(8);
        make.width.mas_equalTo(cellWidth);
        make.height.mas_equalTo(labHeight);
    }];
//    CustomRectLabel * typeContentLab =[[CustomRectLabel alloc]init];
//    typeContentLab.font  =[UIFont systemFontOfSize:15];
//    typeContentLab.backgroundColor  = labColor;
//    typeContentLab.layer.cornerRadius  =3;
//    typeContentLab.clipsToBounds  =YES;
//    typeContentLab.textInsets  =UIEdgeInsetsMake(0, 10, 0, 0);
//    self.typeContentLab  = typeContentLab;
//    [bottomView addSubview:typeContentLab];
//    [typeContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(typeLab.mas_right).mas_offset(5);
//        make.top.mas_offset(8);
//        make.width.mas_equalTo(cellWidth);
//        make.height.mas_equalTo(labHeight);
//    }];
//
    //所属工厂
    UILabel * factoryLab  =[[UILabel alloc]init];
    factoryLab.text =@"所属工厂:";
    self.factoryContentLab  =factoryLab;
    [bottomView addSubview:factoryLab];
    [factoryLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(typeLab.mas_right).mas_offset(8);
        make.top.mas_offset(8);
        make.width.mas_equalTo(cellWidth);
        make.height.mas_equalTo(labHeight);
    }];
    
//    CustomRectLabel * factoyContentLab =[[CustomRectLabel alloc]init];
//    factoyContentLab.font  =[UIFont systemFontOfSize:15];
//    factoyContentLab.backgroundColor  = labColor;
//    factoyContentLab.layer.cornerRadius  =3;
//    factoyContentLab.clipsToBounds  =YES;
//    factoyContentLab.textInsets    = UIEdgeInsetsMake(0, 10, 0, 0);
//    self.factoryContentLab  = factoyContentLab;
//
//    [bottomView addSubview:factoyContentLab];
//    [factoyContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(factoryLab.mas_right).mas_offset(5);
//        make.top.mas_offset(8);
//        make.right.mas_offset(-16);
//        make.height.mas_equalTo(labHeight);
//    }];
    
    UIView * view2  =[[UIView alloc]init];
    view2.backgroundColor  = [UIColor whiteColor];
    [bottomView addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(2);
        make.top.mas_equalTo(sampleNumberLab.mas_bottom).mas_offset(10);
        make.right.mas_offset(-2);
        make.height.mas_equalTo(labHeight+2);
    }];
    
    //物料名称
    UILabel * nameLab  =[[UILabel alloc]init];
    nameLab.text =@"物料名称:";
    self.nameContentLab  =nameLab;;
    [bottomView addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(16);
        make.top.mas_equalTo(sampleNumberLab.mas_bottom).mas_offset(12);
        make.width.mas_equalTo(cellWidth);
        make.height.mas_equalTo(labHeight);
    }];
//    CustomRectLabel * nameContentLab  =[[CustomRectLabel alloc]init];
//    nameContentLab.font  =[UIFont systemFontOfSize:15];
//    nameContentLab.backgroundColor  = labColor;
//    nameContentLab.layer.cornerRadius  =3;
//    nameContentLab.clipsToBounds  =YES;
//    nameContentLab.textInsets     = UIEdgeInsetsMake(0, 10, 0, 0);
//    self.nameContentLab  =nameContentLab;
//    [bottomView addSubview:nameContentLab];
//    [nameContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(nameLab.mas_right).mas_offset(5);
//        make.top.mas_equalTo(codeContentLab.mas_bottom).mas_offset(12);
//        make.width.mas_equalTo(cellWidth);
//        make.height.mas_equalTo(labHeight);
//    }];
    //物料编码
    UILabel * numberLab  =[[UILabel alloc]init];
    numberLab.text  =@"物料编码:";
    self.numberContentLab  =numberLab;
    [bottomView addSubview:numberLab];
    [numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLab.mas_right).mas_offset(8);
        make.top.mas_equalTo(typeLab.mas_bottom).mas_offset(12);
        make.width.mas_equalTo(cellWidth);
        make.height.mas_equalTo(labHeight);
    }];
    
//    CustomRectLabel * numberContentLab  =[[CustomRectLabel alloc]init];
//    numberContentLab.font  =[UIFont systemFontOfSize:15];
//    numberContentLab.backgroundColor  = labColor;
//    numberContentLab.layer.cornerRadius  =3;
//    numberContentLab.clipsToBounds  =YES;
//    numberContentLab.text  =@"SZ104033403TU1";
//    numberContentLab.textInsets  =UIEdgeInsetsMake(0, 10, 0, 0);
//    self.numberContentLab  =numberContentLab;
//    [bottomView addSubview:numberContentLab];
//    [numberContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(numberLab.mas_right).mas_offset(5);
//        make.top.mas_equalTo(typeContentLab.mas_bottom).mas_offset(12);
//        make.width.mas_equalTo(cellWidth);
//        make.height.mas_equalTo(labHeight);
//    }];
    //收货数量
    UILabel * countLab  =[[UILabel alloc]init];
    countLab.text  =@"检验数量:";
    self.countContentLab  =countLab;
    [bottomView addSubview:countLab];
    [countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(numberLab.mas_right).mas_offset(8);
        make.top.mas_equalTo(factoryLab.mas_bottom).mas_offset(12);
        make.width.mas_equalTo(cellWidth);
        make.height.mas_equalTo(labHeight);
    }];
//    CustomRectLabel * countContentLab =[[CustomRectLabel alloc]init];
//    countContentLab.font =[UIFont systemFontOfSize:15];
//    countContentLab.backgroundColor  = labColor;
//    countContentLab.layer.cornerRadius  =3;
//    countContentLab.clipsToBounds  =YES;
//    countContentLab.textInsets     = UIEdgeInsetsMake(0, 10, 0, 0);
//    self.countContentLab  = countContentLab;
//    [bottomView addSubview:countContentLab];
//    [countContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(countLab.mas_right).mas_offset(5);
//        make.top.mas_equalTo(factoyContentLab.mas_bottom).mas_offset(12);
//        make.right.mas_offset(-16);
//        make.height.mas_equalTo(labHeight);
//    }];
    
    UIView *view3  =[[UIView alloc]init];
    view3.backgroundColor  = [UIColor whiteColor];
    [bottomView addSubview:view3];
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(2);
        make.top.mas_equalTo(nameLab.mas_bottom).mas_offset(10);
        make.right.mas_offset(-2);
        make.height.mas_equalTo(labHeight+2);
    }];
    //合格数量
    UILabel * passLab  =[[UILabel alloc]init];
    passLab.text =@"合格数量:";
    self.passContentLab  =passLab;
    [bottomView addSubview:passLab];
    [passLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(16);
        make.top.mas_equalTo(nameLab.mas_bottom).mas_offset(12);
        make.width.mas_equalTo(cellWidth);
        make.height.mas_equalTo(labHeight);
    }];
    
//    CustomRectLabel * passContentLab  =[[CustomRectLabel alloc]init];
//    passContentLab.font =[UIFont systemFontOfSize:15];
//    passContentLab.backgroundColor  = labColor;
//    passContentLab.layer.cornerRadius  =3;
//    passContentLab.clipsToBounds  =YES;
//    passContentLab.textInsets    = UIEdgeInsetsMake(0, 10, 0, 0);
//    self.passContentLab  =passContentLab;
//    [bottomView addSubview:passContentLab];
//    [passContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(passLab.mas_right).mas_offset(5);
//        make.top.mas_equalTo(nameContentLab.mas_bottom).mas_offset(12);
//        make.width.mas_equalTo(cellWidth);
//        make.height.mas_equalTo(labHeight);
//    }];
    
    //不合格数量
    UILabel * nonConformityLab  =[[UILabel alloc]init];
    nonConformityLab.text =@"不合格数量:";
    self.nonConformityContentLab =nonConformityLab;
    [bottomView addSubview:nonConformityLab];
    [nonConformityLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(passLab.mas_right).mas_offset(8);
        make.top.mas_equalTo(numberLab.mas_bottom).mas_offset(12);
        make.width.mas_equalTo(cellWidth);
        make.height.mas_equalTo(labHeight);
    }];
//    CustomRectLabel * nonConformityContentLab  =[[CustomRectLabel alloc]init];
//    nonConformityContentLab.font  =[UIFont systemFontOfSize:15];
//    nonConformityContentLab.backgroundColor  = labColor;
//    nonConformityContentLab.layer.cornerRadius  =3;
//    nonConformityContentLab.clipsToBounds  =YES;
//    nonConformityContentLab.textInsets     = UIEdgeInsetsMake(0, 10, 0, 0);
//    self.nonConformityContentLab  =nonConformityContentLab;
//    [bottomView addSubview:nonConformityContentLab];
//    [nonConformityContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(nonConformityLab.mas_right).mas_offset(5);
//        make.top.mas_equalTo(numberContentLab.mas_bottom).mas_offset(12);
//        make.width.mas_equalTo(cellWidth);
//        make.height.mas_equalTo(labHeight);
//    }];
    
    //特采数量
    UILabel * specialLab =[[UILabel alloc]init];
    specialLab.text =@"特采数量:";
    self.specialContentLab  =specialLab;
    [bottomView addSubview:specialLab];
    [specialLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nonConformityLab.mas_right).mas_offset(8);
        make.top.mas_equalTo(countLab.mas_bottom).mas_offset(12);
        make.width.mas_equalTo(cellWidth);
        make.height.mas_equalTo(labHeight);
    }];
//    CustomRectLabel * specialContentLab  =[[CustomRectLabel alloc]init];
//    specialContentLab.font  =[UIFont systemFontOfSize:15];
//    specialContentLab.backgroundColor  = labColor;
//    specialContentLab.layer.cornerRadius  =3;
//    specialContentLab.clipsToBounds  =YES;
//    specialContentLab.textInsets  =UIEdgeInsetsMake(0, 10, 0, 0);
//    self.specialContentLab  =specialContentLab;
//    [bottomView addSubview:specialContentLab];
//    [specialContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(specialLab.mas_right).mas_offset(5);
//        make.top.mas_equalTo(countContentLab.mas_bottom).mas_offset(12);
//        make.width.mas_equalTo(cellWidth);
//        make.height.mas_equalTo(labHeight);
//    }];
    
    UIView * view4 =[[UIView alloc]init];
    view4.backgroundColor  =[UIColor whiteColor];
    [bottomView addSubview:view4];
    [view4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(2);
        make.top.mas_equalTo(passLab.mas_bottom).mas_offset(10);
        make.right.mas_offset(-2);
        make.height.mas_equalTo(labHeight+2);
    }];
    
    //物料规格
    UILabel * infoLab  =[[UILabel alloc]init];
    infoLab.text  =@"物料规格:";
    self.infoContentLab  =infoLab;
    [bottomView addSubview:infoLab];
    [infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(16);
        make.top.mas_equalTo(passLab.mas_bottom).mas_offset(12);
        make.right.mas_offset(-16);
        make.height.mas_equalTo(labHeight);
    }];
    
//    CustomRectLabel * infoContentLab  =[[CustomRectLabel alloc]init];
//    infoContentLab.font  =[UIFont systemFontOfSize:15];
//    infoContentLab.backgroundColor  = labColor;
//    infoContentLab.textInsets  = UIEdgeInsetsMake(0, 10, 0, 0);
//    infoContentLab.layer.cornerRadius  =3;
//    infoContentLab.clipsToBounds  =YES;
//
//    self.infoContentLab  = infoContentLab;
//    [bottomView addSubview:infoContentLab];
//    [infoContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(infoLab.mas_right).mas_offset(5);
//        make.top.mas_equalTo(passContentLab.mas_bottom).mas_offset(12);
//        make.right.mas_offset(-16);
//        make.height.mas_equalTo(labHeight);
//    }];
    
    UIView *view5  =[[UIView alloc]init];
    view5.backgroundColor =[UIColor whiteColor];
    [bottomView addSubview:view5];
    [view5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(2);
        make.top.mas_equalTo(infoLab.mas_bottom).mas_offset(10);
        make.right.mas_offset(-2);
        make.height.mas_equalTo(labHeight+2);
    }];
    
 
    

//    UITapGestureRecognizer * tap  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(expTap:)];
//    [expContentLab addGestureRecognizer:tap];
    
    //生产日期
    UILabel * IqcOnLab  =[[UILabel alloc]init];
    IqcOnLab.text  =@"生产日期:";
    self.productContentLab  =IqcOnLab;
    [bottomView addSubview:IqcOnLab];
    [IqcOnLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(16);
        make.top.mas_equalTo(infoLab.mas_bottom).mas_offset(12);
        make.width.mas_equalTo(cellWidth);
        make.height.mas_equalTo(labHeight);
      
    }];
    
//    CustomRectLabel * IqcOnContentLab =[[CustomRectLabel alloc]init];
//    IqcOnContentLab.backgroundColor  = labColor;
//    IqcOnContentLab.font  =[UIFont systemFontOfSize:15];
//    IqcOnContentLab.textInsets    =UIEdgeInsetsMake(0, 10, 0, 0);
//    self.productContentLab  =IqcOnContentLab;
//    [bottomView addSubview:IqcOnContentLab];
//    [IqcOnContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(IqcOnLab.mas_right).mas_offset(5);
//        make.top.mas_equalTo(infoContentLab.mas_bottom).mas_offset(12);
//        make.width.mas_equalTo(cellWidth);
//        make.height.mas_equalTo(labHeight);
//    }];
    
    //有效期
    UILabel * expLab  =[[UILabel alloc]init];
    expLab.text  =@"有效期:";
    expLab.userInteractionEnabled  =NO;
    
    [bottomView addSubview:expLab];
    [expLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(IqcOnLab.mas_right).mas_offset(8);
        make.top.mas_equalTo(infoLab.mas_bottom).mas_offset(12);
        make.width.mas_equalTo(85);
        make.height.mas_equalTo(labHeight);
    }];
 
    
    
    //
    UIButton * expContentBut =[UIButton buttonWithType:UIButtonTypeCustom];
    expContentBut.titleLabel.font  =[UIFont systemFontOfSize:15];
    [expContentBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    expContentBut.layer.borderWidth  =0.5;
//    expContentBut.layer.borderColor  =RGBA(234, 234, 234, 1).CGColor;
    expContentBut.layer.cornerRadius  =3;
    expContentBut.clipsToBounds  =YES;
   // expContentBut.backgroundColor  =labColor;
    expContentBut.titleEdgeInsets  =UIEdgeInsetsMake(0, 10, 0, 0);
    [expContentBut addTarget:self action:@selector(expMethod:) forControlEvents:UIControlEventTouchUpInside];
    expContentBut.userInteractionEnabled  =NO;
    self.expContentLab  =expContentBut;
    [bottomView addSubview:expContentBut];
    [expContentBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(expLab.mas_right).mas_offset(5);
        make.top.mas_equalTo(infoLab.mas_bottom).mas_offset(12);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(labHeight);

    }];
    
    UIImageView * arrowMark  =[[UIImageView alloc]init];
    arrowMark.image  =[UIImage imageNamed:@"jiantou"];
    arrowMark.contentMode  =UIViewContentModeScaleAspectFit;
    arrowMark.hidden =YES;
    self.arrowMark  =arrowMark;
    [bottomView addSubview:arrowMark];
    [arrowMark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(expContentBut.mas_right).mas_offset(1);
        make.centerY.mas_equalTo(expLab);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(10);
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getSelectDate:) name:@"date" object:nil];
    
}

-(void)getSelectDate:(NSNotification*)notification{
    KWeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.arrowMark.transform = CGAffineTransformIdentity;
    }];
    
    [[Units viewController:self] dismissViewControllerAnimated:YES completion:nil];
    NSDictionary *dict  =[notification object];
    NSString * yearStr  =[dict objectForKey:@"year"];
    NSString *monthStr  =[dict objectForKey:@"month"];
    NSString  *dayStr  =[dict objectForKey:@"day"];
    NSString *dateStr  =[NSString stringWithFormat:@"%@-%@-%@",yearStr,monthStr,dayStr];
    
    [self.expContentLab setTitle:[Units timeWithTime:dateStr beforeFormat:@"yyyy-MM-dd" andAfterFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];
   // self.expContentLab.se =[Units timeWithTime:dateStr beforeFormat:@"yyyy-MM-dd" andAfterFormat:@"yyyy-MM-dd"];
    self.listModel.ExpDate  =[Units timeWithTime:dateStr beforeFormat:@"yyyy-MM-dd" andAfterFormat:@"yyyy-MM-dd HH:mm:ss"];

    
    
}
-(void)expMethod:(UIButton*)sender{
   
    KWeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.arrowMark.transform = CGAffineTransformMakeRotation(M_PI);
    }];
  
    QCDateController * controller  =[[QCDateController alloc]init];
    controller.preferredContentSize =CGSizeMake(330, 400);
    controller.modalPresentationStyle  =UIModalPresentationPopover;
    controller.popoverPresentationController.delegate =self;
    controller.popoverPresentationController.sourceView  = sender;
    controller.popoverPresentationController.sourceRect =CGRectMake(0, sender.frame.size.height*0.5, sender.frame.size.width/2, sender.frame.size.height/2);
    controller.popoverPresentationController.permittedArrowDirections =UIPopoverArrowDirectionUp;
    [[Units viewController:self] presentViewController:controller animated:YES completion:^{
            
    }];
   
    
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    KWeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.arrowMark.transform = CGAffineTransformIdentity;
    }];
   
    return YES;
}
-(void)setListModel:(IQCListModel *)listModel{
    _listModel  =listModel;
    
    __block NSString *methodStr =nil;
    [self.bugCodeList enumerateObjectsUsingBlock:^(IqcTreatmentModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.treatment.length >0) {
            methodStr = obj.treatment;
            YES;
        }
    }];
   

    
    if ([methodStr isEqualToString:@"特采"]) {
        self.passContentLab.text  =@"合格数量:0";
        self.specialContentLab.text =[NSString stringWithFormat:@"特采数量:%@",listModel.TotalCount];
        self.nonConformityContentLab.text  =[NSString stringWithFormat:@"不合格数量:%@",listModel.RejCount];
    }else if ([methodStr isEqualToString:@"退货"]||[methodStr isEqualToString:@"换货"]){
        self.passContentLab.text  =@"合格数量:0";
        self.nonConformityContentLab.text  =[NSString stringWithFormat:@"不合格数量:%@",listModel.TotalCount];
        self.specialContentLab.text  =[NSString stringWithFormat:@"特采数量:%@",listModel.SpecialCount];
    }else if ([methodStr isEqualToString:@"报废"]){
        self.passContentLab.text =@"合格数量:0";
        self.specialContentLab.text  =@"特采数量:0";
        self.nonConformityContentLab.text =[NSString stringWithFormat:@"不合格数量:%@",listModel.TotalCount];
    }
    else{
        self.passContentLab.text =[NSString stringWithFormat:@"合格数量:%@",listModel.PassCount];
        self.specialContentLab.text =[NSString stringWithFormat:@"特采数量:%@",listModel.SpecialCount];
        self.nonConformityContentLab.text  =[NSString stringWithFormat:@"不合格数量:%@",listModel.RejCount];
    }
    self.codeContentLab.text  = [NSString stringWithFormat:@"检验单号:%@",listModel.IQCCode];//检验单号
    self.typeContentLab.text  =[NSString stringWithFormat:@"检查类型:%@",listModel.IqcTaskTypeStr];//检验类型
    self.factoryContentLab.text  =[NSString stringWithFormat:@"所属工厂:%@",listModel.FactoryName];//所属工厂
    self.nameContentLab.text = [NSString stringWithFormat:@"物料名称:%@",listModel.MaterialName];//物料名称
    self.numberContentLab.text  =[NSString stringWithFormat:@"物料编码:%@",listModel.MaterialCode];//物料编码
    self.countContentLab.text = [NSString stringWithFormat:@"检测数量:%@",listModel.TotalCount];//检验数量
   // self.passContentLab.text  =listModel.PassCount;//合格数量
    self.infoContentLab.text  =[NSString stringWithFormat:@"物料规格:%@",listModel.MaterialInfo];//物料规格
   // self.nonConformityContentLab.text =listModel.RejCount;//不合格数量
   // self.specialContentLab.text  =listModel.SpecialCount;//特采数量
  
    [self.expContentLab setTitle:[Units timeWithTime:listModel.ExpDate beforeFormat:@"yyyy-MM-dd HH:mm:ss" andAfterFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];
   // self.expContentLab.text = [NSString stringWithFormat:@"有效期:%@",[Units timeWithTime:listModel.ExpDate beforeFormat:@"yyyy-MM-dd HH:mm:ss" andAfterFormat:@"yyyy-MM-dd"]];//有效期
    self.productContentLab.text =[NSString stringWithFormat:@"生产日期:%@",[Units timeWithTime:listModel.MfgDate beforeFormat:@"yyyy-MM-dd HH:mm:ss" andAfterFormat:@"yyyy-MM-dd"]];//生产日期
    if ([listModel.IqcTaskTypeStr isEqualToString:@"返检IQC"]) {
        self.expContentLab.userInteractionEnabled =YES;
        self.arrowMark.hidden  =NO;
    }
    
}


-(void)setBugCodeList:(NSMutableArray *)bugCodeList{
    _bugCodeList =bugCodeList;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
