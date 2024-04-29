//
//  DEResotreListTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/10.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEResotreListTableCell.h"

@implementation DEResotreListTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 3;
    self.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureCell:(DEMatrialListModel*)model idx:(NSInteger)indexSection datasource:(NSMutableArray*)datasource{
    
    self.monthLab.text = [Units timeWithTime:model.RequisitionOn beforeFormat:@"yyyy-MM-dd HH:mm:ss" andAfterFormat:@"yy/MM/dd"];//年月日
    
    self.hourLab.text = [Units timeWithTime:model.RequisitionOn beforeFormat:@"yyyy-MM-dd HH:mm:ss" andAfterFormat:@"HH:mm"];//f时分
    self.titleLab.text = [NSString stringWithFormat:@"%@-%@",model.DepStr,model.RequisitionByStr];//标题 姓名
    self.numberLab.text = model.MatRequisitionCode;//订单号
    self.departmentLab.text = [self deviceType:model];//设备保养类型
    self.departProgressLab.text = [self getStatus:model];//设备z订单状态
    self.companyLab.text = [NSString stringWithFormat:@"申领原因:%@",model.Reason?:@"无"];
    self.time_timeLab.text =[NSString stringWithFormat:@"距离开单时间:%@",[self delayTime:model.RequisitionOn andEndTime:nil]];
    self.progressLab.text = [NSString stringWithFormat:@"%ld/%ld",indexSection+1,datasource.count];
    self.locationLab.text = model.HasPrint?@"已打印":@"未打印";
}

-(void)configStockCell:(DEStockListModel*)model idx:(NSInteger)stockSection stockArray:(NSMutableArray*)stockArray{
    self.monthLab.text = [Units timeWithTime:model.ReturnOn beforeFormat:@"yyyy-MM-dd HH:mm:ss" andAfterFormat:@"yy/MM/dd"];//年月日
    
    self.hourLab.text = [Units timeWithTime:model.ReturnOn beforeFormat:@"yyyy-MM-dd HH:mm:ss" andAfterFormat:@"HH:mm"];//f时分
    self.titleLab.text = [NSString stringWithFormat:@"%@-%@",model.DepName,model.ReturnByName];//标题 姓名
    self.numberLab.text = model.MatRequisitionCode;//订单号
    self.departmentLab.text = model.FactoryName;//设备保养类型
    self.departProgressLab.text = [self getStock:model];//设备z订单状态
    self.companyLab.text = [NSString stringWithFormat:@"回仓单号:%@",model.ReturnBillNum?:@""];
    self.time_timeLab.text =[NSString stringWithFormat:@"距离开单时间:%@",[self delayTime:model.ReturnOn andEndTime:nil]];
    self.progressLab.text = [NSString stringWithFormat:@"%ld/%ld",stockSection+1,stockArray.count];
    if (model.HasPrint ==1) {
        self.locationLab.text = @"已打印";
    }else{
        self.locationLab.text =@"未打印";
    }
    
}
-(NSString*)getStatus:(DEMatrialListModel*)model{
    //物品状态
    NSString * status;
    if ([model.Status isEqualToString:@"-10"] ||[model.Status isEqualToString:@"31"]) {
        status = @"作废";
    }else if ([model.Status isEqualToString:@"0"]){
        status =@"待提交";
    }else if ([model.Status isEqualToString:@"1"]){
        status = @"重填数据";
    }else if ([model.Status isEqualToString:@"10"]){
        status = @"待部门审核";
    }else if ([model.Status isEqualToString:@"15"]){
        status = @"待仓库复核";
    }else if ([model.Status isEqualToString:@"20"]){
        status =@"待发放";
    }else if ([model.Status isEqualToString:@"21"]){
        status =@"部分退回";
    }else if ([model.Status isEqualToString:@"25"]){
        status =@"部分发放";
    }else if ([model.Status isEqualToString:@"26"]){
        status =@"全部发放";
    }else if ([model.Status isEqualToString:@"30"]){
        status =@"已出库";
    }
    return status;
}

//回仓表
-(NSString*)getStock:(DEStockListModel*)model{
    NSString * status ;
    if (model.Status  ==-10) {
        status =@"作废";
    }else if (model.Status ==0){
        status =@"待提交";
    }else if (model.Status ==1){
        status =@"退回";
    }else if (model.Status ==5){
        status =@"带部门审核";
    }else if (model.Status ==10){
        status =@"待仓管核实";
    }else if (model.Status ==13){
        status =@"待IQC";
    }else if (model.Status ==15){
        status =@"待入库";
    }else if (model.Status ==20){
        status =@"回仓成功";
    }else if (model.Status ==21){
        status =@"回仓失败";
        
    }
    return status;
}

-(NSString*)deviceType:(DEMatrialListModel*)model{
    //设备类型
    NSString * type;
    if (model.RequisitionType ==12) {
        type = @"设备维修";
    }else if (model.RequisitionType ==13){
        type = @"设备保养";
    }else if (model.RequisitionType ==14){
        type =@"工程施工";
    }
    return type;
}
-(void)setFrame:(CGRect)frame{
    frame.origin.x +=5.0f;
    frame.size.width -= 10.0f;
    [super setFrame:frame];
}
@end
