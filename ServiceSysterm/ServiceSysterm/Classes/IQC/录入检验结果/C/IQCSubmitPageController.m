//
//  IQCSubmitPageController.m
//  ServiceSysterm
//
//  Created by Andy on 2021/6/1.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "IQCSubmitPageController.h"

#import "QCEnterTaskCodeView.h"
#import "QCOCTableViewCell.h"
#import "QCHeaderSectionView.h"
#import "QCValidityTableCell.h"
#import "QCAppearanceTableCell.h"
#import "LongedgeSizeTableCell.h"
#import "QCWideTableViewCell.h"
#import "DiagonalSizeTableCell.h"
#import "AppearanceAlertView.h"
#import "CCDatePickerView.h"

#import "QCSubmitMainModel.h"
#import "QCAppearanceModel.h"
#import "UITableView+AddForPlaceholder.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

NSString * const COCReusedIdterifreCellId  =@"COCReusedIdterifreCellId";
NSString * const ValidityReusedIdtifireCellId =@"ValidityReusedIdtifireCellId";
NSString * const AppearanceReusedIdtifireCellId  =@"AppearanceReusedIdtifireCellId";
NSString * const LongSizeReusedIdtifireCellId =@"LongSizeReusedIdtifireCellId";

NSString * const WideReusedIdtifireCellId =@"WideReusedIdtifireCellId";

NSString * const DiagonalReusedIdtifireCellId  =@"DiagonalReusedIdtifireCellId";


const CGFloat headerH  =210;
const CGFloat topTitleH = 80;



@interface IQCSubmitPageController ()<appearanceDelegate,UIGestureRecognizerDelegate>


@property (nonatomic,strong)QCEnterTaskCodeView * taskCodeView;


@property (nonatomic,strong)UITableView * listView;


/**
 主数据数组
 */
@property (nonatomic,strong)NSMutableArray *mainList;

@end

@implementation IQCSubmitPageController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar  =YES;
    [IQKeyboardManager sharedManager].toolbarManageBehaviour =IQAutoToolbarByPosition;
   // [IQKeyboardManager sharedManager].keyboardDistanceFromTextField =20;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
   

    self.view.backgroundColor  =RGBA(242, 242, 242, 1);
    
    
    self.automaticallyAdjustsScrollViewInsets  =NO;
    
   //检验结果录入界面
    
    self.title  =@"检验结果";
    
 
    if ([self.operationTypeStr isEqualToString:@"录入检验结果"]||[self.operationTypeStr isEqualToString:@"编辑"]) {
        UIBarButtonItem * rightItem1 =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(saveMethod)];
       
        
        UIBarButtonItem *rightItem2  =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(submitMethod)];
        NSArray *items  = @[rightItem1,rightItem2];
        self.navigationItem.rightBarButtonItems  = items;
    }
   
    [self setupEnterTaskCodeView];
    

}

#pragma mark  ------ - 录入界面
-(void)setupEnterTaskCodeView{

    self.taskCodeView  =[[QCEnterTaskCodeView alloc]init];
    self.taskCodeView.listModel  =_listModel;
    [self.view addSubview:self.taskCodeView];
    [self.taskCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(64);
        make.right.mas_offset(0);
        make.left.mas_offset(0);
        make.height.mas_equalTo(headerH);
    }];
   
    self.listView  =[[UITableView alloc]initWithFrame:CGRectMake(0, headerH+64, kScreenWidth, kScreenHeight-headerH-64-10) style:UITableViewStylePlain];
    self.listView.delegate  =self;
    self.listView.dataSource  =self;
    self.listView.autoresizingMask  =UIViewAutoresizingFlexibleHeight;
    self.listView.separatorStyle  =UITableViewCellSeparatorStyleSingleLine;
    self.listView.showsVerticalScrollIndicator  =NO;
    self.listView.tableFooterView  =[[UIView alloc]init];
    
    [self.view addSubview:self.listView];
    
    self.listView.mj_footer  =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
    }];

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           
                //加载最后一份数据后，变为没有更多数据的状态
            [self.listView.mj_footer endRefreshingWithNoMoreData];
          
        });

    //获取检验项
    [self getTaskItem];

    [_listView registerClass:[QCOCTableViewCell class] forCellReuseIdentifier:COCReusedIdterifreCellId];
    
    [_listView registerClass:[QCValidityTableCell class] forCellReuseIdentifier:ValidityReusedIdtifireCellId];
    
    [_listView registerClass:[QCAppearanceTableCell class] forCellReuseIdentifier:AppearanceReusedIdtifireCellId];
    
    [_listView registerClass:[LongedgeSizeTableCell class] forCellReuseIdentifier:LongSizeReusedIdtifireCellId];
    
    [_listView registerClass:[QCWideTableViewCell class] forCellReuseIdentifier:WideReusedIdtifireCellId];
    
    [_listView registerClass:[DiagonalSizeTableCell class] forCellReuseIdentifier:DiagonalReusedIdtifireCellId];
    self.listView.defaultNoDataText =@"暂无更多数据";
    
    UITapGestureRecognizer *tap  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture)];
    tap.cancelsTouchesInView  =NO;
    tap.delegate =self;
    [self.view addGestureRecognizer:tap];

    
}

-(void)tapGesture{
    [self.view endEditing:YES];
}

//解决tap 和tableView 手势冲突
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{

    if([NSStringFromClass([touch.view class])isEqual:@"UITableViewCellContentView"]||[NSStringFromClass([touch.view class])isEqual:@"UICollectionViewCellContentView"]){
        return NO;
    }
    return YES;
}
#pragma mark UITableviewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.mainList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    QCSubmitMainModel * model  = self.mainList[indexPath.section];
    
    model.pathNumber  =indexPath.section;
  
    if ([model.typeStr isEqualToString:@"coc"]) {
        QCOCTableViewCell * cell  =[tableView dequeueReusableCellWithIdentifier:COCReusedIdterifreCellId];
        model.operationStr  =self.operationTypeStr;
        cell.mainModel  =model;
       
       
        return cell;
    }
    else if ([model.typeStr isEqualToString:@"有效期"]){
        QCValidityTableCell * cell  =[tableView dequeueReusableCellWithIdentifier:ValidityReusedIdtifireCellId];
        cell.mainModel  =model;
       
        model.operationStr  =self.operationTypeStr;
        return cell;
    }else if ([model.typeStr isEqualToString:@"缺陷"]){
        QCAppearanceTableCell * cell  =[tableView dequeueReusableCellWithIdentifier:AppearanceReusedIdtifireCellId];
    
        model.operationStr  =self.operationTypeStr;
        cell.mainModel  =model;
        cell.delegate  =self;
        
        return cell;
    }else if ([model.typeStr isEqualToString:@"偏差"]){
        DiagonalSizeTableCell * cell  =[tableView dequeueReusableCellWithIdentifier:DiagonalReusedIdtifireCellId];
        cell.mainModel  =model;
    
        model.operationStr  =self.operationTypeStr;
        
        return cell;
    }else{
        LongedgeSizeTableCell * cell  =[tableView dequeueReusableCellWithIdentifier:LongSizeReusedIdtifireCellId];
        cell.mainModel  =model;
    
        model.operationStr = self.operationTypeStr;
        return cell;
    }

}

#pragma mark  = = ==  =外观检查Delegate

-(void)didSelectedRowAtIndexPath:(NSIndexPath *)indexPath pathSection:(NSInteger)pathSection{
    
    QCSubmitMainModel * model  = self.mainList[pathSection];
    KWeakSelf
    [AppearanceAlertView showassetAlertViewWithMainModel:model idxRow:indexPath.section  appranceBlock:^{
        NSIndexSet * set  =[[NSIndexSet alloc]initWithIndex:pathSection];
        
        [weakSelf.listView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
   
    
  
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    QCSubmitMainModel * mainModel  = self.mainList[indexPath.section];

    return mainModel.cellHeight;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60.0f;
}



-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    QCHeaderSectionView * headView  =[[QCHeaderSectionView alloc]init];
    QCSubmitMainModel * model  = self.mainList[section];
    if ([model.typeStr isEqualToString:@"coc"]) {
        NSString *standardStr ;
        if (model.CheckStandard.length ==0) {
            standardStr  =@"";
        }else{
            standardStr  =model.CheckStandard;
        }
        headView.titleLab .text = [NSString stringWithFormat:@"%ld、%@(%@)",section+1,model.Name,standardStr];
    }else if ([model.typeStr isEqualToString:@"缺陷"]){
        headView.titleLab .text = [NSString stringWithFormat:@"%ld、%@(无缺陷)",section+1,model.Name];
    }else{
        NSString * minStandardStr;
        NSString * maxStandardStr;
        if (model.MinStandard.length ==0) {
            minStandardStr  =@"?";
            
        }else{
            minStandardStr =model.MinStandard;
        }
        if (model.MaxStandard.length ==0) {
            maxStandardStr  =@"?";
        }else{
            maxStandardStr  =model.MaxStandard;
        }
        if ([model.RelateModule isEqualToString:@"1"]||[model.RelateModule isEqualToString:@"2"]) {
            headView.titleLab .text = [NSString stringWithFormat:@"%ld、%@(%@)",section+1,model.Name,model.CheckStandard];
        }else{
            if ([model.Name containsString:@"长边"]||[model.Name containsString:@"宽边"]) {
                headView.titleLab.text =[NSString stringWithFormat:@"%ld、%@(>=%@)",section+1,model.Name,model.MinStandard];
            }else if ([model.Name containsString:@"铜厚"]){
                float minStandard = [minStandardStr floatValue];
                float maxStandard  =[maxStandardStr floatValue];
                headView.titleLab.text  =[NSString stringWithFormat:@"%ld、%@(%.2f-%.2f)",section+1,model.Name,minStandard,maxStandard];
            }
            else{
                headView.titleLab .text = [NSString stringWithFormat:@"%ld、%@(%@-%@)",section+1,model.Name,minStandardStr,maxStandardStr];
            }
            
        }
       
    }
  
    return headView;
}


-(void)saveMethod{
    [self.tableView reloadData];
   //保存
    [self.view endEditing:YES];

    NSMutableArray *resultList  =[NSMutableArray array];
    
    [resultList removeAllObjects];
 
    for (QCSubmitMainModel *model in self.mainList) {
        if (model.DecisionResult.length >0) {
            NSMutableDictionary * resultDict  =[NSMutableDictionary dictionary];
            [resultDict setObject:model.DecisionResult forKey:@"DecisionResult"];
            [resultDict setObject:model.Id forKey:@"Id"];
           
            [resultList addObject:resultDict];
        }
    }
    //详细
    NSMutableArray * detailResultList  =[NSMutableArray array];
    [detailResultList removeAllObjects];
    for (QCSubmitMainModel *model in self.mainList) {
        for (QCDetailListModel *detailModel in model.detailList) {
            if (detailModel.DecisionResult.length >0) {
                [detailResultList addObject:detailModel];
            }
        }
    }

    //model转为字典
   NSMutableArray  * jsonArray  =[QCDetailListModel mj_keyValuesArrayWithObjectArray:detailResultList];
    
 
    //主model
    NSMutableDictionary *modelDict  =[NSMutableDictionary dictionary];

    [modelDict setObject:_itemId forKey:@"Id"];
    
    NSMutableDictionary * totalParms  =[NSMutableDictionary dictionary];
    [totalParms setObject:[Units dictionaryToJson:modelDict] forKey:@"model"];
    [totalParms setObject:[Units arrayToJson:resultList] forKey:@"resultList"];
    [totalParms setObject:[Units arrayToJson:jsonArray] forKey:@"resultDetailList"];
    NSString  *url  = @"qc/iqctask/save";
   
    [Units showLoadStatusWithString:Loading];
    KWeakSelf
    [HttpTool POST:[url getWholeUrl] param:totalParms success:^(id  _Nonnull responseObject) {
        [Units hideView];
        [Units showStatusWithStutas:responseObject[@"info"]];
        if ([[responseObject objectForKey:@"status"]intValue]==0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               
                [weakSelf.navigationController popViewControllerAnimated:YES];
                           
            });
        }
      
    } error:^(NSString * _Nonnull error) {
        [Units hideView];
       
    }];
    
    

}

-(void)submitMethod{
    //提交
    [self.view endEditing:YES];
    

    for (QCSubmitMainModel *mainModel in self.mainList) {
        if (mainModel.RelateTaskCode.length ==0) {
            for (QCDetailListModel *detailModel in mainModel.detailList) {
              
                if (detailModel.DecisionResult.length ==0 ) {
                    [Units showErrorStatusWithString:[NSString stringWithFormat:@"%@必填",mainModel.Name]];
                    return;
                }
            }
        }
    }


    NSMutableArray *resultList  =[NSMutableArray array];
    
    [resultList removeAllObjects];
    
    //详细
    NSMutableArray * detailResultList  =[NSMutableArray array];
    [detailResultList removeAllObjects];
    
    for (QCSubmitMainModel * model in self.mainList) {
        if (model.RelateTaskCode.length ==0) {
            NSMutableDictionary * resultDict  =[NSMutableDictionary dictionary];
            [resultDict setObject:model.DecisionResult forKey:@"DecisionResult"];
            [resultDict setObject:model.Id forKey:@"Id"];
            [resultList addObject:resultDict];
        }
    }
 
    for (QCSubmitMainModel * model in self.mainList) {
        for (QCDetailListModel *detailModel in model.detailList) {
            if (![detailResultList containsObject:detailModel]) {
                [detailResultList addObject:detailModel];
            }
        }
    }
    //model转为字典
   NSMutableArray  * jsonArray  =[QCDetailListModel mj_keyValuesArrayWithObjectArray:detailResultList];
    

    //判断数组中是否含有不合格的项目 ，如果有一个不合格则判定为整个检查单不合格
    NSMutableString * string =[[NSMutableString alloc]init];
    
    for (QCSubmitMainModel *mainModel in self.mainList) {
        if (mainModel.RelateTaskCode ==0) {
            [string appendString:mainModel.DecisionResult];
        }
        
    }
    //主model
    NSMutableDictionary *modelDict  =[NSMutableDictionary dictionary];
    if ([string containsString:@"0"]) {
        [modelDict setObject:@"0" forKey:@"CheckResult"];
    }else{
        [modelDict setObject:@"1" forKey:@"CheckResult"];
    }
    [modelDict setObject:_itemId forKey:@"Id"];
   
    NSMutableDictionary * totalParms  =[NSMutableDictionary dictionary];
    [totalParms setObject:[Units dictionaryToJson:modelDict] forKey:@"model"];
    [totalParms setObject:[Units arrayToJson:resultList] forKey:@"resultList"];
    [totalParms setObject:[Units arrayToJson:jsonArray] forKey:@"resultDetailList"];
    NSString * url =@"qc/iqctask/submit";
 //   debugLog(@"parms  %@",totalParms);
    //判定任务是否合格
    
    if ([string containsString:@"0"]) {
        [self alertControllerWithParms:totalParms url:url];
    }else{
        KWeakSelf
        [Units showLoadStatusWithString:Loading];
        [HttpTool POST:[url getWholeUrl] param:totalParms success:^(NSMutableDictionary*  _Nonnull responseObject) {
            [Units hideView];
            [Units showStatusWithStutas:responseObject[@"info"]];
            if ([[responseObject objectForKey:@"status"]intValue]==0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (weakSelf.submitSucessBlock) {
                        weakSelf.submitSucessBlock();
                    }
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                               
                });
            }
           
        } error:^(NSString * _Nonnull error) {
            [Units hideView];
            [Units showStatusWithStutas:error];
            
        }];
    }
   
  
}


//弹框是否提交
-(void)alertControllerWithParms:(NSMutableDictionary*)parms url:(NSString*)url {
    UIAlertController *controller  =[UIAlertController alertControllerWithTitle:@"提示" message:@"任务单不合格,是否提交" preferredStyle:UIAlertControllerStyleAlert];
    KWeakSelf
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [Units showLoadStatusWithString:Loading];
        [HttpTool POST:[url getWholeUrl] param:parms success:^(NSMutableDictionary*  _Nonnull responseObject) {
            [Units hideView];
            [Units showStatusWithStutas:responseObject[@"info"]];
            if ([[responseObject objectForKey:@"status"]intValue]==0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (weakSelf.submitSucessBlock) {
                        weakSelf.submitSucessBlock();
                    }
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                               
                });
            }
           
        } error:^(NSString * _Nonnull error) {
            [Units hideView];
            [Units showStatusWithStutas:error];
            
        }];
    }]];
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:controller animated:YES completion:nil];
}

//获取检验项
-(void)getTaskItem{
    NSDictionary * parms  =@{@"id":_itemId};
    NSString  *url  =@"qc/iqctask/getTaskItem";
    
    KWeakSelf
    [Units showLoadStatusWithString:Loading];
    [HttpTool POST:[url getWholeUrl] param:parms success:^(NSDictionary*  _Nonnull responseObject) {
        [Units hideView];
        if ([[responseObject objectForKey:@"status"]intValue]==0) {
            NSArray * jsonArray  =[Units jsonToArray:responseObject[@"data"]];
            NSMutableArray *modelArray  =[QCSubmitMainModel mj_objectArrayWithKeyValuesArray:jsonArray] ;
            [weakSelf.mainList removeAllObjects];
            if ([self.operationTypeStr isEqualToString:@"录入检验结果"]||[self.operationTypeStr isEqualToString:@"编辑"]) {
                for (QCSubmitMainModel *model in modelArray) {
                    if (![model.RelateModule isEqualToString:@"1"]&&![model.RelateModule isEqualToString:@"2"]) {
                        //是IQC 检验项目  录入检验结果时显示
                        [weakSelf.mainList addObject:model];
                        
                    }
                }
            }else{
                [weakSelf.mainList addObjectsFromArray:modelArray];
            }
        }
        [weakSelf.listView reloadData];
        debugLog(@"res  ==%@",responseObject);
    } error:^(NSString * _Nonnull error) {
        [Units hideView];
       
    }];
}


-(NSMutableArray*)mainList{
    if (!_mainList) {
        _mainList  =[NSMutableArray array];
    }
    return _mainList;
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar  =NO;
}
@end
