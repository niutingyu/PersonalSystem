//
//  QCMainHeadTableView.m
//  ServiceSysterm
//
//  Created by Andy on 2021/7/6.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "QCMainHeadTableView.h"
#import "UIImage+ChangeColor.h"
#import "IqcDateChosController.h"
@interface QCMainHeadTableView ()<UITextFieldDelegate,SLDropdownMenuDelegate,SLDropdownMenuDataSource,UIPopoverPresentationControllerDelegate>

/**
 编码
 */
@property (nonatomic,copy)NSString * numberString;

/**
 名称
 */
@property (nonatomic,copy)NSString * nameString;

/**
 规格
 */

@property (nonatomic,copy)NSString * infoString;

/**
 物料编码
 */
@property (nonatomic,strong)UITextField * numberTextfield;

/**
 物料名称
 */
@property (nonatomic,strong)UITextField * nameTextfield;

/**
 物料规格
 */
@property (nonatomic,strong)UITextField * infoTextfield;

/**
 DropDownMenuView
 */

@property (nonatomic,strong)NSMutableArray * dropMenuList;

@property (nonatomic,strong)UIButton *beginBut;



@end

//定义状态常量
NSString * const KCancelStatus =@"作废";
NSString * const KWaitingCheckStaus =@"待检测";
NSString * const KWaitingAuditStatus =@"待审核";
NSString * const KWaitingStockInStaus =@"待入库";
NSString * const KAllNoPassStatus =@"全未通过";
NSString * const KPartNoPassStatus =@"部分通过";
NSString * const KAllPassStatus =@"全部通过";

@implementation QCMainHeadTableView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self  =[super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}


-(void)setupUI{
    UIView *bottomView  =[[UIView alloc]init];
    bottomView.backgroundColor  = RGBA(255, 250, 250, 1);
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.top.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    
    CGFloat widthLab  = 70;
    CGFloat cellWidth = (kScreenWidth-70-70-70-5-5-5-16-16-80-16-16-16)/3;
    //物料编码

    
    UITextField * numberTextfield  =[[UITextField alloc]init];
    numberTextfield.placeholder  =@"";
    numberTextfield.borderStyle  = UITextBorderStyleRoundedRect;
    numberTextfield.font =[UIFont systemFontOfSize:15];
    numberTextfield.delegate  =self;
    numberTextfield.tag =100;
    self.numberTextfield  = numberTextfield;
    
    [bottomView addSubview:numberTextfield];
    [numberTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(widthLab+16+5);
        make.top.mas_offset(8);
        make.width.mas_equalTo(cellWidth);
        make.height.mas_equalTo(40);
    }];
    
    UILabel * materialLab =[[UILabel alloc]init];
    materialLab.font  =[UIFont systemFontOfSize:15];
    materialLab.text =@"物料编码:";
    [bottomView addSubview:materialLab];
    [materialLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(16);
        make.centerY.mas_equalTo(numberTextfield);
        make.width.mas_equalTo(widthLab);
        make.height.mas_equalTo(21);
    }];
    
    //物料名称
    UILabel * nameLab  =[[UILabel alloc]init];
    nameLab.text =@"物料名称:";
    nameLab.font =[UIFont systemFontOfSize:15];
    [bottomView addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(numberTextfield.mas_right).mas_offset(16);
        make.top.mas_equalTo(materialLab);
        make.width.mas_equalTo(widthLab);
        make.height.mas_equalTo(21);
        
    }];
    
    UITextField * nameTextfield  =[[UITextField alloc]init];
    nameTextfield.placeholder =@"";
    nameTextfield.font  =[UIFont systemFontOfSize:14];
    nameTextfield.borderStyle  =UITextBorderStyleRoundedRect;
    nameTextfield.delegate =self;
    nameTextfield.tag =101;
    self.nameTextfield  = nameTextfield;
    
    [bottomView addSubview:nameTextfield];
    [nameTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLab.mas_right).mas_offset(5);
        make.top.mas_offset(8);
        make.width.mas_equalTo(cellWidth);
        make.height.mas_equalTo(40);
        
    }];
    
    //物料规格
    UILabel * typeLab  =[[UILabel alloc]init];
    typeLab.font =[UIFont systemFontOfSize:15];
    typeLab.text  =@"物料规格:";
    [bottomView addSubview:typeLab];
    [typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameTextfield.mas_right).mas_offset(16);
        make.top.mas_equalTo(materialLab);
        make.width.mas_equalTo(widthLab);
        make.height.mas_equalTo(21);
    }];
    
    UITextField * typeTextfield  =[[UITextField alloc]init];
    typeTextfield.font  =[UIFont systemFontOfSize:15];
    typeTextfield.placeholder  =@"";
    typeTextfield.borderStyle =UITextBorderStyleRoundedRect;
    typeTextfield.delegate =self;
    typeTextfield.tag  =102;
    self.infoTextfield  = typeTextfield;
    
    [bottomView addSubview:typeTextfield];
    [typeTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(typeLab.mas_right).mas_offset(5);
        make.top.mas_offset(8);
        make.width.mas_equalTo(cellWidth);
        make.height.mas_equalTo(40);
    }];
    
    UIButton * searchBut  =[UIButton buttonWithType:UIButtonTypeCustom];
    [searchBut setTitle:@"查询" forState:UIControlStateNormal];
    searchBut.titleLabel.font =[UIFont systemFontOfSize:15];
    searchBut.backgroundColor  =[UIColor whiteColor];
    searchBut.layer.cornerRadius  = 3;
    searchBut.clipsToBounds  = YES;
    searchBut.tag  = 999;
    [searchBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [searchBut addTarget:self action:@selector(butMethod:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:searchBut];
    [searchBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-16);
        make.top.mas_offset(8);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
    
    //选择条
    NSArray * titles  = @[@"待检验",@"已检验",@"已完成"];
    UISegmentedControl * segmentControl =[[UISegmentedControl alloc]initWithItems:titles];
    segmentControl.selectedSegmentIndex =0;
    segmentControl.layer.borderColor  =[UIColor darkGrayColor].CGColor;
    segmentControl.layer.borderWidth  =0.5;
    

    [segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateSelected];
    [segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
   
    [segmentControl setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [segmentControl setBackgroundImage:[self imageWithColor:RGBA(0, 143, 182, 1)] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [segmentControl addTarget:self action:@selector(chosItem:) forControlEvents:UIControlEventValueChanged];
    [bottomView addSubview:segmentControl];
    [segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(numberTextfield.mas_bottom).mas_offset(14);
        make.left.mas_offset(12);
        make.width.mas_equalTo(cellWidth+cellWidth+10);
        make.height.mas_equalTo(45);
    }];
    
    //重置
    UIButton * resetBut =[UIButton buttonWithType:UIButtonTypeCustom];
    [resetBut setTitle:@"重置" forState:UIControlStateNormal];
    [resetBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    resetBut.backgroundColor  =[UIColor whiteColor];
    resetBut.titleLabel.font  =[UIFont systemFontOfSize:15];
    resetBut.layer.cornerRadius  =3;
    resetBut.clipsToBounds  =YES;
    resetBut.tag =1000;
    [resetBut addTarget:self action:@selector(butMethod:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:resetBut];
    [resetBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-16);
        make.top.mas_equalTo(searchBut.mas_bottom).mas_offset(14);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
    
    //状态
    DropDownMenuView *menuView  =[[DropDownMenuView alloc]init];
    menuView.backgroundColor  = [UIColor whiteColor];
    
    menuView.delegate =self;
    menuView.dataSource  =self;
    menuView.layer.borderColor  =[UIColor lightGrayColor].CGColor;
    menuView.layer.borderWidth  =0.5;
    menuView.layer.cornerRadius  =3;
    menuView.clipsToBounds  =YES;
    menuView.titleAlignment  =NSTextAlignmentLeft;
    menuView.titleFont  =[UIFont systemFontOfSize:17];
    menuView.rotateIcon  =[UIImage imageNamed:@"iosarrowup"];
    menuView.title =@"状态";
    menuView.rotateIconSize  =CGSizeMake(20, 20);
    menuView.titleColor  =[UIColor darkGrayColor];
    menuView.optionFont =[UIFont systemFontOfSize:16];
    menuView.optionTextColor  =[UIColor blackColor];
    menuView.optionLineColor  =[UIColor lightGrayColor];
    menuView.optionBgColor =RGBA(234, 243, 250, 1);
    self.menuView =menuView;
    [bottomView addSubview:menuView];
    [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(typeTextfield);
        make.top.mas_equalTo(typeTextfield.mas_bottom).mas_offset(14);
        make.width.mas_equalTo(cellWidth);
        make.height.mas_equalTo(40);
    }];
    
//日期
    
    UIButton * beginBut =[UIButton buttonWithType:UIButtonTypeCustom];
    beginBut.titleLabel.font  =[UIFont systemFontOfSize:15];
    beginBut.backgroundColor  =[UIColor whiteColor];
    [beginBut setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [beginBut setTitle:@"请选择日期" forState:UIControlStateNormal];
    beginBut.layer.borderWidth  =0.5;
    beginBut.layer.borderColor  =[UIColor lightGrayColor].CGColor;
    beginBut.layer.cornerRadius  =5;
    beginBut.clipsToBounds  =YES;
    self.beginBut  = beginBut;
    
   // expContentBut.backgroundColor  =labColor;
    beginBut.titleEdgeInsets  =UIEdgeInsetsMake(0, 10, 0, 0);
    [beginBut addTarget:self action:@selector(beginMethod:) forControlEvents:UIControlEventTouchUpInside];
    beginBut.hidden =YES;
    
    [bottomView addSubview:beginBut];
    [beginBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(segmentControl.mas_right).mas_offset(16);
        make.top.mas_equalTo(typeTextfield.mas_bottom).mas_offset(14);
        make.width.mas_equalTo(cellWidth+widthLab+10);
        make.height.mas_equalTo(45);

    }];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getDate:) name:@"chosDate" object:nil];
    
   

}

-(void)getDate:(NSNotification*)notification{
    NSDictionary *dic =[notification object];
    
    [[Units viewController:self] dismissViewControllerAnimated:YES completion:nil];
    [self.beginBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.beginBut setTitle:[NSString stringWithFormat:@"%@至%@",[Units timeWithTime:dic[@"begin"] beforeFormat:@"yyyy-MM-dd" andAfterFormat:@"yyyy-MM-dd"],[Units timeWithTime:dic[@"end"] beforeFormat:@"yyyy-MM-dd" andAfterFormat:@"yyyy-MM-dd"]] forState:UIControlStateNormal];
    if (self.dateFilterBlock) {
        self.dateFilterBlock(dic[@"begin"], dic[@"end"]);
    }
    
    
}

//选择日期
-(void)beginMethod:(UIButton*)sender{
    IqcDateChosController * controller  =[[IqcDateChosController alloc]init];
    controller.preferredContentSize =CGSizeMake(670, 440);
    controller.modalPresentationStyle  =UIModalPresentationPopover;
    controller.popoverPresentationController.delegate =self;
    controller.popoverPresentationController.sourceView  = sender;
    controller.popoverPresentationController.sourceRect =CGRectMake(0, sender.frame.size.height*0.5, sender.frame.size.width/2, sender.frame.size.height/2);
    controller.popoverPresentationController.permittedArrowDirections =UIPopoverArrowDirectionUp;
    [[Units viewController:self] presentViewController:controller animated:YES completion:^{
            
    }];
}

/////////////////////////////////////////////////////////////////////////
//DropDownMenuView
-(NSUInteger)numberOfOptionsInDropdownMenu:(DropDownMenuView *)menu{
   
    return self.dropMenuList.count;
}

-(CGFloat)dropdownMenu:(DropDownMenuView *)menu heightForOptionAtIndex:(NSUInteger)index{
    return 48;
}

-(NSString*)dropdownMenu:(DropDownMenuView *)menu titleForOptionAtIndex:(NSUInteger)index{

    NSDictionary * dict  = self.dropMenuList[index];
    return [dict objectForKey:@"name"];
}

-(void)dropdownMenu:(DropDownMenuView *)menu didSelectOptionAtIndex:(NSUInteger)index optionTitle:(NSString *)title{
    NSDictionary *dict  = self.dropMenuList[index];
    NSInteger selectId  = [[dict objectForKey:@"Id"] intValue];
    
    if (self.menuViewBlock) {
        self.menuViewBlock(selectId);
    }
}

/**
 TextFieldDelegate
 */




-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
 
    if (textField.tag  == 100) {
        //编码
        self.numberString  = textField.text;
        
    }else if (textField.tag  ==101){
        self.nameString  = textField.text;
    }else{
        self.infoString  = textField.text;
    }
    

    
    return YES;
}
-(void)chosItem:(UISegmentedControl*)segment{
    if (segment.selectedSegmentIndex ==2) {
        //已完成
        self.beginBut.hidden  =NO;
    }else{
        self.beginBut.hidden =YES;
    }
    if (self.segmentBlock) {
        self.segmentBlock(segment.selectedSegmentIndex, self.menuView);
    }
}

-(void)butMethod:(UIButton*)sender{
    [self endEditing:YES];
    if (sender.tag  ==1000) {
        self.numberTextfield.text  =@"";
        self.nameTextfield.text  =@"";
        self.infoTextfield.text  =@"";
        self.numberString =@"";
        self.nameString  =@"";
        self.infoString  =@"";
        self.menuView.title =@"状态";
        [self.beginBut setTitle:@"请选择日期" forState:UIControlStateNormal];
    }
    if (self.butBlock) {
        self.butBlock(sender.tag, self.numberString, self.nameString, self.infoString);
    }
    
}

-(NSMutableArray*)dropMenuList{
    if (!_dropMenuList) {
        _dropMenuList  =[NSMutableArray array];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"IQCStatusModel.json" ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSError *error;
        NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (!error) {
            [_dropMenuList addObjectsFromArray:dataArray];
        }
       
    }
    return _dropMenuList;
}
- (UIImage *)imageWithColor: (UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
@end
