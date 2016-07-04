//
//  HYSelectHeaderView.m
//  SelectType
//
//  Created by gdxjhy on 16/6/29.
//  Copyright © 2016年 com.hongyuan.App. All rights reserved.
//

#import "HYSelectHeaderView.h"

@interface HYSelectHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation HYSelectHeaderView

- (void)setType:(HYSelectHeaderViewType)type{
    if (_type != type) {
        _type = type;
        if (type == HYSelectHeaderViewTypePrice) {
            self.titleLabel.text = @"价格区间(元)";
        }else{
            self.titleLabel.text = @"面积";
        }
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
