//
//  QCSIzeCollectionCell.m
//  ServiceSysterm
//
//  Created by Andy on 2021/6/5.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "QCSIzeCollectionCell.h"
#import "UITextView+Placeholder.h"
#import "EMCustomKeyboardView.h"
#import "YBPopupMenu.h"
@interface QCSIzeCollectionCell ()<YBPopupMenuDelegate>

@property (nonatomic,strong)CustomLabel *customLab;

/**
 下拉选择
 */
@property (nonatomic,strong)NSArray *menuList;

/**
 QCSubmitMainModel
 */
@property (nonatomic,strong)QCSubmitMainModel *mainModel;

@end
@implementation QCSIzeCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self  =[super initWithFrame:frame]) {
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

    self.textfield  = textField;
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
    self.customLab  =customLab;
    [self.contentView addSubview:customLab];
    [customLab mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.mas_equalTo(self.contentView);
    }];
  
}



-(void)setText:(NSString *)text{
    _text =text;
    
    self.textfield.text  = text;
}

-(void)setHoldString:(NSString *)holdString{
    _holdString  =holdString;
    self.textfield.placeholder =holdString;
}

-(void)setTextColor:(UIColor *)textColor{
    _textColor  =textColor;
    self.textfield.textColor  =textColor?:[UIColor blackColor];
}

-(void)setIsEdit:(BOOL)isEdit{
    _isEdit  =isEdit;
    self.textfield.userInteractionEnabled  = isEdit;
 
   
}

-(void)setLabelText:(NSString *)labelText{
    _labelText =labelText;
    self.customLab.text  =labelText;
   
}
-(void)setIsTextHidden:(BOOL)isTextHidden{
    _isTextHidden  = isTextHidden;
    self.textfield.hidden =isTextHidden;
}

-(void)setIsLabHidden:(BOOL)isLabHidden{
    _isLabHidden  =isLabHidden;
    self.customLab.hidden  =isLabHidden;
}
-(void)setupCellWithchartView:(FormChartView*)chartView rowIdx:(NSInteger)idx sectionIdx:(NSInteger)sectionIdx mainModel:(QCSubmitMainModel*)mainModel{
    self.mainModel  =mainModel;
    QCDetailListModel *detailModel = mainModel.detailList[sectionIdx];
    if (idx ==0) {
        //序号
        self.customLab.hidden =NO;
        self.textfield.hidden =YES;
        self.customLab.backgroundColor  =[UIColor whiteColor];
        self.customLab.text  = detailModel.SampleId?:@"";
    }else if (idx ==mainModel.columnList.count-1+3-2){
        //单位
        self.customLab.hidden =NO;
        self.textfield.hidden  =YES;
        if (mainModel.RelateTaskCode.length ==0) {
          
            self.customLab.backgroundColor  =[UIColor whiteColor];
        }else{
            if (![mainModel.operationStr isEqualToString:@"录入检验结果"]) {
                self.customLab.backgroundColor  =[UIColor whiteColor];
                self.customLab.shadowColor =[UIColor whiteColor];
            }else{
                self.customLab.backgroundColor =RGBA(243, 243, 244, 1);
                self.customLab.shadowColor =[UIColor lightGrayColor];
            }
        }
      //  self.customLab.backgroundColor  =[UIColor whiteColor];
        if (mainModel.TestUnit.length ==0) {
            self.customLab.text =@"/";
        }else{
            self.customLab.text =mainModel.TestUnit;
        }
    }else if (idx ==mainModel.columnList.count-1+3-1){
        //判定结果
        self.customLab.hidden =NO;
        self.textfield.hidden =YES;
       
        if (mainModel.RelateTaskCode.length ==0) {
            self.customLab.backgroundColor  =[UIColor whiteColor];
        }else{
            if (![mainModel.operationStr isEqualToString:@"录入检验结果"]) {
                self.customLab.backgroundColor  =[UIColor whiteColor];
                self.customLab.shadowColor =[UIColor whiteColor];
            }else{
                self.customLab.backgroundColor  =RGBA(243, 243, 243, 1);
                self.customLab.shadowColor =[UIColor lightGrayColor];
            }
           
        }
        self.customLab.detailModel  =detailModel;
        //一个新需求 ，返回的标准值是空的情况下 判定结果要客户手动选择
        if (mainModel.MinStandard.length ==0 && mainModel.MaxStandard.length ==0 &&[mainModel.operationStr isEqualToString:@"录入检验结果"]) {
            self.customLab.userInteractionEnabled  =YES;
            UITapGestureRecognizer *tap  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMethod:)];
            [self.customLab addGestureRecognizer:tap];
        }
     
        
        //self.customLab.backgroundColor  =[UIColor whiteColor];
        if (detailModel.DecisionResult.length ==0) {
            self.customLab.text =@" ";
        }else{
            self.customLab.text  =detailModel.DecisionResult;
        }
        
    }else{
        //检验结果
        if ([mainModel.operationStr isEqualToString:@"录入检验结果"]||[mainModel.operationStr isEqualToString:@"编辑"]) {
            if (mainModel.RelateTaskCode.length ==0) {
                //不是物理实验室项目
                self.textfield.hidden =NO;
                self.customLab.hidden =YES;
                NSAttributedString *atturStr =[[NSAttributedString alloc]initWithString:@"实测值" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
                self.textfield.attributedPlaceholder  = atturStr;
                EMCustomKeyboardView *keyboard  =[[EMCustomKeyboardView alloc]init];
                
                self.textfield.inputView =keyboard;
                keyboard.subView  = chartView;
                keyboard.textf =self.textfield;
                self.textfield.text  =[self cellTextWithIdx:idx-1 model:detailModel];
                
            }else{
                //物理实验室项目
                self.customLab.hidden =NO;
                self.textfield.hidden =YES;
                self.customLab.backgroundColor  = RGBA(243, 243, 244, 1);
                self.customLab.shadowColor =[UIColor lightGrayColor];
                self.customLab.text  =[self cellTextWithIdx:idx-1 model:detailModel]?:@" ";
            }
        }else{
            //查看
            self.textfield.hidden =YES;
            self.customLab.hidden  =NO;
            self.customLab.backgroundColor  =[UIColor whiteColor];
            self.customLab.text  =[self cellTextWithIdx:idx-1 model:detailModel];
        }
       
    }

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
    self.customLab.detailModel.DecisionResult  = selectStr;
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
    ybPopupMenu.topLabel.text  =selectStr;
    
    [ybPopupMenu dismiss];
}
@end
