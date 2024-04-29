//
//  MCChoseDepartmentAlrtView.m
//  ServiceSysterm
//
//  Created by Andy on 2020/10/22.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "MCChoseDepartmentAlrtView.h"


#define DEFAULT_MAX_HEIGHT kScreenHeight*0.7
#define Ratio_375 (kScreenWidth/375.0)
/**转换成当前比例的数*/
#define Ratio(x) ((int)((x) * Ratio_375))


@interface MCChoseDepartmentAlrtView ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSArray * datasource;

@end


@implementation MCChoseDepartmentAlrtView

+(void)showMKBusinessHistoryAlertViewWithDatasource:(NSArray*)datasource department:(choseDepartmentBlock)department{
    MCChoseDepartmentAlrtView * alertView = [[MCChoseDepartmentAlrtView alloc]initWithDatasource:datasource department:department];
    [[UIApplication sharedApplication].delegate.window addSubview:alertView];
    
}
-(instancetype)initWithDatasource:(NSArray*)datasource department:(choseDepartmentBlock)department{
    if (self  =[super init]) {
        _datasource  =datasource;
        _departmentBlock  = department;
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3/1.0];
    //bgView最大高度
    CGFloat maxHeight = DEFAULT_MAX_HEIGHT;
    
    UIView * bgView  = [UIView new];
    bgView.center = self.center;

    bgView.bounds = CGRectMake(0, 0, self.frame.size.width - Ratio(20), maxHeight+Ratio(18)+60);
    [self addSubview:bgView];
    
    UIView * bottomView  =[UIView new];
    bottomView.frame = CGRectMake(Ratio(25), Ratio(18), bgView.frame.size.width -Ratio(50), maxHeight);
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.layer.masksToBounds = YES;
    bottomView.layer.cornerRadius = 4.0f;
    [bgView addSubview:bottomView];
    
    UILabel * titleLabel  =[[UILabel alloc]initWithFrame:CGRectMake(0, 8, bottomView.frame.size.width, 21)];
    titleLabel.textAlignment  =NSTextAlignmentCenter;
    titleLabel.text =@"选择部门";
    titleLabel.font  =[UIFont systemFontOfSize:16];
    [bottomView addSubview:titleLabel];
    
//    UISearchBar * searchBar  =[[UISearchBar alloc]init];
//    searchBar.frame  = CGRectMake(2, 8, bottomView.frame.size.width-4, 38);
//    searchBar.placeholder =@"请输入部门";
//    searchBar.delegate  =self;
//    [bottomView addSubview:searchBar];
    
    
    if (!_tableView) {
        _tableView  =[[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame)+5, bottomView.frame.size.width, bottomView.frame.size.height-21-8-5) style:UITableViewStyleGrouped];
        _tableView.delegate  =self;
        _tableView.dataSource  =self;
        _tableView.tableFooterView  =[UIView new];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell0"];
        _tableView.estimatedRowHeight =48.0f;
        
        
        [bottomView addSubview:_tableView];
        
    }
    
    UIView * line  =[[UIView alloc]init];
    line.frame = CGRectMake(0, CGRectGetMaxY(_tableView.frame)+1, bottomView.frame.size.width, 1);
    line.backgroundColor  = RGBA(242, 242, 242, 1);
    [bottomView addSubview:line];
    

    
    UIButton * cancelBut  =[UIButton buttonWithType:UIButtonTypeCustom];
       
    [cancelBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
       
    cancelBut.frame = CGRectMake(bgView.frame.size.width/2-30, CGRectGetMaxY(bottomView.frame)+25, 60, 30);
       
    [cancelBut setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [cancelBut addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
       
    [bgView addSubview:cancelBut];
       
    [self showWithAlert:bgView];
}


-(void)sureMethod{
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell  =[tableView dequeueReusableCellWithIdentifier:@"cell0"];
    
    cell.selectionStyle  =UITableViewCellSelectionStyleNone;
    
    cell.textLabel.font  =[UIFont systemFontOfSize:16];
    
    NSDictionary * dic  = self.datasource[indexPath.row];
    
    cell.textLabel.text  = dic[@"DepName"];
    
    
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 3.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary * dic  = self.datasource[indexPath.row];
    
    if (self.departmentBlock) {
        
        self.departmentBlock(dic);
    }
    [self dismissAlert];
}
-(void)cancelClick{
    [self dismissAlert];
}
- (void)showWithAlert:(UIView*)alert{
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3f;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
  //  [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
      [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [alert.layer addAnimation:animation forKey:nil];
}

/** 添加Alert出场动画 */
- (void)dismissAlert{
    KWeakSelf
    [UIView animateWithDuration:0.3f animations:^{
        //self.transform = (CGAffineTransformMakeScale(1.5, 1.5));
        weakSelf.backgroundColor = [UIColor clearColor];
        weakSelf.alpha = 0;
    }completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    } ];
    
}
@end
