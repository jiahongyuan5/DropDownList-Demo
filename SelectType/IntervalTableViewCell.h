//
//  IntervalTableViewCell.h
//  SelectType
//
//  Created by gdxjhy on 16/6/21.
//  Copyright © 2016年 com.hongyuan.App. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntervalTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITextField *fromTextField;
@property (weak, nonatomic) IBOutlet UITextField *toTextField;

- (void)setValueIntervalWithString:(NSString *)valueStr;

@end
