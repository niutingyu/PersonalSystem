//
//  QCSubmitMainModel.m
//  ServiceSysterm
//
//  Created by Andy on 2021/7/17.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "QCSubmitMainModel.h"
#import "QCJudgeMethod.h"
@interface QCSubmitMainModel ()

@property (nonatomic,strong)NSMutableArray * stringList;





@end
@implementation QCSubmitMainModel

+(NSDictionary*)mj_objectClassInArray{
    return @{@"columnList":[QCColumnListModel class],@"detailList":[QCDetailListModel class]};
}

-(void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    
    //cell高度
//    if ([_Name containsString:@"对角线尺寸"]||[_Name containsString:@"尺寸稳定性"]||[_Name containsString:@"吸水"]) {
//        _cellHeight  = 60*self.detailList.count;
//    }else{
//        _cellHeight  = 60*self.detailList.count;
//    }
    _cellHeight  =60*self.detailList.count;
    
    
    _checkStandardList  =[_CheckStandard componentsSeparatedByString:@"、"];
    if ([_Name containsString:@"外观检查"]||[_Name containsString:@"基材检查"]||[_Name containsString:@"热应力"]) {
         
        //添加无缺陷
        if (_CheckStandard.length >0) {
            NSString * appranceStr  =  [NSString stringWithFormat:@"%@%@",@"无缺陷、",_CheckStandard];
            _appranceCheckStandardList  = [appranceStr componentsSeparatedByString:@"、"];
            
            for (NSString * str  in _appranceCheckStandardList) {
                
               
                CGFloat width  =[self boundingStr:str andFontSize:17];
                [self.stringList addObject:@(width)];
            }
            self.contentW  =[self.stringList copy];
            
        }

    }
    for (QCColumnListModel *columnModel in _columnList) {
        if ([columnModel.ColumnName containsString:@"偏差"]) {
            _typeStr  =@"偏差";
            break;
        }else if ([columnModel.ColumnName containsString:@"缺陷"]||[_Name containsString:@"热应力"]||[_Name containsString:@"外观检查"]){
            _typeStr  =@"缺陷";
            break;
        }else{
            if ([_Name containsString:@"供方COC"]||[_Name containsString:@"出货报告"]) {
                _typeStr =@"coc";
            }else if ([_Name containsString:@"剩余有效期"]){
                _typeStr =@"有效期";
            }else{
                _typeStr =@"输入";
            }
        }
    }
    //coc项目数组
    if ([_typeStr isEqualToString:@"coc"]) {
        for (QCColumnListModel * model in _columnList) {
            if ([model.ColumnName isEqualToString:@"检验结果"]) {
                NSArray * dataMemberList =[model.DataMember componentsSeparatedByString:@"^"];
                _dropTypeList  =[dataMemberList copy];
               
            }
        }
    }
  
    
}

- (CGFloat)boundingStr:(NSString *)Str andFontSize:(CGFloat)fontSize{
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    
    CGSize size = [Str boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    
    return size.width;
}

-(NSMutableArray*)stringList{
    if (!_stringList) {
        _stringList  =[NSMutableArray array];
    }
    return _stringList;
}


@end
