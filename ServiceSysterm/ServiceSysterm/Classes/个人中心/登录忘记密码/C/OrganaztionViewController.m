//
//  OrganaztionViewController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/29.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "OrganaztionViewController.h"
#import "DepartmentLayout.h"
#import "DepartmentCollectionCell.h"
#import "MemberModel.h"
@interface OrganaztionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong) UICollectionView *showCollectionView;
@property (nonatomic,strong)NSMutableArray * peopleListArray;

@end

@implementation OrganaztionViewController
-(NSMutableArray*)peopleListArray{
    if (!_peopleListArray) {
        _peopleListArray =[NSMutableArray array];
    }return _peopleListArray;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden =YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden =NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.showCollectionView];
    [self getMessage];
}

#pragma mark - set/get
- (UICollectionView *)showCollectionView {
    
    if (!_showCollectionView) {
        DepartmentLayout *layout = [[DepartmentLayout alloc]init];
        _showCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
       
        _showCollectionView.delegate = self;
        _showCollectionView.dataSource = self;
        [_showCollectionView registerClass:[DepartmentCollectionCell class] forCellWithReuseIdentifier:@"CellId"];
        _showCollectionView.pagingEnabled = YES;
        UIImageView * backView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg.jpg"]];
        backView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _showCollectionView.backgroundView =backView;
        _showCollectionView.showsHorizontalScrollIndicator = NO;
    }
    return _showCollectionView;
}
#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   
    return self.datasource.count?:1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DepartmentCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellId" forIndexPath:indexPath];
    cell.departmentTextField.delegate =self;
    cell.jobTextField.delegate =self;
    cell.nameTextField.delegate =self;
    if (self.datasource.count) {
        MemberModel *model = self.datasource[indexPath.item];
        [cell cofigureCell:self.datasource itemIdx:indexPath.item model:model];
    }else{
        [cell congiureCell];
    }
   
    
   
    KWeakSelf
    cell.backBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    return cell;
}
// 当点击键盘的返回键（右下角）时，执行该方法。
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    textField.returnKeyType = UIReturnKeySearch;
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
     NSMutableArray * totalArray =[NSMutableArray array];
    if (textField.tag ==100) {
        //部门搜索
        if (textField.text.length) {
            [totalArray removeAllObjects];
            for (MemberModel*model in self.peopleListArray) {
                if ([model.DepName containsString:textField.text]) {
                    [totalArray addObject:model];
                }
            }
        }
    }else if (textField.tag ==101){
       //工号搜索
        if (textField.text.length) {
            [totalArray removeAllObjects];
            for (MemberModel *model in self.peopleListArray) {
                for (NSDictionary *peopleDict in model.PepList) {
                    if ([peopleDict[@"UserName"] containsString:textField.text]) {
                        [totalArray addObject:model];
                    }
                }
            }
        }
    }else{
      //姓名搜索
        if (textField.text.length) {
            [totalArray removeAllObjects];
            for (MemberModel *model in self.peopleListArray) {
                for (NSDictionary *nameDict in model.PepList) {
                    if ([nameDict[@"FName"]containsObject:textField.text]) {
                        [totalArray addObject:model];
                    }
                }
            }
        }
    }
    
    [self.datasource removeAllObjects];
    [self.datasource addObjectsFromArray:totalArray];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.showCollectionView reloadData];
    });
    debugLog(@" = == %ld",textField.tag);
    return YES;
}
-(void)getMessage{
    NSMutableDictionary *params =[NSMutableDictionary dictionary];
    [params setObject:@"123" forKey:@"keyType"];
    KWeakSelf
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    [HttpTool POST:[MemberURL getWholeUrl] param:params success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:weakSelf.view];
        if ([[responseObject objectForKey:@"status"]integerValue]== 0) {
            NSArray * arr = [Units jsonToArray:responseObject[@"data"]];
            NSMutableArray * arr1 =[MemberModel mj_objectArrayWithKeyValuesArray:arr];
            [weakSelf.datasource addObjectsFromArray:arr1];
            [weakSelf.peopleListArray addObjectsFromArray:arr1];
    
        }
        [weakSelf.showCollectionView reloadData];
    } error:^(NSString * _Nonnull error) {
        [Units showErrorStatusWithString:error];
        [Units hiddenHudWithView:weakSelf.view];
    }];
}
@end
