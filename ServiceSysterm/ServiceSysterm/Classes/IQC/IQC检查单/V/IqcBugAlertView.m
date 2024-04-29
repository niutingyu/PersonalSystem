//
//  IqcBugAlertView.m
//  ServiceSysterm
//
//  Created by Andy on 2021/8/25.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "IqcBugAlertView.h"



#define DEFAULT_MAX_HEIGHT kScreenHeight/3

//屏幕适配
/**当前设备对应375的比例*/
#define Ratio_375 (kScreenWidth/375.0)
/**转换成当前比例的数*/
#define Ratio(x) ((int)((x) * Ratio_375))

@interface IqcBugAlertView ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *bugList;

@property (nonatomic,strong)NSMutableArray *filterList;


@end

@implementation IqcBugAlertView


+(void)showBugViewWithList:(NSMutableArray*)bugList bugBlcok:(selectBugBlock)bugBlcok{
    IqcBugAlertView *alertView  =[[IqcBugAlertView alloc]initWithList:bugList bugBlock:bugBlcok];
    [[UIApplication sharedApplication].delegate.window  addSubview:alertView];
}


-(instancetype)initWithList:(NSMutableArray*)bugList bugBlock:(selectBugBlock)bugBlcok{
    if (self  =[super init]) {
        _bugBlcok  =bugBlcok;
        [self.bugList removeAllObjects];
        [self.bugList addObjectsFromArray:bugList];
        [self.filterList removeAllObjects];
        [self.filterList addObjectsFromArray:bugList];
        
        [self setupUI];
    }return self;
}
-(void)setupUI{
    
    
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3/1.0];
    //bgView最大高度
    CGFloat maxHeight = kScreenHeight*0.75;
    
    UITapGestureRecognizer * tap  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchOutSide)];
    tap.delegate  =self;
    [self addGestureRecognizer:tap];
    //backgroundView
    
    UIView *bgView = [[UIView alloc]init];
    bgView.center = self.center;
    bgView.bounds = CGRectMake(0, 0, self.frame.size.width - Ratio(140), maxHeight+Ratio(18));
    [self addSubview:bgView];
    
    
    
    //添加更新提示
    UIView *updateView = [[UIView alloc]init];
    updateView.frame = CGRectMake(Ratio(20), Ratio(18), bgView.frame.size.width -Ratio(40), maxHeight);
    updateView.backgroundColor = [UIColor whiteColor];
    updateView.layer.masksToBounds = YES;
    updateView.layer.cornerRadius = 4.0f;
    [bgView addSubview:updateView];
    
    //取消
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    
    cancelButton.center = CGPointMake(CGRectGetMaxX(updateView.frame)-Ratio(10), CGRectGetMinY(updateView.frame)+Ratio(10));
    cancelButton.bounds = CGRectMake(0, 0, Ratio(36), 36);
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancelButton];
    
    UISearchBar * searchBar  =[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, updateView.frame.size.width-Ratio(36), 57)];
//    searchBar.barStyle  =UISearchBarStyleDefault;
    searchBar.backgroundColor  =[UIColor whiteColor];
    searchBar.delegate  =self;
    [updateView addSubview:searchBar];
    if (!_tableView) {
        _tableView  =[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate =self;
        _tableView.dataSource  =self;
        _tableView.tableFooterView =[[UIView alloc]init];
        _tableView.separatorStyle  =UITableViewCellSeparatorStyleSingleLine;
        [updateView addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_offset(0);
            make.top.mas_offset(60);
        }];
    }
 
    [self showWithAlert:bgView];
    
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length >0) {
        NSMutableArray * keyArray  =[NSMutableArray array];
        [keyArray removeAllObjects];
        
        for (IqcBugModel *model in self.bugList) {
            NSString * keyStr  =model.BugName;
            if ([keyStr containsString:searchText]||[model.BugCode containsString:searchText]) {
                [keyArray addObject:model];
            }
        }
        [self.filterList removeAllObjects];
        [self.filterList addObjectsFromArray:keyArray];
        [self.tableView reloadData];
    }else{
        [self.filterList removeAllObjects];
        [self.filterList addObjectsFromArray:self.bugList];
        [self.tableView reloadData];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filterList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell  =[tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (cell==nil) {
        cell  =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    
    cell.textLabel.font  =[UIFont systemFontOfSize:15];
    
    IqcBugModel *model  = self.filterList[indexPath.row];
    NSString *nameStr  = [model.BugName stringByReplacingOccurrencesOfString:@" " withString:@""];
    cell.textLabel.text  =[NSString stringWithFormat:@"%@-%@",nameStr,model.BugCode];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48.f;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    IqcBugModel *model  = self.filterList[indexPath.row];
   
    if (self.bugBlcok) {
        self.bugBlcok(model);
    }
    [self dismissAlert];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{

    if([NSStringFromClass([touch.view class])isEqual:@"UITableViewCellContentView"]){
        return NO;
    }
    return YES;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self endEditing:YES];
}

- (void)showWithAlert:(UIView*)alert{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [alert.layer addAnimation:animation forKey:nil];

}

-(void)cancel{
    [self dismissAlert];
}

-(void)touchOutSide{
    [self endEditing:YES];
}
/** 添加Alert出场动画 */
- (void)dismissAlert{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = (CGAffineTransformMakeScale(1.5, 1.5));
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
-(NSMutableArray*)bugList{
    if (!_bugList) {
        _bugList  =[NSMutableArray array];
    }return _bugList;
}

-(NSMutableArray*)filterList{
    if (!_filterList) {
        _filterList  =[NSMutableArray array];
    }return _filterList;
}
@end
