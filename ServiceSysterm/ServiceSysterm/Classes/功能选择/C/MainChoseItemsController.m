//
//  MainChoseItemsController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/7/18.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "MainChoseItemsController.h"
#import "FCItemCollectionViewCell.h"
#import "MainHeadReusableView.h"
#import "MainCollectionFlowLayout.h"
#import "MConstructionTabbarController.h"
#import "MaintainResumeHomeController.h"
#import "IQCSubmitPageController.h"
#import "IQCMainController.h"


#import "MoudleModel.h"
#import "MoudleListModel.h"
#import "DeviceModel.h"

#import "DeviceRepairChosItemController.h"
#import "ManagerDeviceTabBarController.h"

@interface MainChoseItemsController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView * collectionView;

@property (nonatomic,strong)NSMutableArray * mouleArray;

@property (nonatomic,strong)NSMutableArray * moudleIdArray;

@property (nonatomic,strong)NSMutableArray *imageArray;
@end

static NSString *const cellReusedId =@"cellId";
static NSString *const reusableViewId =@"reusableId";

@implementation MainChoseItemsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"功能选择";
    self.view.backgroundColor = [UIColor whiteColor];
    self.modalPresentationStyle =UIModalPresentationFullScreen;
    if (!_mouleArray) {
        _mouleArray =[NSMutableArray array];
    }
    if (!_moudleIdArray) {
        _moudleIdArray =[NSMutableArray array];
    }
    [self makeupMessage];
}

-(UICollectionView*)collectionView{
    if (!_collectionView) {
        MainCollectionFlowLayout * layout = [[MainCollectionFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = RGBA(242, 242, 242, 1);
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerNib:[UINib nibWithNibName:@"FCItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellReusedId];
        [_collectionView registerClass:[MainHeadReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reusableViewId];
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo (self.view);
        }];
    }return _collectionView;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 返回在一个给定section里的cell数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mouleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FCItemCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReusedId forIndexPath:indexPath];
//    cell.contentView.layer.cornerRadius = 2.0f;
//    cell.contentView.layer.borderWidth = 1.0f;
//    cell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
//    cell.contentView.layer.masksToBounds = YES;
//
//    cell.layer.shadowColor = RGBA(242, 242, 242, 1).CGColor;
//    cell.layer.shadowOffset = CGSizeMake(1, 1.0f);
//    cell.layer.shadowRadius = 2.0f;
//    cell.layer.shadowOpacity = 1.0f;
//    cell.layer.masksToBounds = NO;
//    cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
    
    cell.tipLabel.text = self.mouleArray[indexPath.item][@"moduleName"];
    cell.tipIcon.image  =[UIImage imageNamed:self.mouleArray[indexPath.item][@"icon"]];
   // cell.tipIcon.image = [UIImage imageNamed:self.imageArray[indexPath.item]];
    return cell;
}

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        MainHeadReusableView * headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reusableViewId forIndexPath:indexPath];
        
        return headView;
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake((kScreenWidth-12)/3, 96);
    return size;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(kScreenWidth, 36.0f);
}

// 定义section的边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
    // UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
    
}

// 定义上下cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0f;
}

// 定义左右cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0f;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString * titleStr = self.mouleArray[indexPath.item][@"moduleName"];
    NSString * deviceStr  =  [UIDevice currentDevice].model;
    if ([titleStr isEqualToString:@"设备履历查询"]) {
        if ([deviceStr isEqualToString:@"iPad"]) {
            return;
        }
        MaintainResumeHomeController * controller  =[[MaintainResumeHomeController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }else if ([titleStr isEqualToString:@"关键配件管理"]){
        ManagerDeviceTabBarController *controller =[[ManagerDeviceTabBarController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
   
    //请求网络
    
    NSKeyedUnarchiver * modleArchiver = [Units readDateFromDiskWithPathStr:@"functionModel"];
   // MoudleModel * moudleStatus = [modleArchiver decodeObjectForKey:Function_WriteDisk];
    [modleArchiver finishDecoding];
    

    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
    [parms setObject:self.moudleIdArray[indexPath.item] forKey:@"ModuleId"];
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    KWeakSelf
    [HttpTool POST:[ChoseMoudleURL getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        
        debugLog(@" - -- - -- - %@",responseObject);
        
        [Units hiddenHudWithView:weakSelf.view];
        if ([[responseObject objectForKey:@"status"]integerValue]== 0) {
            NSDictionary * responDict = [Units jsonToDictionary:responseObject[@"data"]];
            
            NSMutableArray * arr = [DeviceModel mj_objectArrayWithKeyValuesArray:responDict[@"RightsList"]];
            
            if ([titleStr isEqualToString:@"厂务施工"]) {
                if ([deviceStr isEqualToString:@"iPad"]) {
                    return;
                }
                MConstructionTabbarController * tabbar  =[MConstructionTabbarController new];
                tabbar.modelArray  = arr;
                NSDictionary * dic  = @{@"rights":arr};
                [self.navigationController pushViewController:tabbar animated:YES];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"construction" object:dic];
                
                
                return;
            }if ([titleStr isEqualToString:@"IQC检验"]) {
                NSString * jsonStr  = [responseObject objectForKey:@"data"];
                NSDictionary * dataDict = [Units jsonToDictionary:jsonStr];
                NSArray * rightList  =[dataDict objectForKey:@"RightsList"];
                IQCMainController * IQCController  =[[IQCMainController alloc]init];
                IQCController.rightList  =rightList;
                [weakSelf.navigationController pushViewController:IQCController animated:YES];
                return;
                
            }
            
            if (arr.count >0) {
                
                if ([deviceStr isEqualToString:@"iPad"]) {
                    return;
                }
                
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

-(void)makeupMessage{
    NSKeyedUnarchiver * modleArchiver = [Units readDateFromDiskWithPathStr:@"keypath"];
    NSArray * moudleStatus = [modleArchiver decodeObjectForKey:@"moudle"];
    [modleArchiver finishDecoding];
 //   NSMutableArray * arr = [MoudleListModel mj_objectArrayWithKeyValuesArray:moudleStatus.ModulesList];
    
  //  [self.datasource addObjectsFromArray:arr];
    
    //当用ipad 登录的时候 增加一个IQC 管理
//    NSMutableArray * moudleLists  =[NSMutableArray array];
//    [moudleLists removeAllObjects];
//    [moudleLists addObjectsFromArray:moudleStatus];
    
    NSString * deviceStr  =  [UIDevice currentDevice].model;
   
//    if ([deviceStr isEqualToString:@"iPad"]) {
//        NSDictionary * dict  = @{@"moduleName":@"IQC管理",@"moduleId":@"4",@"icon":@"icon_60"};
//        [moudleLists addObject:dict];
//    }
    for (NSDictionary * dictModel in moudleStatus) {
        debugLog(@" 9 99  9%@",dictModel[@"moduleName"]);
        if ([deviceStr isEqualToString:@"iPad"]) {
            if ([dictModel[@"moduleName"] isEqualToString:@"设备维修"]||[dictModel[@"moduleName"] isEqualToString:@"设备点检保养"]||[dictModel[@"moduleName"] isEqualToString:@"厂务施工"]||[dictModel[@"moduleName"] isEqualToString:@"设备履历查询"]||[dictModel[@"moduleName"] isEqualToString:@"IQC检验"]||[dictModel[@"moduleName"] isEqualToString:@"废品变卖"]) {
                if (![self.mouleArray containsObject:@"设备维修"]||![self.mouleArray containsObject:@"设备点检保养"]||![self.mouleArray containsObject:@"厂务施工"]||![self.mouleArray containsObject:@"设备履历查询"]||![self.mouleArray containsObject:@"IQC检验"]||![self.mouleArray containsObject:@"废品变卖"]) {
                    [self.mouleArray addObject:dictModel];
                    [self.moudleIdArray addObject:dictModel[@"moduleId"]];
                }
            }
            
        }else{
            if ([dictModel[@"moduleName"] isEqualToString:@"设备维修"]||[dictModel[@"moduleName"] isEqualToString:@"设备点检保养"]||[dictModel[@"moduleName"] isEqualToString:@"厂务施工"]||[dictModel[@"moduleName"] isEqualToString:@"设备履历查询"]||[dictModel[@"moduleName"] isEqualToString:@"废品变卖"]||[dictModel[@"moduleName"] isEqualToString:@"设备校正"] ||[dictModel[@"moduleName"] isEqualToString:@"关键配件管理"]) {
                if (![self.mouleArray containsObject:@"设备维修"]||![self.mouleArray containsObject:@"设备点检保养"]||![self.mouleArray containsObject:@"厂务施工"]||![self.mouleArray containsObject:@"设备履历查询"]||![self.mouleArray containsObject:@"设备校正"]||![self.mouleArray containsObject:@"关键配件管理"]) {
                    [self.mouleArray addObject:dictModel];
                    [self.moudleIdArray addObject:dictModel[@"moduleId"]];
                }
               
            }
        }
    }
    
    [self.collectionView reloadData];
}

-(NSMutableArray*)imageArray{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
        NSArray * arr =@[@"auth_icon_manage_member",@"chat_btn_action_favorite",@"chat_btn_action_filebox",@"chat_btn_action_location",@"jiakao__ic_keer_xuayuanfuli_44x44_",@"spotlight_ding",@"auth_icon_manage_member",@"chat_btn_action_favorite",@"chat_btn_action_location",@"auth_icon_manage_member",@"jiakao__ic_keer_xuayuanfuli_44x44_",@"auth_icon_manage_member",@"chat_btn_action_favorite",@"auth_icon_manage_member",@"jiakao__ic_keer_xuayuanfuli_44x44_",@"auth_icon_manage_member"];
        [_imageArray addObjectsFromArray:arr];
    }
    return _imageArray;
}
@end
