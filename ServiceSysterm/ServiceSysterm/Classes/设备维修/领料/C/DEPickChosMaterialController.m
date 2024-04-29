//
//  DEPickChosMaterialController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/8.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEPickChosMaterialController.h"
#import "DEPickChosMaterialTableCell.h"
#import "DESearchView.h"
#import "DEPickChosMaterialModel.h"

#import "DEChosMaterialSearchView.h"
#import <IQKeyboardManager.h>
@interface DEPickChosMaterialController ()
{
    NSString * _condition;
    NSString * _materialType;
    NSString * _materialName;
    NSString *_materialCode;
    BOOL _isClick;//是否点击
    
}
@property (nonatomic,strong)UIView * searchBottomView;
@property (nonatomic,strong)NSMutableDictionary * selectedDictionary;
@property (nonatomic,strong)NSMutableArray * filterArray;
@end

@implementation DEPickChosMaterialController


-(NSMutableDictionary*)selectedDictionary{
    if (!_selectedDictionary) {
        _selectedDictionary = [NSMutableDictionary dictionary];
    }
    return _selectedDictionary;
}
-(NSMutableArray*)filterArray{
    if (!_filterArray) {
        _filterArray =[NSMutableArray array];
    }return _filterArray;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager]setEnable:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager]setEnable:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择物料";
    
    //确定选择
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"确定选择" style:UIBarButtonItemStylePlain target:self action:@selector(sureChos)];
    self.navigationItem.leftBarButtonItem = rightItem;
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 140)];
    self.searchBottomView = bottomView;
    [self.view addSubview:bottomView];
    DEChosMaterialSearchView * searchView  =[[NSBundle mainBundle]loadNibNamed:@"DEChosMaterialSearchView" owner:self options:nil].firstObject;
    searchView.frame = CGRectMake(0, 0, bottomView.frame.size.width, 140);
    [bottomView addSubview:searchView];
    
    KWeakSelf
    searchView.searchBlock = ^(NSString * _Nonnull materialInfo, NSString * _Nonnull materialName, NSString * _Nonnull materialCode) {
        if (materialInfo.length ==0 &&materialName.length ==0 &&materialCode.length ==0) {
            [Units showErrorStatusWithString:@"关键词不能为空"];
            return ;
        }
        self->_materialCode =materialCode;
        self->_materialName =materialName;
        self->_materialType =materialInfo;
        [weakSelf loadMaterialMessage];
    };
//    NSArray * placeholds = @[@"请输入物料规格",@"请输入物料名称",@"请输入物料编码"];
//    for (int i =0; i<3; i++) {
//        DESearchView * searchView = [[NSBundle mainBundle]loadNibNamed:@"DESearchView" owner:nil options:nil].firstObject;
//        searchView.frame = CGRectMake(0, 50*i, kScreenWidth, 50);
//        searchView.searchContentTextField.placeholder = placeholds[i];
//        searchView.searchContentTextField.tag = 1000+i;
//        searchView.searchContentTextField.inputAccessoryView = self.tool;
//        searchView.searchContentTextField.clearsOnBeginEditing = YES;
//        [bottomView addSubview:searchView];
    
       
        
        //搜索
 /*       __block DESearchView * searchV =searchView;;
        searchView.searchBlock = ^{
//            YYCache * cache =[YYCache cacheWithName:DevicePickMaterialURL];
//            id cacheObj = [cache objectForKey:@"pick"];
//            NSArray * cacheArr = (NSArray*)cacheObj;
            [weakSelf.view endEditing:YES];
            if (self->_materialCode.length ==0&&self->_materialType.length==0&&self->_materialName.length ==0) {
                [Units showErrorStatusWithString:@"关键词不能为空"];
                return ;
            }
            NSMutableArray * resultArray = [NSMutableArray array];
            NSString * name =nil;
            for (DEPickChosMaterialModel * model in self.datasource) {
                if (searchV.searchContentTextField.tag == 1000) {
                    name =model.MaterialInfo;
                 self->_condition = self->_materialType ;
            }else if (searchV.searchContentTextField.tag == 1001){
                    name = model.MaterialName;
                 self->_condition =  self->_materialName;
            }else if (searchV.searchContentTextField.tag == 1002){
                    name = model.MaterialCode;
                    self->_condition =  self->_materialCode;
                }
                NSRange range = [name rangeOfString:self->_condition options:NSCaseInsensitiveSearch];
                if (range.location !=NSNotFound) {
                    [resultArray addObject:model];
                }
            }
            weakSelf.datasource = resultArray ;
            [weakSelf.tableView reloadData];
 
        };
    }*/
    
   
  
    
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 70.0f;

    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(bottomView.frame)+5, kScreenWidth, kScreenHeight-140);
    [self.tableView registerNib:[UINib nibWithNibName:@"DEPickChosMaterialTableCell" bundle:nil] forCellReuseIdentifier:@"cellId"];
    [self loadMaterialMessage];
   
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        //刷新数据 请求整个数据
        self->_materialCode = nil;
        self->_materialName = nil;
        self->_materialType = nil;
        
        //刷新移除缓存
//        YYCache * cache = [YYCache cacheWithName:DevicePickMaterialURL];
//        [cache removeObjectForKey:@"pick"];
        [weakSelf loadMaterialMessage];
    }];
    
    // 注册通知
   // [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeText:) name:UITextFieldTextDidChangeNotification object:nil];
    
}

-(void)changeText:(NSNotification*)notification{
    UITextField * textField = [notification object];
    if (textField.tag == 1000) {
        _materialType = textField.text;
        _materialName  =nil;
        _materialCode =nil;
    }else if (textField.tag == 1001){
        _materialName = textField.text;
        _materialType =nil;
        _materialCode =nil;
       
    }else{
        _materialCode = textField.text;
        _materialName =nil;
        _materialType =nil;
      
    }
  

    
  
}

#pragma mark == == == = =确定选择
-(void)sureChos{
    [self.view endEditing:YES];
    //上次选中model 加上新选中model
    NSArray * arr = [self.selectedDictionary allValues];
    for (DEPickChosMaterialModel * model in arr) {
        if (![self.filterArray containsObject:model]) {
            [self.filterArray addObject:model];
        }
    }
    //是否重新了选择 ， 没重新选择就传原来的数据  ，
    if (_isClick == YES) {
        if (self.chosMaterialBlock) {
            self.chosMaterialBlock(self.filterArray);
        }
    }else{
        //没有选择 传原来的值
        
        NSMutableArray * originArray = [NSMutableArray array];
        for (DEPickChosMaterialModel * model in self.selectedMaterialArray) {
            if (![originArray containsObject:model]) {
               [originArray addObject:model];
            }
        }
        if (self.chosMaterialBlock) {
            self.chosMaterialBlock(originArray);
        }
    }
   
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DEPickChosMaterialTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];

    DEPickChosMaterialModel * model = self.datasource[indexPath.row];
    cell.model = model;
    
    NSArray * selectedButtons = [self.selectedDictionary allKeys];
    cell.selectedButton.selected = NO;
    cell.selectedButton.tag = indexPath.row;
  
    //记忆选中 上次选中model，打上选中图标
    for (DEPickChosMaterialModel * model in self.selectedMaterialArray ) {
        if ([model.MaterialInfo isEqualToString:cell.typeLab.text]) {
            cell.selectedButton.selected =YES;
           
        }
    }
    for (NSString * indexpathStr in selectedButtons) {
        if ([indexpathStr isEqualToString:[NSString stringWithFormat:@"%ld",indexPath.row]]) {
            cell.selectedButton.selected = YES;
          
        }
    }
    KWeakSelf
    //选择
    
    cell.selectedBlock = ^(UIButton * sender) {
        self->_isClick = YES;//改变状态
        NSArray * countAll = [self.selectedDictionary allValues];
        if (countAll.count >10) {
            [Units showErrorStatusWithString:@"超过最大数量"];
            return;
        }
         sender.selected =!sender.selected;
        //把传值过来的model添加到fiterarray，最终操作的是filterarray
        for (DEPickChosMaterialModel *model in weakSelf.selectedMaterialArray) {
            if (![weakSelf.filterArray containsObject:model]) {
                [weakSelf.filterArray addObject:model];
            }
        }
        
        if (sender.selected) {
          [weakSelf.selectedDictionary setObject:model forKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
        }else{

            [weakSelf.selectedDictionary removeObjectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
            //把原来传值过来的选中的model去除
            for (DEPickChosMaterialModel * chosModel in weakSelf.selectedMaterialArray) {
                if ([chosModel.MaterialInfo isEqualToString:model.MaterialInfo]) {
                    [weakSelf.filterArray removeObject:chosModel];
                }
            }
        }
    };
    
    return cell;
}

-(void)loadMaterialMessage{
    [self.datasource removeAllObjects];
//    YYCache * cache = [YYCache cacheWithName:DevicePickMaterialURL];
//    id cacheObj = [cache objectForKey:@"pick"];
//    NSArray * cacheArr = (NSArray*)cacheObj;
//    if (cacheArr.count) {
//        [self.datasource addObjectsFromArray:cacheArr];
//        [self.tableView.mj_header endRefreshing];
//        return;
//    }
    
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    [parms setObject:@"True" forKey:@"needlinshi"];
    NSMutableArray * arr = [NSMutableArray array];
    [arr removeAllObjects];
    NSMutableDictionary * childDictionary = [NSMutableDictionary dictionary];
    [childDictionary setObject:@"IsOutward" forKey:@"Column"];
    [childDictionary setObject:@0 forKey:@"Values"];
    NSDictionary *childDictionary1 = @{@"Values":@1};
    
    //
    if (_materialType.length) {
        NSMutableDictionary * childDictionary2 = [NSMutableDictionary dictionary];
        
        [childDictionary2 setObject:_materialType forKey:@"Values"];
        [childDictionary2 setObject:@"MaterialInfo" forKey:@"Column"];
        [arr addObject:childDictionary2];
    }
   
    if (_materialName.length) {
        NSMutableDictionary * childDictionary3 = [NSMutableDictionary dictionary];
        [childDictionary3 setObject:_materialName?:@"" forKey:@"Values"];
        [childDictionary3 setObject:@"MaterialName" forKey:@"Column"];
        [arr addObject:childDictionary3];
    }if (_materialCode.length) {
        NSMutableDictionary * childDictionary4 = [NSMutableDictionary dictionary];
        [childDictionary4 setObject:_materialCode?:@"" forKey:@"Values"];
        [childDictionary4 setObject:@"MaterialCode" forKey:@"Column"];
        [arr addObject:childDictionary4];
    }
   
    
   
    
    [arr addObject:childDictionary];
    [arr addObject:childDictionary1];
    [parms setObject:[Units arrayToJson:arr] forKey:@"wheres"];
   
    [self.datasource removeAllObjects];
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    [HttpTool POST:[DevicePickMaterialURL getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:self.view];
        if ([[responseObject objectForKey:@"status"]integerValue] == 0 ) {
            NSArray * arr = [Units jsonToArray:responseObject[@"data"]];
            NSMutableArray * arr1 = [DEPickChosMaterialModel mj_objectArrayWithKeyValuesArray:arr];
            NSMutableArray * arr2 = [NSMutableArray array];
            for (DEPickChosMaterialModel * model in arr1) {
                if (![model.CountAll isEqualToString:@"0"]) {
                    [arr2 addObject:model];
                }
            }
            NSArray * sortArr = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"CountAll" ascending:NO]];
            
            [self.datasource addObjectsFromArray:[arr2 sortedArrayUsingDescriptors:sortArr ]];
//            YYCache * cache = [YYCache cacheWithName:DevicePickMaterialURL];
//            [cache setObject:self.datasource forKey:@"pick"];
          
            
        }
       
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
       
    } error:^(NSString * _Nonnull error) {
        [Units showErrorStatusWithString:error];
        [Units hiddenHudWithView:self.view];
        [self.tableView.mj_header endRefreshing];
    } ];
    
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
   
    CGPoint point = [scrollView.panGestureRecognizer velocityInView:scrollView];
    CGFloat offsetY = scrollView.contentOffset.y;
    
   
    if (scrollView.contentSize.height >= kScreenHeight){
        [UIView animateWithDuration:.3 animations:^{
            if (offsetY> 0) { // 向上
                self.searchBottomView.frame = CGRectMake(0, 0, kScreenWidth, 140);
               
                
                self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-50-bottomBarHeight);
            }else if (offsetY < 0){
                
                if (point.y  == 0) {
                    self.searchBottomView.frame = CGRectMake(0, 0, kScreenWidth, 140);
                    
                    self.tableView.frame = CGRectMake(0, 145, kScreenWidth, kScreenHeight  - 50 - 50 -40-bottomBarHeight);
                }
                
            }
        }];
    }
}
@end
