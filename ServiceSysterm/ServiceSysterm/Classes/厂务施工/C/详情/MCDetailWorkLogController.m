//
//  MCDetailWorkLogController.m
//  ServiceSysterm
//
//  Created by Andy on 2020/10/31.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "MCDetailWorkLogController.h"
#import "MCOperateRemarkTableCell.h"
@interface MCDetailWorkLogController ()

@property (nonatomic,strong)NSMutableDictionary *contentDictionary;

@property (nonatomic,strong)NSMutableArray * sectionTitles;
@end

@implementation MCDetailWorkLogController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  =[UIColor whiteColor];
    self.title  =@"填写工作日志";
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"MCOperateRemarkTableCell" bundle:nil] forCellReuseIdentifier:@"cell0"];
    
    UIBarButtonItem * right  =[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commitMethod)];
    self.navigationItem.rightBarButtonItem  = right;
    
}


-(void)commitMethod{
    [self.view endEditing:YES];
    NSString * url =@"maint/construstiontask/applyFinish";
    NSString * workLog  =  self.contentDictionary[@"工作日志"];
    NSString * remark  =self.contentDictionary[@"备注"];
    if (workLog.length  ==0) {
        [Units showWarningWithTitle:@"提示" andSubTitle:@"工作日志必填" andView:self.view];
        return;
    }if (remark.length  ==0) {
        [Units showWarningWithTitle:@"提示" andSubTitle:@"备注必填" andView:self.view];
        return;
    }
    
    NSMutableDictionary * parms  =[NSMutableDictionary dictionary];
    [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
    [parms setObject:self.constructionId forKey:@"ConstructionTaskId"];
    [parms setObject:@"1" forKey:@"type"];
    [parms setObject:workLog forKey:@"workLog"];
    [parms setObject:remark forKey:@"operateDescribe"];
    
    
     KWeakSelf
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
   
    [HttpTool POST:[url getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:weakSelf.view];
        [Units showStatusWithStutas:responseObject[@"info"]];
        
        if ([[responseObject objectForKey:@"status"]intValue]==0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
                           
            });
        }
        debugLog(@" = = = =%@",responseObject);
        
    } error:^(NSString * _Nonnull error) {
        [Units hiddenHudWithView:weakSelf.view];
        [Units showErrorStatusWithString:error];
    }];
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MCOperateRemarkTableCell * cell  =[tableView dequeueReusableCellWithIdentifier:@"cell0"];
    
    KWeakSelf
    cell.contentBlock = ^(NSString * _Nonnull text) {
        [weakSelf.contentDictionary setObject:text forKey:self.sectionTitles[indexPath.section]];
        
    };
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return self.sectionTitles[section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0f;
}

-(NSMutableDictionary*)contentDictionary{
    if (!_contentDictionary) {
        _contentDictionary  =[NSMutableDictionary dictionary];
    }return _contentDictionary;
}

-(NSMutableArray*)sectionTitles{
    if (!_sectionTitles) {
        _sectionTitles =[NSMutableArray array];
        NSArray * arr  = @[@"工作日志",@"备注"];
        [_sectionTitles addObjectsFromArray:arr];
    }
    return _sectionTitles;
}
@end
