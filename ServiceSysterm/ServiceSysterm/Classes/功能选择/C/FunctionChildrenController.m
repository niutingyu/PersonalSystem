//
//  FunctionChildrenController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/4/24.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "FunctionChildrenController.h"
#import "FCItemCollectionViewCell.h"
#import "MainTabbarController.h"
#import "FactoryTabbarController.h"
#import "DeviceRepairTabController.h"
#import "DeviceRepairChosItemController.h"
#import "DeviceNavController.h"
#import "MoudleModel.h"
#import "FactoryModel.h"
#import "DeviceModel.h"

#import "MaintainResumeHomeController.h"
@interface FunctionChildrenController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView * collectionView;

@property (nonatomic,strong)NSMutableArray *imageArray;

@property (nonatomic,strong)NSMutableArray * mouleIdArray;



@end

static NSString * const collectionReusedID = @"collectionReusedID";

@implementation FunctionChildrenController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.collectionView];
    //页面刚开始展示收藏夹s内容
    self.datasource = self.favirivateArray;
    self.mouleIdArray = self.faviriteIdArray;
    [self.collectionView reloadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getMoudleName:) name:@"moudleName" object:nil];
}

-(void)getMoudleName:(NSNotification*)notification{
    NSDictionary * dict = [notification object];
    self.datasource = dict[@"itemKey"];
    self.mouleIdArray = dict[@"itemIdKey"];
   
    
    [self.collectionView reloadData];
}
-(UICollectionView*)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing =1;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        // _collectionView.backgroundColor = RGBA(242, 242, 242, 1);
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _collectionView.alwaysBounceVertical = YES;
        
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FCItemCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:collectionReusedID];
    }
    return _collectionView;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 返回在一个给定section里的cell数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FCItemCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionReusedID forIndexPath:indexPath];
    cell.contentView.layer.cornerRadius = 2.0f;
    cell.contentView.layer.borderWidth = 1.0f;
    cell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
    cell.contentView.layer.masksToBounds = YES;
    
    cell.layer.shadowColor = RGBA(242, 242, 242, 1).CGColor;
    cell.layer.shadowOffset = CGSizeMake(1, 1.0f);
    cell.layer.shadowRadius = 2.0f;
    cell.layer.shadowOpacity = 1.0f;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
    cell.tipLabel.text = self.datasource[indexPath.item];
    
    cell.tipIcon.image = [UIImage imageNamed:self.imageArray[indexPath.item]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake((kScreenWidth-8.6)/3, 96);
    return size;
}

// 定义section的边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8, 4, 8, 4);
    // UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
    
}

// 定义上下cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.25;
}

// 定义左右cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.25;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString * titleStr = self.datasource[indexPath.item];

   
  
   //请求网络
    
    NSKeyedUnarchiver * modleArchiver = [Units readDateFromDiskWithPathStr:@"functionModel"];
    MoudleModel * moudleStatus = [modleArchiver decodeObjectForKey:Function_WriteDisk];
    [modleArchiver finishDecoding];
    
    if ([titleStr isEqualToString:@"设备履历查询"]) {
        [self.navigationController pushViewController:[MaintainResumeHomeController new] animated:YES];
    }
    if ([titleStr isEqualToString:@"维修工具管理"]) {
        DeviceRepairChosItemController * controller = [[DeviceRepairChosItemController alloc]init];
        controller.typeController = titleStr;
        NSString * typeStr =nil;
        for (NSDictionary * dict in moudleStatus.ModulesList) {
            if ([[dict objectForKey:@"ModuleName"]isEqualToString:@"维修工具管理"]) {
                typeStr = dict[@"ModuleType"];
            }
        }
        controller.maintainToolType = typeStr;
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    
    NSDictionary * MsgDict = moudleStatus.BaseMsg;
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    [parms setObject:MsgDict[@"UserId"] forKey:@"UserId"];
    [parms setObject:self.mouleIdArray[indexPath.item] forKey:@"ModuleId"];
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    KWeakSelf
    [HttpTool POST:[ChoseMoudleURL getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:weakSelf.view];
        if ([[responseObject objectForKey:@"status"]integerValue]== 0) {
            NSDictionary * responDict = [Units jsonToDictionary:responseObject[@"data"]];
           
            NSMutableArray * arr = [DeviceModel mj_objectArrayWithKeyValuesArray:responDict[@"RightsList"]];
            if (arr.count >0) {

                DeviceRepairChosItemController * controller = [[DeviceRepairChosItemController alloc]init];
                controller.moudleArray = arr;
                controller.typeController = titleStr;
                [weakSelf.navigationController pushViewController:controller animated:YES];
                
            }else{
                [Units showErrorStatusWithString:responseObject[@"info"]];
            }
        }
        debugLog(@" - - -%@" ,responseObject);
    } error:^(NSString * _Nonnull error) {
        debugLog(@"error = %@",error);
        [Units showErrorStatusWithString:error];
        [Units hiddenHudWithView:weakSelf.view];
    }];
    
    
}

-(void)jumpIntoController:(UIViewController*)controller moudleId:(NSString*)moudleId{
   //获取权限
    
    if ([moudleId isEqualToString:@"设备维修"]) {
        controller =[DeviceRepairChosItemController new];
    }
   
    
    
}
-(NSMutableArray*)imageArray{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
        NSArray * arr =@[@"auth_icon_manage_member",@"chat_btn_action_favorite",@"chat_btn_action_filebox",@"chat_btn_action_location",@"jiakao__ic_keer_xuayuanfuli_44x44_",@"spotlight_ding",@"auth_icon_manage_member",@"chat_btn_action_favorite",@"chat_btn_action_location",@"auth_icon_manage_member",@"jiakao__ic_keer_xuayuanfuli_44x44_",@"auth_icon_manage_member",@"chat_btn_action_favorite",@"auth_icon_manage_member",@"jiakao__ic_keer_xuayuanfuli_44x44_",@"auth_icon_manage_member"];
        [_imageArray addObjectsFromArray:arr];
    }
    return _imageArray;
}

-(NSMutableArray*)mouleIdArray{
    if (!_mouleIdArray) {
        _mouleIdArray = [NSMutableArray array];
    }
    return _mouleIdArray;
}
@end
