//
//  IntervalTableViewCell.m
//  SelectType
//
//  Created by gdxjhy on 16/6/21.
//  Copyright © 2016年 com.hongyuan.App. All rights reserved.
//

#import "IntervalTableViewCell.h"

@implementation IntervalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setValueIntervalWithString:(NSString *)valueStr{
    if ([valueStr containsString:@"-"]) {
        NSArray *components = [valueStr componentsSeparatedByString:@"-"];
        self.fromTextField.text = components[0];
        self.toTextField.text = components[1];
    }else{
        self.toTextField.text = valueStr;
    }
    
}

@end
