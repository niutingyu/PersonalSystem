//
//  IQCBugListTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2021/7/10.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "IQCBugListTableCell.h"
#import "YBPopupMenu.h"


@interface IQCBugListTableCell ()<YBPopupMenuDelegate>

/**
 标号
 */
@property (nonatomic,strong)UILabel * numberLab;

/**
 处理方式
 */
@property (nonatomic,strong)UIButton * methodBut;


/**
 数量
 */

@property (nonatomic,strong)UILabel * countLab;

/**
 缺陷代码
 */

@property (nonatomic,strong)UILabel * bugCodeLab;

/**
 缺陷名称
 
 */

@property (nonatomic,strong)UILabel * bugNameLab;

@property (nonatomic,copy)NSString * methodStr;

@property (nonatomic,strong)NSMutableArray *treatmentMethodList;



@end
@implementation IQCBugListTableCell

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
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    UIView * bottomView  =[[UIView alloc]init];
    bottomView.backgroundColor  = [UIColor whiteColor];
    [self.contentView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.mas_offset(1);
        make.right.mas_offset(-1);
    }];
    
    UIView * line0 =[[UIView alloc]init];
    line0.backgroundColor  =[UIColor darkGrayColor];
    [bottomView addSubview:line0];
    [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(0.5);
    }];
    
    CGFloat cellWidth  = (kScreenWidth-36-2)/4;
    //标号
    
    UIView * line1  =[[UIView alloc]init];
    line1.backgroundColor  = [UIColor darkGrayColor];
    [bottomView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(36);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(0.5);
    }];
    
    
    UILabel * numberLab =[[UILabel alloc]init];
    numberLab.backgroundColor  =RGBA(234, 234, 234, 1);
    numberLab.font  =[UIFont systemFontOfSize:16 weight:0.5];
    numberLab.textAlignment  =NSTextAlignmentCenter;
    self.numberLab  =numberLab;
    [bottomView addSubview:numberLab];
    [numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(2);
        make.top.mas_offset(0);
        make.bottom.mas_offset(0);
        make.right.mas_equalTo(line1.mas_left).mas_offset(0);
    }];
    
    //处理方式
    UIView * line2  =[[UIView alloc]init];
    line2.backgroundColor  =[UIColor darkGrayColor];
    [bottomView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line1.mas_right).mas_offset(cellWidth);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(0.5);
    }];
    UIButton * methodBut  =[UIButton buttonWithType:UIButtonTypeCustom];
    methodBut.titleLabel.font  =[UIFont systemFontOfSize:15];
    [methodBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [methodBut addTarget:self action:@selector(butMethod:) forControlEvents:UIControlEventTouchUpInside];
    self.methodBut  =methodBut;
    [bottomView addSubview:methodBut];
    [methodBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line1.mas_right).mas_offset(2);
        make.top.mas_offset(8);
        make.bottom.mas_offset(-8);
        make.right.mas_equalTo(line2.mas_left).mas_offset(-2);
    }];
   
//    UILabel * methodLab  =[[UILabel alloc]init];
//    methodLab.font  =[UIFont systemFontOfSize:15];
//    methodLab.text =@"处理方式";
//    methodLab.textAlignment  =NSTextAlignmentCenter;
//    self.methodLab  =methodLab;
//    [bottomView addSubview:methodLab];
//    [methodLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(line1.mas_right).mas_offset(2);
//        make.top.mas_offset(8);
//        make.bottom.mas_offset(-8);
//        make.right.mas_equalTo(line2.mas_left).mas_offset(-2);
//    }];
//
    //数量
    UIView * line3  =[[UIView alloc]init];
    line3.backgroundColor  =[UIColor darkGrayColor];
    [bottomView addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line2.mas_right).mas_offset(cellWidth);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(0.5);
    }];
    
    UITextField * countTextf  =[[UITextField alloc]init];
    countTextf.placeholder =@"数量";
    
   // countLab.text  =@"数量";
    countTextf.textAlignment  =NSTextAlignmentCenter;
    countTextf.font  =[UIFont systemFontOfSize:15];
   // self.countLab =countLab;
    self.countTextf  =countTextf;
    [bottomView addSubview:countTextf];
    [countTextf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line2.mas_right).mas_offset(2);
        make.top.mas_offset(8);
        make.bottom.mas_offset(-8);
        make.right.mas_equalTo(line3.mas_left).mas_offset(-2);
    }];
    
    //缺陷代码
    UIView * line4  =[[UIView alloc]init];
    line4.backgroundColor =[UIColor darkGrayColor];
    [bottomView addSubview:line4];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line3.mas_right).mas_offset(cellWidth);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(0.5);
    }];
    UILabel * bugCodeLab  =[[UILabel alloc]init];
    bugCodeLab.text =@"缺陷代码";
    bugCodeLab.font  =[UIFont systemFontOfSize:15];
    bugCodeLab.textAlignment =NSTextAlignmentCenter;
    self.bugCodeLab  =bugCodeLab;
    [bottomView addSubview:bugCodeLab];
    [bugCodeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line3.mas_right).mas_offset(2);
        make.top.mas_offset(8);
        make.bottom.mas_offset(-8);
        make.right.mas_equalTo(line4.mas_left).mas_offset(-2);
    }];
    
    //缺陷名称
    UIView * line5  =[[UIView alloc]init];
    line5.backgroundColor =[UIColor darkGrayColor];
    [bottomView addSubview:line5];
    [line5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-1);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(0.5);
    }];
    
    UILabel * bugNameLab  =[[UILabel alloc]init];
    bugNameLab.text  =@"缺陷名称";
    bugNameLab.font  =[UIFont systemFontOfSize:15];
    bugNameLab.textAlignment  =NSTextAlignmentCenter;
    bugNameLab.numberOfLines =0;
    self.bugNameLab  =bugNameLab;
    [bottomView addSubview:bugNameLab];
    [bugNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line4.mas_right).mas_offset(2);
        make.top.mas_offset(8);
        make.bottom.mas_offset(-8);
        make.right.mas_equalTo(line5.mas_left).mas_offset(-2);
    }];
    UIView * verticalLine  =[[UIView alloc]init];
    verticalLine.backgroundColor  =[UIColor darkGrayColor];
    [bottomView addSubview:verticalLine];
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(1);
        make.right.mas_offset(-1);
        make.bottom.mas_offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
}


-(void)configBugTableViewWithModel:(IqcTreatmentModel*)model number:(NSString*)number {
    self.numberLab .text  = number;
    self.bugCodeLab.text  = model.bugCode;
    self.bugNameLab.text  = model.bugName;
    self.methodBut.tag  = [number intValue]-1;
    //避免在滑动的时候cell 复用 数据错乱
    [self.methodBut setTitle:model.treatment forState:UIControlStateNormal];
    
   // self.rowIdx  =[number intValue]-1;
    
    
}

-(void)butMethod:(UIButton*)sender{
//    if (self.rowIdx ==0) {
//
//        if (self.treatmentMethodList.count  ==0) {
//            [Units showErrorStatusWithString:@"没有更多的处理方式"];
//            return;
//        }
        CGFloat cellWidth  = (kScreenWidth-36-2)/4;
        [YBPopupMenu showRelyOnView:sender titles:self.treatmentMethodList icons:nil menuWidth:cellWidth*0.5 otherSettings:^(YBPopupMenu *popupMenu) {
            popupMenu.dismissOnSelected = NO;
            popupMenu.isShowShadow = YES;
            popupMenu.delegate = self;
            popupMenu.offset = 10;
            popupMenu.type = YBPopupMenuTypeDark;
            popupMenu.backColor = [UIColor whiteColor];
            popupMenu.textColor = [UIColor blackColor];
            popupMenu.maxVisibleCount =10;
            
            
            popupMenu.rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
        }];
//    }

}

-(void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu{
   // NSArray * titles =@[@"报废",@"退货",@"特采",@"换货"];
  
    NSArray * Ids ;
    if ([self.listModel.IqcTaskTypeStr isEqualToString:@"收货IQC"]) {
        Ids =@[@"2",@"4",@"3"];
    }else if ([self.listModel.IqcTaskTypeStr isEqualToString:@"返检IQC"]){
        Ids =@[@"1"];
    }
 //   NSString *treatMentStr  =self.treatmentMethodList[index];
    
//    for (IqcTreatmentModel *treatmentModel in self.treatMentList) {
//        if (![treatMentStr isEqualToString:treatmentModel.treatment]&&treatmentModel.treatment.length >0) {
//            [Units showErrorStatusWithString:[NSString stringWithFormat:@"请选择%@处理方式",treatmentModel.treatment]];
//            return;
//        }
//    }
 
    self.methodStr  = self.treatmentMethodList[index];
    [self.methodBut setTitle:self.methodStr forState:UIControlStateNormal];
//    self.treatmentModel.treatment  =self.methodStr;
//    self.treatmentModel.treatmentIdStr  =Ids[index];
   // IqcBugModel * model  = self.IqcBugList[self.methodBut.tag];
   
    
    if (self.methodBlcok) {
        self.methodBlcok(self.methodStr,Ids[index]);
    }
    [ybPopupMenu dismiss];
    
//    for (IqcBugModel *bugModel in self.IqcBugList) {
//        bugModel.methodStr  =self.methodStr;
//        bugModel.methodIdStr  = Ids[index];
//    }
}

-(void)setListModel:(IQCListModel *)listModel{
    _listModel  =listModel;
    [self.treatmentMethodList removeAllObjects];
    if ([listModel.IqcTaskTypeStr isEqualToString:@"收货IQC"]) {
        NSArray *titles  =@[@"退货",@"换货",@"特采"];
        
        [self.treatmentMethodList addObjectsFromArray:titles];
    }else if ([listModel.IqcTaskTypeStr isEqualToString:@"返检IQC"]){
        NSArray *titles  =@[@"报废"];
        [self.treatmentMethodList addObjectsFromArray:titles];
    }
    
   // self.countLab.text  = listModel.TotalCount;
    
}



-(void)setTreatmentModel:(IqcTreatmentModel *)treatmentModel{
    _treatmentModel  =treatmentModel;
    self.countTextf.text  =treatmentModel.count?:@"";
}

-(void)setTreatMentList:(NSMutableArray *)treatMentList{
    _treatMentList  =treatMentList;
}
-(NSMutableArray*)treatmentMethodList{
    if (!_treatmentMethodList) {
        _treatmentMethodList  =[NSMutableArray array];
    }return _treatmentMethodList;
}
-(void)setFrame:(CGRect)frame{
    frame.origin.x +=2;
    frame.size.width  -=4;
    [super setFrame:frame];
}
@end
