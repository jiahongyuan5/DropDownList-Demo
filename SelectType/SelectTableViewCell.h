//
//  SelectTableViewCell.h
//  SelectType
//
//  Created by gdxjhy on 16/6/21.
//  Copyright © 2016年 com.hongyuan.App. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SelectState) {
    SelectStateUnchecked = 0,
    SelectStateChecked
};
@interface SelectTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImg;
@property (nonatomic) SelectState state;
@end
