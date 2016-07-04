//
//  SelectTableViewCell.m
//  SelectType
//
//  Created by gdxjhy on 16/6/21.
//  Copyright © 2016年 com.hongyuan.App. All rights reserved.
//

#import "SelectTableViewCell.h"

@implementation SelectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setState:(SelectState)state{
    if (_state != state) {
        _state = state;
        switch (self.state) {
            case SelectStateUnchecked:
                [self.selectImg setImage:[UIImage imageNamed:@"xuanzhong"]];
                break;
            case SelectStateChecked:
                [self.selectImg setImage:[UIImage imageNamed:@"Select"]];
                break;
            default:
                break;
        }
    }
    
}

@end
