//
//  IQCMainController.m
//  ServiceSysterm
//
//  Created by Andy on 2021/7/6.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "IQCMainController.h"
#import "QCMainHeadTableView.h"
#import "IQCListModel.h"
#import "QCTaskListCollectionHeadView.h"
#import "QCTaskListTableCell.h"
#import "YBPopupMenu.h"
#import "IQCAuditController.h"
#import "IQCSubmitPageController.h"
#import "MoudleModel.h"
#import "IQCReportViewController.h"

#import "IQCFileModel.h"
@interface IQCMainController ()<YBPopupMenuDelegate>

@property (nonatomic,assign)NSInteger segmentSelectedIdx;

/**
 权限数组
 */
@property (nonatomic,strong)NSMutableArray *rightArray;

/**
 状态
 */
@property (nonatomic,assign)NSInteger statusId;

/**
 物料编码
 */
@property (nonatomic,copy)NSString * materialNumberStr;

/**
 物料规格
 */
@property (nonatomic,copy)NSString *materialInfoStr;

/**
 物料名称
 */
@property (nonatomic,copy)NSString *materialNameStr;

/**
 上拉加载
 */
@property (nonatomic,assign)NSInteger pageIdx;

/**
 工厂ID
 */
@property (nonatomic,strong)NSMutableArray *fIdList;

/**
 选中工厂Id
 */
@property (nonatomic,copy)NSString *selectedFId;

/**
 工厂名称
 */
@property (nonatomic,strong)NSMutableArray *fNameList;

/**
 开始日期
 */
@property (nonatomic,copy)NSString *beginStr;

/**
 结束日期
 */
@property (nonatomic,copy)NSString *endStr;



@end


NSString * const taskListReusedidtifire =@"taskListReusedidtifire";

@implementation IQCMainController


/**
 获取工厂
 */

-(void)getFactory{
    NSMutableDictionary *parms  =[NSMutableDictionary dictionary];
    [parms setObject:USERDEFAULT_object(JOBNUM) forKey:@"username"];
    NSString *url  =@"api/baseapi/getUserFactoryList";
    KWeakSelf
    [HttpTool POST:[url getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"status"]integerValue]==0) {
            
            NSArray *list  = [Units jsonToArray:responseObject[@"data"]];
            
            [weakSelf.fIdList removeAllObjects];
            
            [weakSelf.fNameList removeAllObjects];
            
            for (NSDictionary *dict in list) {
                [weakSelf.fIdList addObject:dict[@"FactoryId"]];
                [weakSelf.fNameList addObject:dict[@"FactoryName"]];
            }
            
            //把数组转化为字符串
            NSString * fIdStr  = [weakSelf.fIdList componentsJoinedByString:@","];
            weakSelf.selectedFId  =[NSString stringWithFormat:@"-1,0,%@",fIdStr?:@""];
            
            //请求主页数据接口
            [weakSelf getIQCTaskListWithType:[NSString stringWithFormat:@"%d",0] numberStr:@"" nameStr:@"" infoStr:@"" status:0];
            
        }
        
    } error:^(NSString * _Nonnull error) {
        
    }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"IQC管理";
    self.tableView.backgroundColor  = RGBA(255, 250, 250, 1);
   // self.tableView.showsVerticalScrollIndicator =NO;
  //  self.automaticallyAdjustsScrollViewInsets  =NO;
  //  self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
   
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[QCTaskListTableCell class] forCellReuseIdentifier:taskListReusedidtifire];
    
    QCMainHeadTableView * headView  =[[QCMainHeadTableView alloc]init];
    
    headView.bounds  = CGRectMake(0, 0, kScreenWidth, 115);
    
   
    self.tableView.tableHeaderView  =headView;
    
    self.statusId  =0;
    self.pageIdx =1;
    KWeakSelf

    headView.butBlock = ^(NSInteger flag, NSString * _Nonnull numberString, NSString * _Nonnull nameString, NSString * _Nonnull infoString) {
        if (flag == 999) {
            //查询
            weakSelf.pageIdx =1;
            weakSelf.materialNumberStr  =numberString;
            weakSelf.materialNameStr  =nameString;
            weakSelf.materialInfoStr  =infoString;
            [weakSelf.datasource removeAllObjects];
            [weakSelf getIQCTaskListWithType:[NSString stringWithFormat:@"%ld",weakSelf.segmentSelectedIdx] numberStr:numberString nameStr:nameString infoStr:infoString status:weakSelf.statusId];
            
        }else{
            //重置
            weakSelf.statusId =0;
            weakSelf.pageIdx =1;
            weakSelf.materialInfoStr =@"";
            weakSelf.materialNameStr =@"";
            weakSelf.materialNumberStr =@"";
            weakSelf.beginStr =@"";
            weakSelf.endStr =@"";
            [weakSelf.datasource removeAllObjects];
            [weakSelf getIQCTaskListWithType:[NSString stringWithFormat:@"%ld",weakSelf.segmentSelectedIdx] numberStr:@"" nameStr:@"" infoStr:@"" status:0];
        }
       
    };
    
 //待检测 已检测 已完成
    headView.segmentBlock = ^(NSInteger flag,DropDownMenuView * _Nonnull menuView) {
        //清空数据源
        if (weakSelf.datasource.count >0) {
            [weakSelf.datasource removeAllObjects];
        }
       //segment
       //已完成 隐藏状态
//        if (flag  ==2) {
//            [UIView animateWithDuration:0.5 animations:^{
//                menuView.hidden =YES;
//            }];
//        }else{
//            [UIView animateWithDuration:0.5 animations:^{
//                menuView.hidden =NO;
//            }];
//        }
        weakSelf.segmentSelectedIdx  =flag;
        [weakSelf getIQCTaskListWithType:[NSString stringWithFormat:@"%ld",flag] numberStr:@"" nameStr:@"" infoStr:@"" status:0];
    };
  
    //状态
    headView.menuViewBlock = ^(NSInteger selectedId) {
        weakSelf.statusId  = selectedId;
        [weakSelf.datasource removeAllObjects];
        weakSelf.pageIdx =1;
        [weakSelf getIQCTaskListWithType:[NSString stringWithFormat:@"%ld",weakSelf.segmentSelectedIdx] numberStr:weakSelf.materialNumberStr nameStr:weakSelf.materialNameStr infoStr:weakSelf.materialInfoStr status:weakSelf.statusId];
        
    };
    
    //选择日期
    headView.dateFilterBlock = ^(NSString * _Nonnull beginStr, NSString * _Nonnull endStr) {
       //先清空原来的数据
        [weakSelf.datasource removeAllObjects];
        weakSelf.beginStr  =beginStr;
        weakSelf.endStr =endStr;
        [weakSelf getIQCTaskListWithType:[NSString stringWithFormat:@"%ld",weakSelf.segmentSelectedIdx] numberStr:weakSelf.materialNumberStr nameStr:weakSelf.materialNameStr infoStr:weakSelf.materialInfoStr status:weakSelf.statusId];
    };
 //   [self getIQCTaskListWithType:[NSString stringWithFormat:@"%d",0] numberStr:@"" nameStr:@"" infoStr:@"" status:0];
    [self getFactory];
    
    self.tableView.mj_footer  =[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageIdx ++;
        [weakSelf getIQCTaskListWithType:[NSString stringWithFormat:@"%ld",weakSelf.segmentSelectedIdx] numberStr:weakSelf.materialNumberStr nameStr:weakSelf.materialNameStr infoStr:weakSelf.materialInfoStr status:weakSelf.statusId];
    }];
    
    //工厂
    UIButton * sender  =[UIButton buttonWithType:UIButtonTypeCustom];
    [sender setImage:[UIImage imageNamed:@"jurassic_factory"] forState:UIControlStateNormal];
    sender.frame  = CGRectMake(0, 0, 80, 40);
    [sender addTarget:self action:@selector(getFactory:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem =[[UIBarButtonItem alloc]initWithCustomView:sender];
    self.navigationItem.rightBarButtonItem  =rightItem;
    
    //获取主页数据之前 先获取用户所在的工厂, 根据工厂过滤数据
    
    
    
    
}


//获取工厂
-(void)getFactory:(UIButton*)sender{
    if (self.fNameList.count  ==0) {
        [Units showErrorStatusWithString:@"用户没有所在工厂"];
        return;
    }
    
    //创建下拉框
    [YBPopupMenu showRelyOnView:sender titles:self.fNameList icons:nil menuWidth:140 otherSettings:^(YBPopupMenu *popupMenu) {
            popupMenu.dismissOnSelected = NO;
            popupMenu.isShowShadow = YES;
            popupMenu.delegate = self;
            popupMenu.offset = 10;
            popupMenu.type = YBPopupMenuTypeDark;
            popupMenu.backColor = [UIColor whiteColor];
            popupMenu.textColor = [UIColor blackColor];
            popupMenu.maxVisibleCount =10;
            popupMenu.tag  =99999;
            popupMenu.rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
        }];
    
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
   // return 2;
    
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QCTaskListTableCell * cell  =[tableView dequeueReusableCellWithIdentifier:taskListReusedidtifire];

    IQCListModel * model  = self.datasource[indexPath.row];
    [cell setupQCTaskListCellWithModel:model number:[NSString stringWithFormat:@"%ld",indexPath.row+1]];
    
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    QCTaskListCollectionHeadView *headView  =[[QCTaskListCollectionHeadView alloc]init];
    
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    IQCListModel * model  =self.datasource[indexPath.row];
    return model.cellHeight;
 //   return 60;
    
   
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footView  =[[UIView alloc]init];
    footView.backgroundColor  = [UIColor whiteColor];
    
    
    return footView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    //////图标数组
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MenuView.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error;
    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    IQCListModel * model  = self.datasource[indexPath.row];
    
    QCTaskListTableCell * cell  =[tableView cellForRowAtIndexPath:indexPath];

    [cell configureCellWithIsSelected:true];
    if (self.segmentSelectedIdx ==0 ||self.segmentSelectedIdx ==1) {
        
        
        
        if (_segmentSelectedIdx ==0 ) {
           //遍历RightList 查看用户是否有通过权限 单状态为待检验 CanPass 不为0
            [self.rightArray removeAllObjects];
            for (NSDictionary * dict in self.rightList) {
                if ([[dict objectForKey:@"RtName"] isEqualToString:@"通过"] &&[model.Status isEqualToString:@"1"] && ![model.CanPass isEqualToString:@"0"]) {
                    for (NSDictionary *menuDict in dataArray) {
                        NSString *menuStr  = [menuDict objectForKey:@"name"];
                        if ([menuStr isEqualToString:@"紧急通过"]) {
                            if (![self.rightArray containsObject:menuDict]) {
                                [self.rightArray addObject:menuDict];
                            }
                        }
                    }
                   
                }else if ([[dict objectForKey:@"RtName"] isEqualToString:@"通过"] &&[model.Status isEqualToString:@"1"] &&[model.IsUrgentPass isEqualToString:@"0"]){
                    for (NSDictionary *menuDict in dataArray) {
                        NSString *menuStr  =[menuDict objectForKey:@"name"];
                        if ([menuStr isEqualToString:@"IQC退回"]) {
                            if (![self.rightArray containsObject:menuDict]) {
                                [self.rightArray addObject:menuDict];
                            }
                        }
                    }
                }
            }
            for (NSDictionary *menuDict in dataArray) {
                NSString *menuStr  = [menuDict objectForKey:@"name"];
                if ([menuStr isEqualToString:@"查看"]||[menuStr isEqualToString:@"录入检验结果"]) {
                    if (![self.rightArray containsObject:menuDict]) {
                        [self.rightArray addObject:menuDict];
                    }
                }
            }

        }else if (_segmentSelectedIdx ==1){
            [self.rightArray removeAllObjects];
            if ([model.Status isEqualToString:@"5"]) {
                //遍历RIghtList 是否有审核权限
                for (NSDictionary *rightDict in self.rightList) {
                    if ([[rightDict objectForKey:@"RtName"] isEqualToString:@"审核"]) {
                        for (NSDictionary *menuDict in dataArray) {
                            if ([[menuDict objectForKey:@"name"] isEqualToString:@"IQC审核"]) {
                                if (![self.rightArray containsObject:menuDict]) {
                                    [self.rightArray addObject:menuDict];
                                }
                            }
                        }
                    }
                }
            }
            if (![model.Status isEqualToString:@"3"]&&![model.Status isEqualToString:@"5"]) {
               
                for (NSDictionary *menuDict in dataArray) {
                    if ([[menuDict objectForKey:@"name"] isEqualToString:@"录入检验结果"]) {
                        if (![self.rightArray containsObject:menuDict]) {
                            [self.rightArray addObject:menuDict];
                        }
                    }
                }
            }
            for (NSDictionary *menuDict in dataArray) {
                if ([[menuDict objectForKey:@"name"] isEqualToString:@"查看"]) {
                    if (![self.rightArray containsObject:menuDict]) {
                        [self.rightArray addObject:menuDict];
                    }
                }else if ([[menuDict objectForKey:@"name"] isEqualToString:@"预览报告"]){
                    if(![self.rightArray containsObject:menuDict]){
                        [self.rightArray addObject:menuDict];
                    }
                }
            }
            //添加编辑功能
            for (NSDictionary *menuDict in dataArray) {
                if ([[menuDict objectForKey:@"name"] isEqualToString:@"编辑"]) {
                    if (![self.rightArray containsObject:menuDict]) {
                        [self.rightArray addObject:menuDict];
                    }
                }
            }
            
            
        }
        else{
            [self.rightArray removeAllObjects];
            for (NSDictionary *menuDict in dataArray) {
                if ([[menuDict objectForKey:@"name"] isEqualToString:@"查看"]) {
                    if (![self.rightArray containsObject:menuDict]) {
                        [self.rightArray addObject:menuDict];
                    }
                }
            }

        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [YBPopupMenu showRelyOnView:cell titles:[self getMenuList] icons:[self getIconList] menuWidth:170 otherSettings:^(YBPopupMenu *popupMenu) {
                popupMenu.dismissOnSelected = NO;
                popupMenu.isShowShadow = YES;
                popupMenu.delegate = self;
                popupMenu.offset = 10;
                popupMenu.type = YBPopupMenuTypeDefault;
                popupMenu.itemHeight  =48;
                popupMenu.tag  =indexPath.row;
                popupMenu.rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            }];
        });

           
    }else{
        //添加查看和预览报告
        for (NSDictionary *menuDict in dataArray) {
            if ([[menuDict objectForKey:@"name"] isEqualToString:@"查看"]) {
                if (![self.rightArray containsObject:menuDict]) {
                    [self.rightArray addObject:menuDict];
                }
            }else if ([[menuDict objectForKey:@"name"] isEqualToString:@"预览报告"]){
                if(![self.rightArray containsObject:menuDict]){
                    [self.rightArray addObject:menuDict];
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [YBPopupMenu showRelyOnView:cell titles:[self getMenuList] icons:[self getIconList] menuWidth:170 otherSettings:^(YBPopupMenu *popupMenu) {
                popupMenu.dismissOnSelected = NO;
                popupMenu.isShowShadow = YES;
                popupMenu.delegate = self;
                popupMenu.offset = 10;
                popupMenu.type = YBPopupMenuTypeDefault;
                popupMenu.itemHeight  =48;
                popupMenu.tag  =indexPath.row;
                popupMenu.rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            }];
        });
        
//        IQCListModel *model  =self.datasource[indexPath.row];
//        IQCSubmitPageController * controller =[[IQCSubmitPageController alloc]init];
//        controller.itemId  =model.Id;
//        controller.listModel  =model;
//        [self.navigationController pushViewController:controller animated:YES];
        
        
    }
    
}

//下拉选项文字
-(NSMutableArray*)getMenuList{
    NSMutableArray *menuList  = [NSMutableArray array];
    [menuList removeAllObjects];
    for (NSDictionary *dict in self.rightArray) {
        [menuList addObject:dict[@"name"]];
    }
    return menuList;
}

//图标
-(NSMutableArray*)getIconList{
    NSMutableArray * icons  =[NSMutableArray array];
    [icons removeAllObjects];
    for (NSDictionary *dict in self.rightArray) {
        [icons addObject:dict[@"icon"]];
    }
    return icons;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(QCTaskListTableCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell configureCellWithIsSelected:false];
}

-(void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu{
    
    //判断下
    if (ybPopupMenu.tag ==99999) {
        //选择工厂
        self.selectedFId  = [NSString stringWithFormat:@"-1,0,%@",self.fIdList[index]];
        [ybPopupMenu dismiss];
        [self getIQCTaskListWithType:[NSString stringWithFormat:@"%ld",self.segmentSelectedIdx] numberStr:self.materialNumberStr nameStr:self.materialNameStr infoStr:self.materialInfoStr status:self.statusId];
        return;
        
    }
    IQCListModel * model  =self.datasource[ybPopupMenu.tag];
    NSString * selectStr  = [self.rightArray[index] objectForKey:@"name"];
    if ([selectStr isEqualToString:@"IQC退回"]) {
        if ([model.Status isEqualToString:@"1"]||[model.Status isEqualToString:@"5"]) {
            [self returnIQCWithId:model.Id];
        }
        
    }else if ([selectStr isEqualToString:@"紧急通过"]){
        if ([model.Status isEqualToString:@"1"]&&![model.CanPass isEqualToString:@"0"]) {
            [self IsUrgentPassWithTaskId:model.Id];
        }
        
    }else if ([selectStr isEqualToString:@"录入检验结果"]){
        IQCSubmitPageController * controller =[[IQCSubmitPageController alloc]init];
        controller.itemId  =model.Id;
        controller.listModel  =model;
        model.operationTypeStr  =selectStr;
        controller.operationTypeStr  =selectStr;
        [self.navigationController  pushViewController:controller animated:YES];
        KWeakSelf
        controller.submitSucessBlock = ^{
            [weakSelf.datasource removeAllObjects];
            [weakSelf getIQCTaskListWithType:[NSString stringWithFormat:@"%ld",weakSelf.segmentSelectedIdx] numberStr:weakSelf.materialNumberStr nameStr:weakSelf.materialNameStr infoStr:weakSelf.materialInfoStr status:weakSelf.statusId];
        };
    }else if ([selectStr isEqualToString:@"编辑"]){
        IQCSubmitPageController * controller =[[IQCSubmitPageController alloc]init];
        controller.itemId  =model.Id;
        controller.listModel  =model;
        model.operationTypeStr  =selectStr;
        controller.operationTypeStr  =selectStr;
        [self.navigationController  pushViewController:controller animated:YES];
    }
    else if ([selectStr isEqualToString:@"查看"]){
        IQCSubmitPageController * controller =[[IQCSubmitPageController alloc]init];
        controller.itemId  =model.Id;
        controller.listModel  =model;
        [self.navigationController  pushViewController:controller animated:YES];
    }else if ([selectStr isEqualToString:@"IQC审核"]){
        IQCAuditController *controller  =[[IQCAuditController alloc]init];
        controller.mainListModel  =model;
        [self.navigationController pushViewController:controller animated:YES];
        KWeakSelf
        controller.networkSuncessBlock = ^{
            [weakSelf getIQCTaskListWithType:[NSString stringWithFormat:@"%ld",weakSelf.segmentSelectedIdx] numberStr:weakSelf.materialNumberStr nameStr:weakSelf.materialNameStr infoStr:weakSelf.materialInfoStr status:weakSelf.statusId];
            [weakSelf.datasource removeAllObjects];
        };
    }else if ([selectStr isEqualToString:@"预览报告"]){
        [self getFilePath:model.Id];

    }
   
    
    [ybPopupMenu dismiss];
}

//紧急通过
-(void)IsUrgentPassWithTaskId:(NSString*)taskId{
    UIAlertController * alertController  =[UIAlertController alertControllerWithTitle:@"提示" message:@"此条检验单是否紧急通过检验?" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString * url =@"qc/iqctask/pass";
        NSDictionary * taskDict  =@{@"Id":taskId};
        
        //检验任务数组
        NSMutableArray * taskArray  =[NSMutableArray array];
        [taskArray removeAllObjects];
        [taskArray addObject:taskDict];
        
        
        NSMutableDictionary * endParms  =[NSMutableDictionary dictionary];
        [endParms setObject:[Units arrayToJson:taskArray] forKey:@"taskList"];
        
        [Units showLoadStatusWithString:Loading];
        KWeakSelf
        [HttpTool POST:[url getWholeUrl] param:endParms success:^(id  _Nonnull responseObject) {
            [Units hideView];
            [Units showStatusWithStutas:responseObject[@"info"]];
            if ([[responseObject objectForKey:@"status"]intValue]==0) {
                [weakSelf.datasource removeAllObjects];
                [weakSelf getIQCTaskListWithType:[NSString stringWithFormat:@"%ld",weakSelf.segmentSelectedIdx] numberStr:weakSelf.materialNumberStr nameStr:weakSelf.materialNameStr infoStr:weakSelf.materialInfoStr status:weakSelf.statusId];
            }
            
        } error:^(NSString * _Nonnull error) {
            [Units hideView];
            [Units showStatusWithStutas:error];
        }];
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

//退回

-(void)returnIQCWithId:(NSString*)taskId{
    UIAlertController * alertController =[UIAlertController alertControllerWithTitle:@"IQC退回" message:@"是否退回" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder =@"退回原因必填";
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
     UITextField *textfield  =[alertController.textFields firstObject];
        if (textfield.text.length  ==0) {
            [Units showErrorStatusWithString:@"退回原因必填"];
            return;
        }
        NSDictionary * dict =@{@"Id":taskId};
        NSMutableArray * taskList =[NSMutableArray array];
        [taskList removeAllObjects];
        [taskList addObject:dict];
        NSMutableDictionary * totalParms  =[NSMutableDictionary dictionary];
        [totalParms setObject:[Units arrayToJson:taskList] forKey:@"taskList"];
        [totalParms setObject:textfield.text forKey:@"reason"];
        NSString * url =@"qc/iqctask/returnIqc";
        [Units showLoadStatusWithString:Loading];
        KWeakSelf
        [HttpTool POST:[url getWholeUrl] param:totalParms success:^(id  _Nonnull responseObject) {
            [Units hideView];
            [Units showStatusWithStutas:responseObject[@"info"]];
            if ([[responseObject objectForKey:@"status"]intValue]==0) {
                [weakSelf.datasource removeAllObjects];
                [weakSelf getIQCTaskListWithType:[NSString stringWithFormat:@"%ld",weakSelf.segmentSelectedIdx] numberStr:weakSelf.materialNumberStr nameStr:weakSelf.materialNameStr infoStr:weakSelf.materialInfoStr status:weakSelf.statusId];
            }
        } error:^(NSString * _Nonnull error) {
            [Units hideView];
            [Units showStatusWithStutas:error];
        }];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    QCTaskListTableCell * cell  =[tableView cellForRowAtIndexPath:indexPath];
 
    [cell configureCellWithIsSelected:false];
}

//获取IQC列表数据
-(void)getIQCTaskListWithType:(NSString*)typeStr numberStr:(NSString*)numberStr nameStr:(NSString*)nameStr infoStr:(NSString*)infoStr status:(NSInteger)status{
    //搜索条件参数
    
    NSDictionary * materialCodeDict  =@{@"Column":@"m.MaterialCode",@"Values":numberStr?:@"",@"Querytype":@"Like"};
    NSDictionary *nameDict  =@{@"Column":@"m.MaterialName",@"Values":nameStr?:@"",@"Querytype":@"Like"};
    NSDictionary *infoDict  =@{@"Column":@"m.MaterialInfo",@"Values":infoStr?:@"",@"Querytype":@"Like"};
   
    NSDictionary *fDict  =@{@"Column":@"ll.FactoryId",@"Values":self.selectedFId,@"Querytype":@"In"};
   
    NSMutableArray * wheresArr  =[NSMutableArray array];
    [wheresArr removeAllObjects];
    [wheresArr addObject:materialCodeDict];
    [wheresArr addObject:nameDict];
    [wheresArr addObject:infoDict];
    [wheresArr addObject:fDict];
    if (self.segmentSelectedIdx ==2 &&self.beginStr.length >0 &&self.endStr.length >0) {
        NSDictionary *beginDic  =@{@"Column":@"ll.IQCOn",@"Values":[Units timeWithTime:self.beginStr beforeFormat:@"yyyy-MM-dd" andAfterFormat:@"yyyy-MM-dd HH:mm:ss"],@"Querytype":@"GreaterEquals"};
        NSDictionary *endDic  =@{@"Column":@"ll.IQCOn",@"Values":[Units timeWithTime:self.endStr beforeFormat:@"yyyy-MM-dd" andAfterFormat:@"yyyy-MM-dd HH:mm:ss"],@"Querytype":@"LessEquals"};
        [wheresArr addObject:beginDic];
        [wheresArr addObject:endDic];
        
    }
    
    
    
    NSMutableDictionary * endParms  =[NSMutableDictionary dictionary];
    if (self.segmentSelectedIdx  == 0 || self.segmentSelectedIdx ==1) {
        [endParms setObject:@(1) forKey:@"pageIndex"];
        [endParms setObject:@(100) forKey:@"pageSize"];
        if (self.statusId !=0) {
            NSDictionary * statusDict =@{@"Column":@"ll.Status",@"Values":@(self.statusId),@"Querytype":@"Equels"};
             [wheresArr addObject:statusDict];
        }
     
      
    }else{
        [endParms setObject:[NSString stringWithFormat:@"%ld",self.pageIdx] forKey:@"pageIndex"];
        [endParms setObject:[NSString stringWithFormat:@"%d",30] forKey:@"pageSize"];
        if (self.statusId !=0) {
            NSDictionary * statusDict  =@{@"Column":@"ll.Status",@"Values":@(self.statusId),@"Querytype":@"Equels"};
              [wheresArr addObject:statusDict];
        }
      //  NSDictionary * statusDict  =@{@"Column":@"ll.Status",@"Values":@"",@"Querytype":@"Equels"};
  //      [wheresArr addObject:statusDict];
    }
    NSString * whereString  = [Units arrayToJson:wheresArr];
    [endParms setObject:whereString forKey:@"wheres"];
    
    [endParms setObject:typeStr forKey:@"type"];
    
    
    NSString * url  =@"qc/iqctask/getPadList";
    
    KWeakSelf
    [Units showLoadStatusWithString:Loading];
    
    [HttpTool POST:[url getWholeUrl] param:endParms success:^(NSMutableDictionary*  _Nonnull responseObject) {
        [Units hideView];
       
        if ([[responseObject objectForKey:@"status"]intValue]==0) {
            NSDictionary * dataDict  =[Units jsonToDictionary:responseObject[@"data"]];
            NSArray * dataArray  =[dataDict objectForKey:@"list"];
            debugLog(@"= = =%ld",dataArray.count);
            NSMutableArray *jsonList  =  [IQCListModel mj_objectArrayWithKeyValuesArray:dataArray];
            if (weakSelf.pageIdx <[[dataDict objectForKey:@"totalPage"] intValue]) {
                [weakSelf.tableView.mj_footer endRefreshing];
                
            }else{
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            if (weakSelf.segmentSelectedIdx ==0 || weakSelf.segmentSelectedIdx ==1) {
                [weakSelf.datasource removeAllObjects];
            }
            for (IQCListModel *model in jsonList) {
                if (weakSelf.segmentSelectedIdx ==0 ||weakSelf.segmentSelectedIdx ==1) {
                    
                    [weakSelf.datasource addObject:model];
                }else{
                    if (![weakSelf.datasource containsObject:model]) {
                        [weakSelf.datasource addObject:model];
                    }
                }
               
            }

        }
        debugLog(@"= = == = = = %@",responseObject);
        [weakSelf.tableView reloadData];
        
        
    } error:^(NSString * _Nonnull error) {
        [Units hideView];
        [weakSelf.tableView.mj_footer endRefreshing];
        [Units showHudWithText:error view:weakSelf.view model:MBProgressHUDModeIndeterminate];
       
    }];
}


-(void)getFilePath:(NSString *)fItemID{
    NSString *url =@"mk/file/getUpLoadFileByfItemID";
    NSMutableDictionary *parms =[NSMutableDictionary dictionary];
    [parms setObject:fItemID forKey:@"fItemID"];
    [parms setObject:@"161" forKey:@"type"];
    
    
    KWeakSelf
    [Units showLoadStatusWithString:Loading];
    [HttpTool POST:[url getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hideView];
        if([[responseObject objectForKey:@"status"]intValue]==0){
            NSArray *jsonArray = [Units jsonToArray:responseObject[@"data"]];
            NSMutableArray *modelArray =[IQCFileModel mj_objectArrayWithKeyValuesArray:jsonArray];
            if(modelArray.count >0){
             
                IQCFileModel *model  =modelArray.firstObject;
                
                IQCReportViewController *controller  =[[IQCReportViewController alloc]init];
                controller.httpPath =model.FilePath;
                [weakSelf.navigationController pushViewController:controller animated:YES];
            }else{
                [Units showStatusWithStutas:@"此任务单号还没有生成检测报告,无法查看!!!"];
            }
        }
    } error:^(NSString * _Nonnull error) {
        [Units hideView];
        [Units showHudWithText:error view:weakSelf.view model:MBProgressHUDModeIndeterminate];
    }];
        
       
    
}

-(NSMutableArray*)rightArray{
    if (!_rightArray) {
        _rightArray  =[NSMutableArray array];
        
//        for (NSDictionary *dict in _rightList) {
//            if ([dict[@"RtName"] isEqualToString:@"通过"]) {
//                [_rightArray addObject:@"紧急通过"];
//            }else if ([dict[@"RtName"] isEqualToString:@"审核"]){
//                [_rightArray addObject:@"IQC退回"];
//            }
//        }
//        [_rightArray addObject:@"录入检验结果"];
    }
    return _rightArray;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

-(NSMutableArray*)fIdList{
    if (!_fIdList) {
        _fIdList  =[NSMutableArray array];
    }
    return _fIdList;
}

-(NSMutableArray*)fNameList{
    if (!_fNameList) {
        _fNameList  =[NSMutableArray array];
    }
    return _fNameList;
}

@end
