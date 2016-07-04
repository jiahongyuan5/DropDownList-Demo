//
//  HYSelectHeaderView.h
//  SelectType
//
//  Created by gdxjhy on 16/6/29.
//  Copyright © 2016年 com.hongyuan.App. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HYSelectHeaderViewType) {
    HYSelectHeaderViewTypeArea = 0,
    HYSelectHeaderViewTypePrice
};

@interface HYSelectHeaderView : UITableViewHeaderFooterView

@property(nonatomic) HYSelectHeaderViewType type;
@property (weak, nonatomic) IBOutlet UITextField *fromTextField;
@property (weak, nonatomic) IBOutlet UITextField *toTextField;

@end
