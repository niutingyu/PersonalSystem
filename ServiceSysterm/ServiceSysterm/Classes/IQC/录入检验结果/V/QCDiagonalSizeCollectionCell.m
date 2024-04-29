//
//  QCDiagonalSizeCollectionCell.m
//  ServiceSysterm
//
//  Created by Andy on 2021/9/30.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "QCDiagonalSizeCollectionCell.h"
#import "YBPopupMenu.h"

@interface QCDiagonalSizeCollectionCell ()<YBPopupMenuDelegate>

@property (nonatomic,strong)EMCustomKeyboardView *keyboard;

/**
 下拉选择
 */
@property (nonatomic,strong)NSArray *menuList;

/**
 QCSubitMainModel
 */
@property (nonatomic,strong) QCSubmitMainModel *mainModel;

@end
@implementation QCDiagonalSizeCollectionCell


-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}


-(void)setupUI{
    
    _menuList  = @[@"合格",@"不合格"];
    self.contentView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.contentView.layer.borderWidth = 0.5f;
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.contentView.clipsToBounds = YES;
    self.clipsToBounds = YES;
    
    CustomTextField * textField  =[[CustomTextField alloc]init];
    NSAttributedString *attrString  =[[NSAttributedString alloc]initWithString:@"" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    textField.attributedPlaceholder  =attrString;
    
    textField.textAlignment =NSTextAlignmentCenter;
    textField.hidden  =YES;
    self.customTextfield  = textField;
    [self.contentView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
       // make.edges.mas_equalTo(self.contentView);
        make.left.mas_offset(3);
        make.right.mas_offset(-3);
        make.top.mas_offset(3);
        make.bottom.mas_offset(-3);
    }];

    CustomLabel * customLab  =[[CustomLabel alloc]init];
    customLab.font =[UIFont systemFontOfSize:17];
    customLab.numberOfLines  =0;
    customLab.textAlignment  =NSTextAlignmentCenter;
    customLab.text =@"";
    customLab.hidden  =YES;
   
    customLab.backgroundColor  =[UIColor whiteColor];
    self.customLabel  =customLab;
    [self.contentView addSubview:customLab];
    [customLab mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.mas_equalTo(self.contentView);
    }];
}

-(void)setupDiagonalSizeCellWithChartView:(FormChartView*)formChartView rowIdx:(NSInteger)rowIdx sectionIdx:(NSInteger)sectionIdx mainModel:(QCSubmitMainModel*)mainModel{
    self.mainModel  =mainModel;
    QCDetailListModel *detailModel =mainModel.detailList[sectionIdx];
    if (rowIdx ==0) {
        //序号
        self.customLabel.hidden =NO;
        self.customTextfield.hidden  =YES;
        self.customLabel.backgroundColor  =[UIColor whiteColor];
        QCDetailListModel *detailModel =mainModel.detailList[sectionIdx];
        self.customLabel.text =detailModel.SampleId?:@"";
        
    }else if (rowIdx ==1){
        //对角线1
        QCColumnListModel *columnModel  = [mainModel.columnList firstObject];
        if ([mainModel.operationStr isEqualToString:@"录入检验结果"]||[mainModel.operationStr isEqualToString:@"编辑"]) {
            if (mainModel.RelateTaskCode.length ==0) {
                //非物理实验室项目
                
                self.customLabel.hidden =YES;
                self.customTextfield.hidden  =NO;
                self.customTextfield.userInteractionEnabled  =YES;
                self.customTextfield.inputView  =self.keyboard;
                self.keyboard.subView  =formChartView;
                self.keyboard.textf =self.customTextfield;
                NSAttributedString *attuStr  =[[NSAttributedString alloc]initWithString:columnModel.ColumnName attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
                self.customTextfield.attributedPlaceholder  =attuStr;
                self.customTextfield.text =detailModel.Result01;
            }else{
                //物理实验室项目
                self.customLabel.hidden  =NO;
                self.customTextfield.hidden  =YES;
                self.customTextfield.placeholder  =@"";
                self.customLabel.text =detailModel.Result01;
                self.customLabel.backgroundColor  =RGBA(243, 243, 244, 1);
                self.customLabel.shadowColor  =[UIColor lightGrayColor];
            }
            
        }else{
            //查看
            self.customTextfield.hidden  =YES;
            self.customLabel.hidden  =NO;
            self.customLabel.backgroundColor  =[UIColor whiteColor];
            self.customLabel.text =detailModel.Result01;
        }
    }else if (rowIdx ==2){
        //对角线2
        QCColumnListModel *columnModel  = [mainModel.columnList objectAtIndex:1];
        if ([mainModel.operationStr isEqualToString:@"录入检验结果"]||[mainModel.operationStr isEqualToString:@"编辑"]) {
            if (mainModel.RelateTaskCode.length  ==0) {
                self.customLabel.hidden  =YES;
                self.customTextfield.hidden  =NO;
                self.customTextfield.userInteractionEnabled =YES;
                self.customTextfield.inputView  =self.keyboard;
                self.keyboard.subView  =formChartView;
                self.keyboard.textf =self.customTextfield;
                NSAttributedString *attuStr =[[NSAttributedString alloc]initWithString:columnModel.ColumnName attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
                self.customTextfield.attributedPlaceholder  =attuStr;
                self.customTextfield.text =detailModel.Result02;
            }else{
                //物理实验室项目
                self.customLabel.hidden  =NO;
                self.customTextfield.hidden  =YES;
                self.customTextfield.placeholder  =@"";
                self.customLabel.text =detailModel.Result02;
                self.customLabel.backgroundColor  =RGBA(243, 243, 244, 1);
                self.customLabel.shadowColor  =[UIColor lightGrayColor];
            }
        }else{
            //查看
            self.customTextfield.hidden  =YES;
            self.customLabel.hidden  =NO;
            self.customLabel.backgroundColor  =[UIColor whiteColor];
            self.customLabel.text =detailModel.Result02;
        }
    }else if (rowIdx  ==3){
        //偏差
        QCColumnListModel *columnModel  = [mainModel.columnList objectAtIndex:2];
        self.customTextfield.hidden =NO;
        self.customLabel.hidden  =YES;
        self.customTextfield.userInteractionEnabled  =NO;
        
        NSAttributedString *attuStr =[[NSAttributedString alloc]initWithString:columnModel.ColumnName attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
        self.customTextfield.attributedPlaceholder  =attuStr;
        self.customTextfield.text =detailModel.Result03?:columnModel.ColumnName;
        if (mainModel.RelateTaskCode.length >0&&[mainModel.operationStr isEqualToString:@"录入检验结果"]) {
            self.customTextfield.backgroundColor =RGBA(243, 243, 244, 1);
        }else{
            self.customTextfield.backgroundColor =[UIColor whiteColor];
        }
    }else if (rowIdx ==4){
        //单位
        self.customLabel.hidden  =NO;
        if (mainModel.RelateTaskCode.length >0&&[mainModel.operationStr isEqualToString:@"录入检验结果"]) {
            self.customLabel.backgroundColor =RGBA(243, 243, 244, 1);
        }else{
            self.customLabel.backgroundColor =[UIColor whiteColor];
        }
        self.customTextfield.hidden  =YES;
        self.customLabel.text = mainModel.TestUnit?:@"/";
    }else{
        //判定结果
        self.customLabel.hidden  =NO;
        if (mainModel.RelateTaskCode.length >0 &&[mainModel.operationStr isEqualToString:@"录入检验结果"]) {
            self.customLabel.backgroundColor =RGBA(243, 243, 244, 1);
        }else{
            self.customLabel.backgroundColor  =[UIColor whiteColor];
        }
        
        self.customTextfield.hidden =YES;
        self.customLabel.text = detailModel.DecisionResult?:@" ";
        
        self.customLabel.detailModel  =detailModel;
        //一个新需求 ，返回的标准值是空的情况下 判定结果要客户手动选择
        if (mainModel.MinStandard.length ==0 && mainModel.MaxStandard.length ==0&&[mainModel.operationStr isEqualToString:@"录入检验结果"]) {
            self.customLabel.userInteractionEnabled  =YES;
            UITapGestureRecognizer *tap  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMethod:)];
            [self.customLabel addGestureRecognizer:tap];
        }
       
    }
}

-(void)tapMethod:(UITapGestureRecognizer*)tap{
    UILabel *label  = (UILabel*)tap.view;
    [self setupPopMenuWithLabel:label];
}

//下拉选择框
-(void)setupPopMenuWithLabel:(UILabel*)label{
    //下拉选择框
    [YBPopupMenu showRelyOnView:label titles:self.menuList icons:nil menuWidth:100 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.dismissOnSelected = NO;
        popupMenu.isShowShadow = YES;
        popupMenu.delegate = self;
        popupMenu.offset = 10;
        popupMenu.type = YBPopupMenuTypeDark;
        popupMenu.backColor = [UIColor whiteColor];
        popupMenu.textColor = [UIColor blackColor];
        popupMenu.maxVisibleCount =10;
        popupMenu.fontSize =17;
        popupMenu.topLabel = label;
        popupMenu.rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
    }];
}

-(void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu{
    [self endEditing:YES];
    NSString * selectStr  = self.menuList[index];
    self.customLabel.detailModel.DecisionResult  = selectStr;
    ybPopupMenu.topLabel.text  =selectStr;
    //改变主model的判定结果值
    NSMutableString *string =[[NSMutableString alloc]init];
    for (QCDetailListModel *detailModel in self.mainModel.detailList) {
        [string appendString:detailModel.DecisionResult?:@""];
    }
    if ([string containsString:@"不"]) {
       self.mainModel.DecisionResult  =@"0";
    }else{
        self.mainModel.DecisionResult =@"1";
    }
    
    [ybPopupMenu dismiss];
}
-(EMCustomKeyboardView*)keyboard{
    if (!_keyboard) {
        _keyboard =[[EMCustomKeyboardView alloc]init];
    }
    return _keyboard;
}
@end
