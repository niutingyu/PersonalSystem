//
//  IQCAuditController.m
//  ServiceSysterm
//
//  Created by Andy on 2021/7/9.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "IQCAuditController.h"
#import "IQCCheckItemTableCell.h"
#import "IQCBugListTableCell.h"
#import "IQCBugTableHeadView.h"
#import "IqcBugModel.h"
#import "IqcBugAlertView.h"
@interface IQCAuditController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>

/**
 缺陷List
 */
@property (nonatomic,strong)NSMutableArray * IqcbugArray;

@property (nonatomic,strong)NSMutableArray *bugList;



@end

NSString * const checkReusedIdtifire    =@"checkReusedIdtifire";
NSString * const bugReusedIdtifire      =@"bugReusedIdtifire";

@implementation IQCAuditController





- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"IQC检查单";
    [self.view addSubview:self.tableView];
    
    
    [self.tableView registerClass:[IQCCheckItemTableCell class] forCellReuseIdentifier:checkReusedIdtifire];
    [self.tableView registerClass:[IQCBugListTableCell class] forCellReuseIdentifier:bugReusedIdtifire];
    [self getIqcBug];
    
    UIBarButtonItem * auditItem  =[[UIBarButtonItem alloc]initWithTitle:@"审核" style:UIBarButtonItemStyleDone target:self action:@selector(auditMethod)];
    self.navigationItem.rightBarButtonItem  = auditItem;
    
    UITapGestureRecognizer *tap  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture)];
    tap.delegate =self;
    [self.view addGestureRecognizer:tap];
    
    
}

-(void)tapGesture{
    [self.view endEditing:YES];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{

    if([NSStringFromClass([touch.view class])isEqual:@"UITableViewCellContentView"]){
        return NO;
    }
    return YES;
}
-(void)auditMethod{
    [self.view endEditing:YES];
    NSString *methodTypeStr ;
    NSMutableDictionary *totalParms  =[NSMutableDictionary dictionary];
  
    if ([self.mainListModel.IqcTaskTypeStr isEqualToString:@"收货IQC"]) {
        if (self.bugList.count ==0) {
            [Units showErrorStatusWithString:@"请添加缺陷代码"];
            return;
        }
        for (IqcTreatmentModel *model in self.bugList) {
             if (model.treatment.length  ==0) {
                 [Units showErrorStatusWithString:@"请完整处理方式"];
                 return;
             }if (model.count.length  ==0) {
                 [Units showErrorStatusWithString:@"请输入数量"];
                 return;
             }
         }
        
        for (IqcTreatmentModel *bugModel in self.bugList) {
            methodTypeStr  =bugModel.treatment;
        }
        NSString *passCountStr;//合格数量
        
        NSString *specialCountStr;//特采数量
        
        NSString *nopassCountStr;//不合格数量
        
        if ([methodTypeStr isEqualToString:@"换货"]||[methodTypeStr isEqualToString:@"退货"]) {
            NSInteger totalCount = [[self.bugList valueForKeyPath:@"@sum.count"] intValue];
            if (totalCount !=[self.mainListModel.TotalCount intValue]) {
                [Units showErrorStatusWithString:@"缺陷数量必须和检测数量相同"];
                return;
            }
            
            passCountStr  =@"0";
            specialCountStr =@"0";
            nopassCountStr  =self.mainListModel.TotalCount;
        }else if ([methodTypeStr isEqualToString:@"特采"]){
            NSInteger totalCount = [[self.bugList valueForKeyPath:@"@sum.count"] intValue];
            if (totalCount !=[self.mainListModel.TotalCount intValue]) {
                [Units showErrorStatusWithString:@"缺陷数量必须和检测数量相同"];
                return;
            }
            passCountStr  =@"0";
            nopassCountStr  =@"0";
            specialCountStr  =self.mainListModel.TotalCount;
        }
        //返检 IQC list 为空 修改有效期  不合格 报废
        
        NSMutableDictionary *modelDict  =[NSMutableDictionary dictionary];
        [modelDict setObject:self.mainListModel.Id forKey:@"Id"];
        [modelDict setObject:self.mainListModel.ExpDate?:@"" forKey:@"ExpDate"];
        [modelDict setObject:passCountStr forKey:@"PassCount"];//合格数量
        [modelDict setObject:nopassCountStr forKey:@"RejCount"];//不合格数量
        [modelDict setObject:specialCountStr forKey:@"SpecialCount"];//特采数量
        [modelDict setObject:USERDEFAULT_object(CodeName) forKey:@"AuditBy"];
        [modelDict setObject:[Units currentTimeWithFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"AuditOn"];
        
        NSMutableArray *bugArray  =[NSMutableArray array];
        [bugArray removeAllObjects];
        for (IqcTreatmentModel *bugModel in self.bugList) {
            NSMutableDictionary *dict  =[NSMutableDictionary dictionary];
            [dict setObject:bugModel.treatmentIdStr forKey:@"IqcResult"];
            [dict setObject:bugModel.bugId forKey:@"BugId"];
            [dict setObject:bugModel.count forKey:@"Count"];
            [bugArray addObject:dict];
        }
        
        [totalParms setObject:[Units dictionaryToJson:modelDict] forKey:@"model"];
        [totalParms setObject:[Units arrayToJson:bugArray] forKey:@"bugList"];
    }else if ([self.mainListModel.IqcTaskTypeStr isEqualToString:@"返检IQC"]){
        
        //返检Iqc
        //判断checkResult的值 0 不合格 1 合格
        //如果是1 在不添加缺陷代码的情况下 表明审核通过 此时要判断有效期 必须大于当前时间
        if ([self.mainListModel.CheckResult isEqualToString:@"1"]) {
            if (self.bugList.count ==0) {
                //判断有效期要大于当前时间
              
                NSDate *date1  =[NSDate date];
             
                NSDate *date2  =[Units dataFromString:self.mainListModel.ExpDate withFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSComparisonResult result  = [date1 compare:date2];
                debugLog(@" -= = =%@",self.mainListModel.ExpDate);
                if (result ==NSOrderedDescending) {
                    
                    [Units showErrorStatusWithString:@"有效期必须大于当前时间"];
                    return;
                }
                
                
            }
        }else{
            //检验结果不合格 必须添加缺陷代码
            if (self.bugList.count  ==0) {
                [Units showErrorStatusWithString:@"请添加缺陷代码"];
                return;
            }
            
        }
        
        
        NSString * methodTypeStr;
        
        for (IqcTreatmentModel *bugModel in self.bugList) {
            methodTypeStr  =bugModel.treatment;
        }
        
        NSString *passCountStr;//合格数量
        NSString *nopassCountStr;//不合格数量
        NSString *specialCountStr;//特采数量
        NSMutableArray *bugArray  =[NSMutableArray array];
        [bugArray removeAllObjects];
        if ([methodTypeStr isEqualToString:@"报废"]) {
            for (IqcTreatmentModel *model in self.bugList) {
                if (model.treatmentIdStr.length ==0) {
                    [Units  showErrorStatusWithString:@"处理方式必填"];
                    return;
                }if (model.count.length  ==0) {
                    [Units showErrorStatusWithString:@"数量必填"];
                    return;
                }
                NSInteger totalCount = [[self.bugList valueForKeyPath:@"@sum.count"] intValue];
                if (totalCount !=[self.mainListModel.TotalCount intValue]) {
                    [Units showErrorStatusWithString:@"缺陷数量必须和检测数量相同"];
                    return;
                }
            }
            passCountStr =@"0";
            nopassCountStr  =self.mainListModel.TotalCount;
            specialCountStr =@"0";
            
            for (IqcTreatmentModel *bugModel in self.bugList) {
                NSMutableDictionary *dict  =[NSMutableDictionary dictionary];
                [dict setObject:bugModel.treatmentIdStr forKey:@"IqcResult"];
                [dict setObject:bugModel.bugId forKey:@"BugId"];
                [dict setObject:bugModel.count forKey:@"Count"];
                [bugArray addObject:dict];
            }
           
            
        }else{
            passCountStr  =self.mainListModel.TotalCount;
            nopassCountStr  =@"0";
            specialCountStr  =@"0";
        }
  
        
        NSMutableDictionary *modelDict  =[NSMutableDictionary dictionary];
        
        
        [modelDict setObject:self.mainListModel.Id forKey:@"Id"];
        [modelDict setObject:self.mainListModel.ExpDate?:@"" forKey:@"ExpDate"];
        [modelDict setObject:passCountStr forKey:@"PassCount"];//合格数量
        [modelDict setObject:nopassCountStr forKey:@"RejCount"];//不合格数量
        [modelDict setObject:specialCountStr forKey:@"SpecialCount"];//特采数量
        [modelDict setObject:USERDEFAULT_object(CodeName) forKey:@"AuditBy"];
        [modelDict setObject:[Units currentTimeWithFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"AuditOn"];
        //[modelDict setObject:self.mainListModel.TotalCount forKey:@"TotalCount"];
        [totalParms removeAllObjects];
        [totalParms setObject:[Units dictionaryToJson:modelDict] forKey:@"model"];
        [totalParms setObject:[Units arrayToJson:bugArray] forKey:@"buglList"];
    }
    debugLog(@"===%@",totalParms);
    NSString *url  =@"qc/iqctask/audit";
    [Units showLoadStatusWithString:Loading];
    KWeakSelf
    
    [HttpTool POST:[url getWholeUrl] param:totalParms success:^(NSDictionary * _Nonnull responseObject) {
        [Units hideView];
        [Units showStatusWithStutas:responseObject[@"info"]];
        if ([[responseObject objectForKey:@"status"]intValue]==0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (weakSelf.networkSuncessBlock) {
                    weakSelf.networkSuncessBlock();
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
                           
            });
        }
        
        debugLog(@" -- -%@",responseObject);
    } error:^(NSString * _Nonnull error) {
        debugLog(@"error %@",error);
    }];
    
    

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section  ==1) {
        //缺陷
        return self.bugList.count;
    }else{
        return 1;
    }
  
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section  ==0) {
        IQCCheckItemTableCell * cell  =[tableView dequeueReusableCellWithIdentifier:checkReusedIdtifire];
        cell.listModel  =self.mainListModel;
        cell.bugCodeList  =self.bugList;
        return cell;
    }else{
        IQCBugListTableCell * cell  =[tableView dequeueReusableCellWithIdentifier:bugReusedIdtifire];
//        IqcBugModel * model  = self.IqcbugArray[indexPath.row];
//        cell.IqcBugList = self.IqcbugArray;
        cell.listModel  =self.mainListModel;
//
//        [cell configBugTableViewWithModel:model number:[NSString stringWithFormat:@"%ld",indexPath.row+1]];
        
        cell.countTextf.delegate  =self;
        IqcTreatmentModel *model  = self.bugList[indexPath.row];
        cell.treatmentModel  =model;
        cell.treatMentList =self.bugList;
        cell.countTextf.tag  =indexPath.row;
        [cell configBugTableViewWithModel:model number:[NSString stringWithFormat:@"%ld",indexPath.row+1]];
       KWeakSelf
        cell.methodBlcok = ^(NSString * _Nonnull methodStr, NSString * _Nonnull methodIdStr) {
            for (IqcTreatmentModel *bugModel in self.bugList) {
                bugModel.treatment =methodStr;
                bugModel.treatmentIdStr  =methodIdStr;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
            [weakSelf.tableView reloadData];
        };
        return cell;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section  ==0) {
        return 308;
    }else{
        
        return 60;
    }
   
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section  ==1) {
        IQCBugTableHeadView * headView  =[[IQCBugTableHeadView alloc]init];
        
        return headView;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section  ==1) {
        if (self.bugList.count >0) {
            return 60;
        }else{
            return CGFLOAT_MIN;
        }
       
    }else{
        return CGFLOAT_MIN;
    }
   
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section  ==0) {
        UIView *footView  =[[UIView alloc]init];
        UIButton * but  =[UIButton buttonWithType:UIButtonTypeCustom];
        
        [but setImage:[UIImage imageNamed:@"icon--tianjia"] forState:UIControlStateNormal];
        [but setTitle:@"添加缺陷代码" forState:UIControlStateNormal];
        but.titleLabel.font  =[UIFont systemFontOfSize:15];
        [but setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(butMethod) forControlEvents:UIControlEventTouchUpInside];
        but.titleEdgeInsets  =UIEdgeInsetsMake(0, 15, 0, 0);
        [footView addSubview:but];
        [but mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-16);
            make.centerY.mas_equalTo(footView);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(50);
        }];
        
        return footView;
    }else{
        return nil;
    }
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section  ==1) {
        return YES;
    }else{
        return NO;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        [self.bugList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
//添加缺陷代码
-(void)butMethod{
    [self.view endEditing:YES];
    KWeakSelf
    [IqcBugAlertView showBugViewWithList:self.IqcbugArray bugBlcok:^(IqcBugModel * _Nonnull bugModel) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"IqcTreatment.json" ofType:nil];
                NSData *data = [NSData dataWithContentsOfFile:path];
                NSError *error;
                NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                if (!error) {
                    IqcTreatmentModel *model  =[IqcTreatmentModel mj_objectWithKeyValues:dataDict];
                    model.bugCode =bugModel.BugCode;
                    model.bugName =bugModel.BugName;
                    model.bugId =bugModel.BugId;
                    model.treatment  =bugModel.methodStr?:@"";
                    
                    [weakSelf.bugList addObject:model];
                }
        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section  ==0) {
        return 60;
    }else{
        return CGFLOAT_MIN;
    }
}

//UITextField

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    IqcTreatmentModel *model  = self.bugList[textField.tag];
    model.count  = textField.text;
    
    return YES;
}

//获取缺陷
-(void)getIqcBug{
    NSString * url =@"mc/iqcbug/getpage";
    [Units showLoadStatusWithString:Loading];
    NSDictionary * dic =[NSDictionary dictionary];
    KWeakSelf
    [HttpTool POST:[url getWholeUrl] param:dic success:^(NSMutableDictionary*  _Nonnull responseObject) {
        [Units hideView];
      //  [Units showHudWithText:respon33seObject[@"info"] view:weakSelf.view model:MBProgressHUDModeText];
        if ([[responseObject objectForKey:@"status"]intValue]==0) {
            NSDictionary * jsonDict =[Units jsonToDictionary:responseObject[@"data"]];
            NSArray * jsonArray   = [jsonDict objectForKey:@"list"];
            NSMutableArray * modelArray  =[IqcBugModel mj_objectArrayWithKeyValuesArray:jsonArray];
            [weakSelf.IqcbugArray removeAllObjects];
            [weakSelf.IqcbugArray addObjectsFromArray:modelArray];
           
            debugLog(@"  == = =%@",jsonArray);
            
        }
        
        [weakSelf.tableView reloadData];
        
       // debugLog(@" -- -- - -%@",responseObject);
    } error:^(NSString * _Nonnull error) {
        [Units showErrorStatusWithString:error];
    }];
}

-(NSMutableArray*)IqcbugArray{
    if (!_IqcbugArray) {
        _IqcbugArray  =[NSMutableArray array];
    }
    return _IqcbugArray;
}

-(NSMutableArray*)bugList{
    if (!_bugList) {
        _bugList  =[NSMutableArray array];

        
    }return _bugList;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
