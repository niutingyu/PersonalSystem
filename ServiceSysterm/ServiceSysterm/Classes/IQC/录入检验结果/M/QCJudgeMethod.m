//
//  QCJudgeMethod.m
//  ServiceSysterm
//
//  Created by Andy on 2021/7/29.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "QCJudgeMethod.h"

@interface QCJudgeMethod ()


@end
@implementation QCJudgeMethod


+(void)diagonalCalculateWithName:(NSString*)name listModel:(QCDetailListModel*)listModel mainModel:(QCSubmitMainModel*)mainModel{
    if (listModel.Result02.length >0 &&listModel.Result01.length >0) {
       
      
        
        NSDecimalNumber *d1  = [NSDecimalNumber decimalNumberWithString:listModel.Result01];
        NSDecimalNumber  *d2  =[NSDecimalNumber decimalNumberWithString:listModel.Result02];
        if ([name isEqualToString:@"尺寸稳定性"]) {
         
            NSDecimalNumber  *targetNumber  =[NSDecimalNumber decimalNumberWithString:@"100.0"];
            NSDecimalNumber * afterCoupon  =[d2 decimalNumberBySubtracting:d1];
            NSDecimalNumber *average =[afterCoupon decimalNumberByDividingBy:d1];
            NSDecimalNumber *afterDiscount  =[average decimalNumberByMultiplyingBy:targetNumber];
            NSDecimalNumberHandler *roundNum =[NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                       scale:3
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:YES];
            NSDecimalNumber *number  =[afterDiscount decimalNumberByRoundingAccordingToBehavior:roundNum];
            listModel.Result03  =number.stringValue;
            
        }else if ([name isEqualToString:@"吸水性"]){
            //计算公式 （最终重量-初始重量）/初始重量 *100%;
            NSDecimalNumber *subNum  = [d2 decimalNumberBySubtracting:d1];
            
            NSDecimalNumber *avaNum  = [subNum decimalNumberByDividingBy:d1];
            NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
            NSDecimalNumber *disNum  = [avaNum decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"] withBehavior:roundUp];
           
            
            listModel.Result03  = disNum.stringValue;
            
        }
        else{
            if ([d1 compare:d2]==NSOrderedAscending) {
                
                //d1 <d2
                
                listModel.Result03  = [d2 decimalNumberBySubtracting:d1].stringValue;
            }else{
                //d1 >d2
                listModel.Result03  =[d1 decimalNumberBySubtracting:d2].stringValue;
            }
        }
        
     
        NSDecimalNumber *d3  = [NSDecimalNumber decimalNumberWithString:listModel.Result03];
        NSDecimalNumber *minNumber  =[NSDecimalNumber decimalNumberWithString:mainModel.MinStandard];
        NSDecimalNumber *maxNumber  =[NSDecimalNumber decimalNumberWithString:mainModel.MaxStandard];
        if (([d3 compare:minNumber] == NSOrderedDescending ||[d3 compare:minNumber] ==NSOrderedSame) && ([d3 compare:maxNumber] == NSOrderedAscending ||[d3 compare:maxNumber]==NSOrderedSame)) {
            listModel.DecisionResult  =@"合格";
        }else{
            listModel.DecisionResult  =@"不合格";
        }

    }

    else{
        listModel.DecisionResult  =@"";
        listModel.Result03 =@"";
    }
    
    NSMutableString * string =[[NSMutableString alloc]init];
    //使用可变字符串拼接 所选择的内容 如 011 格式
    for (QCDetailListModel *detailModel in mainModel.detailList) {
      
        [string appendString:detailModel.DecisionResult?:@""];
    }
    if ([string containsString:@"不"]) {
        mainModel.DecisionResult  =@"0";
    }else{
        mainModel.DecisionResult  =@"1";
    }
}
+(void)calculateWithName:(NSString*)name listModel:(QCDetailListModel*)listModel mainModel:(QCSubmitMainModel*)mainModel idx:(NSInteger)idx{
    if ([mainModel.typeStr  containsString:@"coc"]) {
        //一个数组 直接赋值 DecisionResult
        
        if ([listModel.Result01 containsString:@"已提供，信息正确"]) {
            listModel.DecisionResult =@"合格";
            mainModel.DecisionResult =@"1";
            
        }else{
            listModel.DecisionResult  =@"不合格";
            mainModel.DecisionResult =@"0";
        }
    
    }else if ([mainModel.typeStr containsString:@"有效期"]){
        
        NSScanner * scanner  = [NSScanner scannerWithString:mainModel.CheckStandard];
        [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
        int number;
        [scanner scanInt:&number];
        NSString *num=[NSString stringWithFormat:@"%d",number];
        if (listModel.Result01.length >0) {
            if ([listModel.Result01 intValue]>= [num intValue]) {
                listModel.DecisionResult =@"合格";
                mainModel.DecisionResult =@"1";
            }else{
                listModel.DecisionResult  =@"不合格";
                mainModel.DecisionResult =@"0";
            }
            
        }else{
            listModel.DecisionResult  =@"";
            mainModel.DecisionResult  =@"";
        }
       
    }else{
        
        
        
         /*   float value  =[listModel.Result01 floatValue];
            debugLog(@" -- -%f",value);
            if (value  >= [mainModel.MinStandard floatValue] && value <= [mainModel.MaxStandard floatValue]) {
                listModel.DecisionResult =@"合格";
                
            }else if (value ==0 ){
                listModel.DecisionResult  =@"";
            }
            else{
                listModel.DecisionResult =@"不合格";
                
        }*/
      
     
        if (idx ==0) {
            float value  =[listModel.Result01 floatValue];
            if (value  >= [mainModel.MinStandard floatValue] && value <= [mainModel.MaxStandard floatValue]) {
               // listModel.DecisionResult =@"合格";
                listModel.DecisionResult0 =@"合格";
                
            }else if (value ==0 ){
                listModel.DecisionResult0  =@"";
            }
            else{
              //  listModel.DecisionResult =@"不合格";
                listModel.DecisionResult0 =@"不合格";
                
            }
            
        }else if (idx ==1) {
            float value  =[listModel.Result02 floatValue];
            if (value  >= [mainModel.MinStandard floatValue] && value <= [mainModel.MaxStandard floatValue]) {
               // listModel.DecisionResult =@"合格";
                listModel.DecisionResult1 =@"合格";
                
            }else if (value ==0  ){
                listModel.DecisionResult1  =@"";
            }
            else{
               // listModel.DecisionResult =@"不合格";
                listModel.DecisionResult1 =@"不合格";
                
            }
        }else if (idx ==2) {
            float value  =[listModel.Result03 floatValue];
            if (value  >= [mainModel.MinStandard floatValue] && value <= [mainModel.MaxStandard floatValue]) {
               // listModel.DecisionResult =@"合格";
                listModel.DecisionResult2 =@"合格";
                
            }else if (value ==0 ){
                listModel.DecisionResult2  =@"";
            }
            else{
               // listModel.DecisionResult =@"不合格";
                listModel.DecisionResult2 =@"不合格";
                
            }
        }else if (idx ==3) {
            float value  =[listModel.Result04 floatValue];
            if (value  >= [mainModel.MinStandard floatValue] && value <= [mainModel.MaxStandard floatValue]) {
              //  listModel.DecisionResult =@"合格";
                listModel.DecisionResult3 =@"合格";
                
            }else if (value ==0  ){
                listModel.DecisionResult3  =@"";
            }
            else{
              //  listModel.DecisionResult =@"不合格";
                listModel.DecisionResult3 =@"不合格";
                
            }
        }else if (idx ==4) {
            float value  =[listModel.Result05 floatValue];
            if (value  >= [mainModel.MinStandard floatValue] && value <= [mainModel.MaxStandard floatValue]) {
               // listModel.DecisionResult =@"合格";
                listModel.DecisionResult4 =@"合格";
                
            }else if (value ==0  ){
                listModel.DecisionResult4  =@"";
            }
            else{
               // listModel.DecisionResult =@"不合格";
                listModel.DecisionResult4 =@"不合格";
                
            }
        }else if (idx ==5) {
            float value  =[listModel.Result06 floatValue];
            if (value  >= [mainModel.MinStandard floatValue] && value <= [mainModel.MaxStandard floatValue]) {
               // listModel.DecisionResult =@"合格";
                listModel.DecisionResult5 =@"合格";
                
            }else if (value ==0 ){
                listModel.DecisionResult5  =@"";
            }
            else{
               // listModel.DecisionResult =@"不合格";
                listModel.DecisionResult5 =@"不合格";
                
            }
        }else if (idx ==6) {
            float value  =[listModel.Result07 floatValue];
            if (value  >= [mainModel.MinStandard floatValue] && value <= [mainModel.MaxStandard floatValue]) {
                //listModel.DecisionResult =@"合格";
                listModel.DecisionResult6 =@"合格";
                
            }else if (value ==0 ){
                listModel.DecisionResult6  =@"";
            }
            else{
               // listModel.DecisionResult =@"不合格";
                listModel.DecisionResult6 =@"不合格";
                
            }
        }else if (idx ==7) {
            float value  =[listModel.Result08 floatValue];
            if (value  >= [mainModel.MinStandard floatValue] && value <= [mainModel.MaxStandard floatValue]) {
               // listModel.DecisionResult =@"合格";
                listModel.DecisionResult7 =@"合格";
                
            }else if (value ==0 ){
                listModel.DecisionResult7  =@"";
            }
            else{
               // listModel.DecisionResult =@"不合格";
                listModel.DecisionResult7 =@"不合格";
                
            }
        }else if (idx ==8) {
            float value  =[listModel.Result09 floatValue];
            if (value  >= [mainModel.MinStandard floatValue] && value <= [mainModel.MaxStandard floatValue]) {
               // listModel.DecisionResult =@"合格";
                listModel.DecisionResult8 =@"合格";
                
            }else if (value ==0  ){
                listModel.DecisionResult8  =@"";
            }
            else{
               // listModel.DecisionResult =@"不合格";
                listModel.DecisionResult8 =@"不合格";
                
            }
        }else if (idx ==9) {
            float value  =[listModel.Result10 floatValue];
            if (value  >= [mainModel.MinStandard floatValue] && value <= [mainModel.MaxStandard floatValue]) {
               // listModel.DecisionResult =@"合格";
                listModel.DecisionResult9 =@"合格";
                
            }else if (value ==0  ){
                listModel.DecisionResult9  =@"";
            }
            else{
               // listModel.DecisionResult =@"不合格";
                listModel.DecisionResult9 =@"不合格";
                
            }
        }

        NSMutableString * mutableString =[[NSMutableString alloc]init];
        NSDictionary *dict  =[listModel mj_keyValues];
        for (int i =0; i<10; i++) {
            [mutableString appendString:[dict objectForKey:[NSString stringWithFormat:@"%@%d",@"DecisionResult",i]]?:@""];
        }
        
        if ([mutableString containsString:@"不"]) {
            listModel.DecisionResult  =@"不合格";
        }else if (mutableString.length ==0){
            listModel.DecisionResult=@"";
        }
        else{
            listModel.DecisionResult  =@"合格";
        }
        
//        CGFloat maxValue = [[resultArr valueForKeyPath:@"@max.floatValue"] floatValue];
//        CGFloat minValue = [[resultArr valueForKeyPath:@"@min.floatValue"] floatValue];
//
//
//        debugLog(@" 0-%f %f %ld %@ %@",maxValue,minValue,resultArr.count,mainModel.MaxStandard,mainModel.MinStandard);
//        if (maxValue <=[mainModel.MaxStandard floatValue]&&maxValue >=[mainModel.MinStandard floatValue]) {
//            listModel.DecisionResult  =@"合格";
//        }else{
//            listModel.DecisionResult =@"不合格";
//        }
        
    }
    

        
        NSMutableString * string =[[NSMutableString alloc]init];
        //使用可变字符串拼接 所选择的内容 如 011 格式
        for (QCDetailListModel *detailModel in mainModel.detailList) {
          
            [string appendString:detailModel.DecisionResult?:@""];
        }
        if ([string containsString:@"不"]) {
            mainModel.DecisionResult  =@"0";
        }else{
            mainModel.DecisionResult  =@"1";
        }
    
}



@end
