//
//  QCTaskListTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2021/7/8.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "QCTaskListTableCell.h"


@interface QCTaskListTableCell ()


/**
 标号
 */
@property (nonatomic,strong)UILabel *numberLab;


/**
 任务单号
 */
@property (nonatomic,strong)UILabel * codeLab;

/**
 紧急通过
 */

@property (nonatomic,strong)UILabel *urgentLab;

/**
 物料编码
 */
@property (nonatomic,strong)UILabel *materialNumberLab;

/**
 物料名称
 */
@property (nonatomic,strong)UILabel *materialNameLab;

/**
 物料规格
 */
@property (nonatomic,strong)UILabel * materialInfoLab;

/**
 供应商代码
 */
@property (nonatomic,strong)UILabel *supBarCodeLab;

/**
 状态
 */
@property (nonatomic,strong)UILabel *statusLab;
/**
 收货数量
 */
@property (nonatomic,strong)UILabel * countLab;

/**
 抽检数量
 */
@property (nonatomic,strong)UILabel * sampleLab;

@property (nonatomic,strong)UIView * bottomeView;

@property (nonatomic,strong)UIView *line0;

@property (nonatomic,strong)UIView *line1;

@property (nonatomic,strong)UIView *line2;

@property (nonatomic,strong)UIView *line3;

@property (nonatomic,strong)UIView *line4;

@property (nonatomic,strong)UIView *line5;

@property (nonatomic,strong)UIView *line6;

@property (nonatomic,strong)UIView *line7;

@property (nonatomic,strong)UIView *line8;

@property (nonatomic,strong)UIView *line9;

@property (nonatomic,strong)UIView *line10;


@end

@implementation QCTaskListTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
      //  self.selectionStyle  =UITableViewCellStyleDefault;
        [self setupUI];
    }
    return self;
}



-(void)setupUI{
    UIView * bottomView  =[[UIView alloc]init];
    //RGBA(148, 179, 219, 1)
    bottomView.backgroundColor  = [UIColor whiteColor];
    self.bottomeView  =bottomView;
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.mas_offset(1);
        make.right.mas_offset(-1);
    }];
    
    UIView * line0 =[[UIView alloc]init];
    line0.backgroundColor  =[UIColor darkGrayColor];
    self.line0  =line0;
    [bottomView addSubview:line0];
    [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(1);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(0.5);
    }];
    CGFloat cellWidth  = (kScreenWidth-36-4-2)/7;
    //标号
    
    UIView * line1  =[[UIView alloc]init];
    line1.backgroundColor = [UIColor darkGrayColor];
    self.line1  =line1;
    [bottomView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(36);
        make.top.bottom.mas_offset(0);
        make.width.mas_offset(0.5);
    }];

    UILabel * numberLab  =[[UILabel alloc]init];
    numberLab.font  =[UIFont systemFontOfSize:15 weight:0.5];
    numberLab.textAlignment  =NSTextAlignmentCenter;
    numberLab.backgroundColor  = RGBA(234, 234, 234, 1);
    self.numberLab  =numberLab;
    [bottomView addSubview:numberLab];
    [numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(2);
        make.top.mas_offset(0);
        make.bottom.mas_offset(0);
        make.right.mas_equalTo(line1.mas_right).mas_offset(-1);

    }];

    
    //任务单号
    UIView * line2  =[[UIView alloc]init];
    line2.backgroundColor  = [UIColor darkGrayColor];
    self.line2  =line2;
    [bottomView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line1.mas_right).mas_offset(cellWidth);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(0.5);
    }];
    UILabel *codeLab  =[[UILabel alloc]init];
    codeLab.font  =[UIFont systemFontOfSize:15];
    codeLab.textAlignment  =NSTextAlignmentCenter;
    codeLab.numberOfLines  =0;
    codeLab.text =@"任务单号";
    self.codeLab  =codeLab;
    [bottomView addSubview:codeLab];
    [codeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line1.mas_right).mas_offset(4);
        make.top.mas_offset(8);
        make.bottom.mas_offset(-8);
        make.right.mas_equalTo(line2.mas_left).mas_offset(-4);
    }];
    
    //紧急通过
    UIView * line3 =[[UIView alloc]init];
    line3.backgroundColor = [UIColor darkGrayColor];
    self.line3  =line3;
    [bottomView addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line2.mas_right).mas_offset(cellWidth*0.5);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(0.5);

    }];
    
    UILabel * urgentLab  =[[UILabel alloc]init];
    urgentLab.textAlignment  =NSTextAlignmentCenter;
    urgentLab.font =[UIFont systemFontOfSize:15];
    urgentLab.numberOfLines  =0;
    urgentLab.text =@"紧急通过";
    self.urgentLab  =urgentLab;
    [bottomView addSubview:urgentLab];
    [urgentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line2.mas_right).mas_offset(4);
        make.top.mas_offset(8);
        make.bottom.mas_offset(-8);
        make.right.mas_equalTo(line3.mas_left).mas_offset(-4);
    }];
    
    //物料编码
    UIView * line4  =[[UIView alloc]init];
    line4.backgroundColor =[UIColor darkGrayColor];
    self.line4  =line4;
    [bottomView addSubview:line4];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line3.mas_right).mas_offset(cellWidth);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(0.5);

    }];
    UILabel * materialNumberLab  =[[UILabel alloc]init];
    materialNumberLab.font =[UIFont systemFontOfSize:15];
    materialNumberLab.textAlignment =NSTextAlignmentCenter;
    materialNumberLab.numberOfLines  =0;
    materialNumberLab.text =@"物料编码";
    self.materialNumberLab  =materialNumberLab;
    [bottomView addSubview:materialNumberLab];
    [materialNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line3.mas_right).mas_offset(4);
        make.right.mas_equalTo(line4.mas_left).mas_offset(-4);
        make.top.mas_offset(8);
        make.bottom.mas_offset(-8);
    }];
    
    //物料名称
    UIView * line5  =[[UIView alloc]init];
    line5.backgroundColor =[UIColor darkGrayColor];
    self.line5  =line5;
    [bottomView addSubview:line5];
    [line5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line4.mas_right).mas_offset(cellWidth*0.5);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(0.5);
    }];
    UILabel * materialNameLab  =[[UILabel alloc]init];
    materialNameLab.font  =[UIFont systemFontOfSize:15];
    materialNameLab.textAlignment  =NSTextAlignmentCenter;
    materialNameLab.numberOfLines  =0;
    materialNameLab.text =@"物料名称";
    self.materialNameLab  =materialNameLab;
    [bottomView addSubview:materialNameLab];
    [materialNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line4.mas_right).mas_offset(4);
        make.top.mas_offset(8);
        make.bottom.mas_offset(-8);
        make.right.mas_equalTo(line5.mas_left).mas_offset(-4);
    }];
    //物料规格
    UIView * line6  =[[UIView alloc]init];
    line6.backgroundColor  =[UIColor darkGrayColor];
    self.line6  =line6;
    [bottomView addSubview:line6];
    [line6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line5.mas_right).mas_offset(cellWidth*1.5);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(0.5);

    }];
    
    UILabel * materialInfoLab  =[[UILabel alloc]init];
    materialInfoLab.textAlignment = NSTextAlignmentCenter;
    materialInfoLab.font  =[UIFont systemFontOfSize:15];
    materialInfoLab.numberOfLines  =0;
    materialInfoLab.text =@"物料规格";
    self.materialInfoLab  =materialInfoLab;
    [bottomView addSubview:materialInfoLab];
    [materialInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line5.mas_right).mas_offset(4);
        make.top.mas_offset(8);
        make.bottom.mas_offset(-8);
        make.right.mas_equalTo(line6.mas_left).mas_offset(-4);
    }];
    
    //供应商代码
    UIView * line7  =[[UIView alloc]init];
    line7.backgroundColor  =[UIColor darkGrayColor];
    self.line7  =line7;
    [bottomView addSubview:line7];
    [line7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line6.mas_right).mas_offset(cellWidth*0.7);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(0.5);
    }];
    UILabel * supBarCodeLab  =[[UILabel alloc]init];
    supBarCodeLab.textAlignment = NSTextAlignmentCenter;
    supBarCodeLab.font =[UIFont systemFontOfSize:15];
    supBarCodeLab.numberOfLines  =0;
    supBarCodeLab.text  =@"供应商批号";
    self.supBarCodeLab  =supBarCodeLab;
    [bottomView addSubview:supBarCodeLab];
    [supBarCodeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line6.mas_right).mas_offset(4);
        make.top.mas_offset(8);
        make.bottom.mas_offset(-8);
        make.right.mas_equalTo(line7.mas_left).mas_offset(-4);
    }];
    
    //状态
    
    UIView *line10 =[[UIView alloc]init];
    line10.backgroundColor  =[UIColor darkGrayColor];
    self.line10  =line10;
    [bottomView addSubview:line10];
    [line10 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line7.mas_right).mas_offset(cellWidth*0.5+cellWidth*0.3);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(0.5);
    }];
    
    UILabel * statusLab  =[[UILabel alloc]init];
    statusLab.textAlignment  =NSTextAlignmentCenter;
    statusLab.font =[UIFont systemFontOfSize:15];
    statusLab.numberOfLines =0;
    statusLab.text  =@"状态";
    self.statusLab = statusLab;
    [bottomView addSubview:statusLab];
    [statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line7.mas_right).mas_offset(4);
        make.top.mas_offset(8);
        make.bottom.mas_offset(-8);
        make.right.mas_equalTo(line10.mas_left).mas_offset(-4);
    }];
    
    //收货数量
    UIView * line8 =[[UIView alloc]init];
    line8.backgroundColor  =[UIColor darkGrayColor];
    self.line8  =line8;
    [bottomView addSubview:line8];
    [line8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line10.mas_right).mas_offset(cellWidth*0.5);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(0.5);
    }];
    
    UILabel * countLab =[[UILabel alloc]init];
    countLab.textAlignment =NSTextAlignmentCenter;
    countLab.font  =[UIFont systemFontOfSize:15];
    countLab.numberOfLines =0;
    countLab.text =@"收货数量";
    self.countLab  =countLab;
    [bottomView addSubview:countLab];
    [countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line10.mas_right).mas_offset(4);
        make.top.mas_offset(8);
        make.bottom.mas_offset(-8);
        make.right.mas_equalTo(line8.mas_left).mas_offset(-4);
    }];
    
    //抽检数量
    UIView * line9 =[[UIView alloc]init];
    line9.backgroundColor  =[UIColor darkGrayColor];
    self.line9  =line9;
    [bottomView addSubview:line9];
    [line9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-1);
        make.top.mas_offset(0);
        make.bottom.mas_offset(0);
        make.width.mas_equalTo(0.5);
    }];
    
    UILabel * sampleLab  =[[UILabel alloc]init];
    sampleLab.textAlignment =NSTextAlignmentCenter;
    sampleLab.font  =[UIFont systemFontOfSize:15];
    sampleLab.numberOfLines  =0;
    sampleLab.text =@"抽检数量";
    self.sampleLab  =sampleLab;
    [bottomView addSubview:sampleLab];
    [sampleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line8.mas_right).mas_offset(4);
        make.top.mas_offset(8);
        make.bottom.mas_offset(-8);
        make.right.mas_equalTo(line9.mas_left).mas_offset(-4);
    }];
    
    UIView * bottomLine  =[[UIView alloc]init];
    bottomLine.backgroundColor  =[UIColor darkGrayColor];
    [bottomView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(2);
        make.right.mas_offset(-2);
        make.bottom.mas_offset(0);
        make.height.mas_equalTo(0.5);
    }];
}

-(void)setupQCTaskListCellWithModel:(IQCListModel*)model number:(NSString*)number{
    self.numberLab.text  =number;
    self.codeLab.text  =model.IQCCode;
    self.urgentLab.text  =model.IsUrgentPassStr;
    self.materialNumberLab.text =model.MaterialCode;
    self.materialNameLab.text =model.MaterialName;
    self.materialInfoLab.text  =model.MaterialInfo;
    self.supBarCodeLab.text =model.SupBarcode;
    self.statusLab.text  =model.statusStr;
    self.countLab.text  =[NSString stringWithFormat:@"%@\n(%@)",model.TotalCount,model.UnitName];
    self.sampleLab.text =model.SampleCount;
}

-(void)configureCellWithIsSelected:(BOOL)IsSelected{
    if (IsSelected  == true) {
        self.bottomeView.backgroundColor  = RGBA(148, 179, 219, 1);
    }else{
        self.bottomeView.backgroundColor  =[UIColor whiteColor];
    }
}
@end
