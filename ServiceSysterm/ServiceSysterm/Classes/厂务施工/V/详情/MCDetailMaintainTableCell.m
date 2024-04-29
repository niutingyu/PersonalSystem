//
//  MCDetailMaintainTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2020/10/27.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "MCDetailMaintainTableCell.h"
#import "MCDetailCollectionCell.h"

@interface MCDetailMaintainTableCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView *collectionView;


@property (nonatomic,strong)NSMutableArray * itemMutableArray;







@end
@implementation MCDetailMaintainTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius =3;
    self.clipsToBounds  =YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self  =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
      
        
        UICollectionViewFlowLayout * layout  =[[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing  =1;
        layout.minimumInteritemSpacing  =1;
        layout.scrollDirection  = UICollectionViewScrollDirectionVertical;
        _collectionView  =[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.scrollEnabled  =NO;

        _collectionView.delegate  =self;

        _collectionView.dataSource  =self;

        _collectionView.backgroundColor  =[UIColor whiteColor];

        [_collectionView registerNib:[UINib nibWithNibName:@"MCDetailCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"collectionCell"];

        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footId"];

        [self.contentView addSubview:_collectionView];

        
    }
    return self;
}

-(void)setupMaintainCellWithModel:(MCDetailMaintainArrayModel*)model{
    self.nOrderTimeLab.text =[NSString stringWithFormat:@"开单时间:%@(%@)",model.issueTime,model.operCreateUser];
    self.nOrderTimeLab.attributedText  =[Units changeLabel:@"开单时间:" wholeString:self.nOrderTimeLab.text font:[UIFont systemFontOfSize:16] color:[UIColor blackColor]];
    
    self.appointTimeLab.text  =[NSString stringWithFormat:@"指派时间:%@(%@)",model.assignTime?:@"",model.assignUser?:@"无"];
    
    self.appointTimeLab.attributedText  =  [Units changeLabel:@"指派时间:" wholeString:self.appointTimeLab.text font:[UIFont systemFontOfSize:16] color:[UIColor blackColor]];
    
    self.acceptTimeLab.text  =[NSString stringWithFormat:@"接单时间:%@(%@)",model.acceptTime?:@"",model.acceptUser?:@"无"];
    
    self.acceptTimeLab.attributedText  =  [Units changeLabel:@"接单时间:" wholeString:self.acceptTimeLab.text font:[UIFont systemFontOfSize:16] color:[UIColor blackColor]];
    
    self.issueAcceptanceLab.text  =[NSString stringWithFormat:@"申请验收:%@(%@)",model.applyFinishTime?:@"",model.operApplyUser?:@"无"];
    self.issueAcceptanceLab.attributedText  =[Units changeLabel:@"申请验收:" wholeString:self.issueAcceptanceLab.text font:[UIFont systemFontOfSize:16] color:[UIColor blackColor]];
    
    self.sureAcceptanceLab.text =[NSString stringWithFormat:@"确认验收:%@(%@)",model.finishTime?:@"",model.operFinishUser?:@"无"];
    
    self.sureAcceptanceLab.attributedText  =[Units changeLabel:@"确认验收:" wholeString:self.sureAcceptanceLab.text font:[UIFont systemFontOfSize:16] color:[UIColor blackColor]];
    
    self.constructionTimeConsumingLab.text  =[NSString stringWithFormat:@"施工耗时:%@(%@)",[self actualTimeTransfertoTimeWithTimeString:model.maintime]?:@"",model.acceptUser?:@"无"];
    self.constructionTimeConsumingLab.attributedText  =[Units changeLabel:@"施工耗时:" wholeString:self.constructionTimeConsumingLab.text font:[UIFont systemFontOfSize:16] color:RGBA(111, 141, 225, 1)];
    
    self.pauseTimeLab.text  =[NSString stringWithFormat:@"暂停时间:%@(%@)",model.pauseTime?:@"",model.acceptUser?:@"无"];
    
    self.pauseTimeLab.attributedText  =[Units changeLabel:@"暂停时间:" wholeString:self.pauseTimeLab.text font:[UIFont systemFontOfSize:16] color:RGBA(111, 141, 225, 1)];
    
    
    self.remarkLab.text  =[NSString stringWithFormat:@"备注:%@",model.workLog?:@"无"];
    self.remarkLab.attributedText  = [Units changeLabel:@"备注:" wholeString:self.remarkLab.text font:[UIFont systemFontOfSize:16] color:[UIColor blackColor]];
    
    
    
}


//-(void)setMaintainArray:(NSArray *)maintainArray{
//    _maintainArray  =maintainArray;
//
//    [self.itemMutableArray removeAllObjects];
//
//    for (MCDetailMaintainArrayModel * model in maintainArray) {
//        NSMutableDictionary * itemsDictionary =[NSMutableDictionary dictionary];
//        if (model.ConfirmTime.length >0) {
//            [itemsDictionary setObject:model.ConfirmTime forKey:@"confirm"];
//
//        }if (model.ReactTime.length >0) {
//            [itemsDictionary setObject:model.ReactTime forKey:@"reactime"];
//        }if (model.acceptTime.length >0) {
//            [itemsDictionary setObject:model.acceptTime forKey:@"accepttime"];
//        }if (model.acceptUser.length >0) {
//            [itemsDictionary setObject:model.acceptUser forKey:@"acceptuser"];
//        }if (model.applyFinishTime.length >0) {
//            [itemsDictionary setObject:model.applyFinishTime forKey:@"finishtime"];
//        }if (model.assignTime.length >0) {
//            [itemsDictionary setObject:model.assignTime forKey:@"assigntime"];
//        }if (model.assignUser.length >0) {
//            [itemsDictionary setObject:model.assignUser forKey:@"assignuser"];
//        }if (model.finishTime.length >0) {
//            [itemsDictionary setObject:model.finishTime forKey:@"finishtime"];
//        }if (model.issueTime.length >0) {
//            [itemsDictionary setObject:model.issueTime forKey:@"issuetime"];
//        }if (model.maintime.length >0) {
//            [itemsDictionary setObject:model.maintime forKey:@"maintime"];
//        }if (model.operCreateUser.length >0) {
//            [itemsDictionary setObject:model.operCreateUser forKey:@"opereateuser"];
//        }if (model.operFinishUser.length >0) {
//            [itemsDictionary setObject:model.operFinishUser forKey:@"operfinishuser"];
//        }if (model.pauseTime.length >0) {
//            [itemsDictionary setObject:model.pauseTime forKey:@"pausetime"];
//        }if (model.predictBeginTime.length >0) {
//            [itemsDictionary setObject:model.predictBeginTime forKey:@"predicttime"];
//        }if (model.status.length >0) {
//            [itemsDictionary setObject:model.status forKey:@"status"];
//        }if (model.workLog.length >0) {
//            [itemsDictionary setObject:model.workLog forKey:@"worklog"];
//        }
//
//        [self.itemMutableArray addObject:itemsDictionary];
//    }
//}


-(void)setFrame:(CGRect)frame{
    frame.origin.x +=2.0f;
    frame.size.width -= 4;
    [super setFrame:frame];
    
}
-(void)layoutSubviews{
    _collectionView.frame  = CGRectMake(0, 0, kScreenWidth, self.contentView.frame.size.height);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary * dict  = self.itemMutableArray[indexPath.section];
    NSArray * values  = dict[@(indexPath.section)];
    NSString * tip  = values[indexPath.item];
    if ([tip containsString:@"工作日志"]) {
        MCDetailMaintainArrayModel *model  = self.maintainArray[indexPath.section];
        
        return CGSizeMake(kScreenWidth, model.logHeight+20);
    }
    return CGSizeMake(kScreenWidth, 48);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    NSDictionary * dict  = self.itemMutableArray[section];
//    NSArray * keys  = [dict allKeys];
//
//    return keys.count;
    NSDictionary * dict = self.itemMutableArray[section];
    
    
    NSArray * arr  = dict[@(section)];
    
    return arr.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    debugLog(@" ==  =%ld",self.maintainArray.count);
    return self.itemMutableArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MCDetailCollectionCell * cell  =[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    
    NSDictionary * dict  = self.itemMutableArray[indexPath.section];
    NSArray * values  = dict[@(indexPath.section)];
    
    values  = [values[indexPath.item]componentsSeparatedByString:@":"];
    
    cell.titleLab.text  =[NSString stringWithFormat:@"%@:",[values firstObject]];
    if (values.count ==2) {
        cell.contentLab.text  =[NSString stringWithFormat:@"%@",[values lastObject]];
    }else{
      cell.contentLab.text  =[NSString stringWithFormat:@"%@:%@",[values objectAtIndex:1],[values lastObject]];
    }
    
    
    
    
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView * footView  =[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footId" forIndexPath:indexPath];

        footView.backgroundColor  = RGBA(242, 242, 242, 1);


        return footView;
    }
    return nil;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{

    return CGSizeMake(kScreenWidth, 3);
}

-(void)setMaintainArray:(NSArray *)maintainArray{
    _maintainArray  =maintainArray;
    [self.itemMutableArray removeAllObjects];

    
    for (int i =0; i<maintainArray.count; i++) {
        NSMutableDictionary * dict  =[NSMutableDictionary dictionary];
        [dict removeAllObjects];
        NSMutableArray * setupArray  =[NSMutableArray array];
        [setupArray removeAllObjects];
        MCDetailMaintainArrayModel *mModel  = maintainArray[i];
        
        if (mModel.issueTime.length >0) {
            [setupArray addObject:[NSString stringWithFormat:@"开单时间:%@:(%@)",mModel.issueTime,mModel.operCreateUser]];
        }if (mModel.assignTime.length >0) {
            [setupArray addObject:[NSString stringWithFormat:@"指派时间:%@:(%@)",mModel.assignTime,mModel.assignUser]];
        }
        if (mModel.acceptTime.length >0) {
            [setupArray addObject:[NSString stringWithFormat:@"接单时间:%@:(%@)",mModel.acceptTime,mModel.acceptUser]];
        }if (mModel.applyFinishTime.length >0) {
            [setupArray addObject:[NSString stringWithFormat:@"申请验收:%@:(%@)",mModel.applyFinishTime,mModel.operApplyUser]];
        }if (mModel.finishTime.length >0) {
            [setupArray addObject:[NSString stringWithFormat:@"确认验收:%@:(%@)",mModel.finishTime,mModel.operFinishUser]];
        }if (mModel.maintime.length >0) {
            [setupArray addObject:[NSString stringWithFormat:@"施工耗时:%@:(%@)",[self actualTimeTransfertoTimeWithTimeString:mModel.maintime],mModel.acceptUser]];
        }if (mModel.ReactTime.length >0) {
            [setupArray addObject:[NSString stringWithFormat:@"反应时间:%@:(%@)",[self actualTimeTransfertoTimeWithTimeString:mModel.ReactTime],mModel.acceptUser]];
        }
        if (mModel.pauseTime.length >0) {
            [setupArray addObject:[NSString stringWithFormat:@"暂停时间:%@:(%@)",[self actualTimeTransfertoTimeWithTimeString:mModel.pauseTime],mModel.acceptUser]];
        }if (mModel.workLog.length >0) {
            [setupArray addObject:[NSString stringWithFormat:@"工作日志:%@",mModel.workLog]];
        }
        
        [dict setObject:setupArray forKey:@(i)];
        [self.itemMutableArray addObject:dict];
        
    }

    

    [self.collectionView reloadData];

}
-(NSMutableArray*)itemMutableArray{
    if (!_itemMutableArray) {
        _itemMutableArray  =[NSMutableArray array];
    }return _itemMutableArray;
}


-(NSString*)actualTimeTransfertoTimeWithTimeString:(NSString*)timeString{
    NSString * time  =nil;
    
    int l = [timeString intValue];
    NSString *hour = [NSString stringWithFormat:@"%d",l/3600];
    NSString *second = [NSString stringWithFormat:@"%d",l%3600/60];
    if (l/3600 < 10) {
        hour = [NSString stringWithFormat:@"0%@",hour];
    }
    if (l%3600/60 < 10) {
        second = [NSString stringWithFormat:@"0%@",second];
    }
    time = [NSString stringWithFormat:@"%@时%@分",hour,second];
    
    
    if (l < 60)
    {
        time = @"00时01分";
    }
    
    return time;
}
@end
