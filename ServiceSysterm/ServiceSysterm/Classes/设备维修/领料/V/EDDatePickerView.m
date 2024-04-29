//
//  EDDatePickerView.m
//  FlyWithAll
//
//  Created by Groupfly on 2016/11/17.
//  Copyright © 2016年 Groupfly. All rights reserved.
//

#import "EDDatePickerView.h"

@interface EDDatePickerView ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datepPicker;
@property (strong,nonatomic) NSDateFormatter *formatter;

@end

@implementation EDDatePickerView

+ (instancetype)datePickerView{
    return [[[NSBundle mainBundle] loadNibNamed:@"EDDatePickerView" owner:nil options:nil] firstObject];
}

- (NSDateFormatter *)formatter{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc]init];
        _formatter.dateFormat = @"yyyy-MM-dd";
    }
    return _formatter;
}

- (void)setCurrentDate:(NSString *)currentDate{
    _currentDate = currentDate;
    
    NSDate *date = [self.formatter dateFromString:currentDate];
    self.datepPicker.date = date;
}

- (IBAction)confirm:(id)sender {
    if (self.confirmBlock) {
        self.confirmBlock([self.formatter stringFromDate:self.datepPicker.date]);
    }
}
- (IBAction)cancel:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock(@"");
    }
}

@end
