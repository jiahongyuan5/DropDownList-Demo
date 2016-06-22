//
//  SelectViewController.h
//  SelectType
//
//  Created by gdxjhy on 16/6/21.
//  Copyright © 2016年 com.hongyuan.App. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  选择要显示的数据类型
 */
typedef NS_ENUM(NSInteger, SelectType) {
    /**
     *  地区
     */
    SelectTypeRegion = 1,
    /**
     *  价格
     */
    SelectTypePrice,
    /**
     *  面积
     */
    SelectTypeArea,
    /**
     *  时间
     */
    SelectTypeTime,
};
NS_ASSUME_NONNULL_BEGIN
/**
 *  返回结果字典的key
 */
UIKIT_EXTERN NSString *const SelectViewControllerRegionKey;
UIKIT_EXTERN NSString *const SelectViewControllerPriceKey;
UIKIT_EXTERN NSString *const SelectViewControllerAreaKey;
UIKIT_EXTERN NSString *const SelectViewControllerTimeKey;

@class SelectViewController;
@protocol SelectViewControllerDelegate <NSObject>
/**
 *  当选择完成点击确定按钮时，发送此消息给代理对象
 *
 *  @param selectVC  执行选择的ViewController
 *  @param resultDic 选择结果的字典
 */
- (void)selectViewController:(SelectViewController *)selectVC didEndSelectionWithResult:(NSDictionary *)resultDic;

@end

@interface SelectViewController : UIViewController

@property (nonatomic) SelectType type;
@property (nonatomic, weak,nullable) id<SelectViewControllerDelegate> delegate;
/**
 *  初始化方法
 *
 *  @param selDic 初始化选择的字典，如果为nil将使用默认的设置
 *
 *  @return SelectViewController实例对象
 */
- (instancetype)initWithSelectDictionary:(nullable NSDictionary *)selDic;

@end
NS_ASSUME_NONNULL_END