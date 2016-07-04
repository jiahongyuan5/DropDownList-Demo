//
//  SelectViewController.m
//  SelectType
//
//  Created by gdxjhy on 16/6/21.
//  Copyright © 2016年 com.hongyuan.App. All rights reserved.
//

#import "SelectViewController.h"
#import "SelectTableViewCell.h"
#import "HYSelectHeaderView.h"

#define UIColorFromRGB(rgbColor) [UIColor colorWithRed:((rgbColor & 0xFF0000) >> 16) / 255.0 green:((rgbColor & 0xFF00) >> 8) / 255.0 blue:(rgbColor & 0xFF) / 255.0 alpha:1.0];

#ifdef DEBUG
#define DLog(format,...) NSLog(@"%s[LINE %d]"format,__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__);
#else
#define DLog(...)
#endif

 NSString *const SelectViewControllerRegionKey = @"Region";
 NSString *const SelectViewControllerPriceKey = @"Price";
 NSString *const SelectViewControllerAreaKey = @"Area";
 NSString *const SelectViewControllerTimeKey = @"Time";

@interface SelectViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *datasource; //数据源
@property (nonatomic, strong) NSIndexPath *selectIndex; //被选中的行
@property (nonatomic, copy) NSString *selectTitle;//选中的标题
@property (nonatomic, copy) NSString *customMinValue;//自定义最小值
@property (nonatomic, copy) NSString *customMaxValue;//自定义最大值
@property (nonatomic, strong) NSDictionary *sourceDic;//数据源
@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *indexPathDic;//每个分类算选中的数据
@property (nonatomic, strong) NSMutableDictionary<NSString *,NSString *> *titleDic;

@end

@implementation SelectViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titleDic = [NSMutableDictionary dictionary];
        self.indexPathDic = [NSMutableDictionary dictionary];
        self.sourceDic = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SelectList" ofType:@"plist"]];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        NSArray *keyArr = @[SelectViewControllerRegionKey, SelectViewControllerPriceKey, SelectViewControllerAreaKey, SelectViewControllerTimeKey];
        for (int i = 0; i < keyArr.count; i++) {
            NSString * key= keyArr[i];
            NSArray *titleArr = self.sourceDic[key];
            [self.indexPathDic setObject:indexPath forKey:key];
            [self.titleDic setObject:titleArr[indexPath.row] forKey:key];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"SelectTableViewCell" bundle:nil] forCellReuseIdentifier:@"SelectCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HYSelectHeaderView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"Header"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    SelectTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.selectIndex];
    [cell.selectImg setImage:[UIImage imageNamed:@"Select"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - tableView代理方法

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.type == SelectTypePrice || self.type == SelectTypeArea) {
        return 44;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.type == SelectTypePrice) {
       HYSelectHeaderView *headerView = (HYSelectHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
        headerView.type = HYSelectHeaderViewTypePrice;
        headerView.fromTextField.delegate = self;
        headerView.toTextField.delegate = self;
        NSLog(@"%@",headerView.contentView);
        return headerView;
    }else if (self.type == SelectTypeArea){
        HYSelectHeaderView *headerView = (HYSelectHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
        headerView.type = HYSelectHeaderViewTypeArea;
        headerView.fromTextField.delegate = self;
        headerView.toTextField.delegate = self;
        NSLog(@"%@",headerView.contentView);

        return headerView;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectCell" forIndexPath:indexPath];
    cell.titleLabel.text = self.datasource[indexPath.row];
    if (self.selectIndex && indexPath.row == self.selectIndex.row) {
        cell.state = SelectStateChecked;
    }else{
        cell.state = SelectStateUnchecked;
    }
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    if (indexPath.row == [tableView numberOfRowsInSection:0] - 1) {
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == SelectTypePrice || self.type == SelectTypeArea) {
        HYSelectHeaderView *headerView = (HYSelectHeaderView *)[tableView headerViewForSection:0];
        headerView.fromTextField.text = @"";
        headerView.toTextField.text = @"";
        self.customMinValue = nil;
        self.customMaxValue = nil;
    }
    if (![self.selectIndex isEqual:indexPath]) {
        SelectTableViewCell *deselCell = [tableView cellForRowAtIndexPath:self.selectIndex];
        deselCell.state = SelectStateUnchecked;
        SelectTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.state = SelectStateChecked;
        self.selectIndex = indexPath;
        self.selectTitle = cell.titleLabel.text;
    }
}


#pragma mark - textField代理方法

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    SelectTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.selectIndex];
    cell.state = SelectStateUnchecked;
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
        if (textField.tag == 1001) {
            self.customMinValue = textField.text;
        }else if (textField.tag == 1002){
            self.customMaxValue = textField.text;
        }
}

#pragma mark - 私有方法

/**
 *  点击确定按钮的响应方法
 *
 *  @param sender 点击的按钮
 */
- (IBAction)handleOKButtonAction:(UIButton *)sender {
    [self saveSelectResult];
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(0, 116 - 507, 375, 507);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        if ([self.delegate respondsToSelector:@selector(selectViewController:didEndSelectionWithResult:)]) {
            [self.delegate selectViewController:self didEndSelectionWithResult:self.titleDic];
        }
    }];
    
}


- (void)saveSelectResult{
    switch (self.type) {
        case SelectTypeRegion:
            [self.indexPathDic setObject:self.selectIndex forKey:SelectViewControllerRegionKey];
            [self.titleDic setObject:self.selectTitle forKey:SelectViewControllerRegionKey];
            break;
        case SelectTypePrice:
            
            if (self.customMinValue && ![self.customMinValue isEqualToString:@""] && self.customMaxValue && ![self.customMaxValue isEqualToString:@""]) {
                [self.indexPathDic setObject:[NSNull null] forKey:SelectViewControllerPriceKey];
                [self.titleDic setObject:[self.customMinValue stringByAppendingFormat:@"-%@", self.customMaxValue] forKey:SelectViewControllerPriceKey];
                self.selectIndex = nil;
            }else{
                [self.indexPathDic setObject:self.selectIndex forKey:SelectViewControllerPriceKey];
                [self.titleDic setObject:self.selectTitle forKey:SelectViewControllerPriceKey];
            }
            break;
        case SelectTypeArea:
            if (self.customMinValue && ![self.customMinValue isEqualToString:@""] && self.customMaxValue && ![self.customMaxValue isEqualToString:@""]) {
                [self.indexPathDic setObject:[NSNull null] forKey:SelectViewControllerAreaKey];
                [self.titleDic setObject:[self.customMinValue stringByAppendingFormat:@"-%@",self.customMaxValue] forKey:SelectViewControllerAreaKey];
                self.selectIndex = nil;

            }else{
                [self.indexPathDic setObject:self.selectIndex forKey:SelectViewControllerAreaKey];
                [self.titleDic setObject:self.selectTitle forKey:SelectViewControllerAreaKey];
            }
            break;
        case SelectTypeTime:
            [self.indexPathDic setObject:self.selectIndex forKey:SelectViewControllerTimeKey];
            [self.titleDic setObject:self.selectTitle forKey:SelectViewControllerTimeKey];
            break;
        default:
            break;
    }
}

/**
 *  设置tableView要显示的数据类型
 *
 *  @param type 数据的类型
 */
- (void)setType:(SelectType)type{
    if (_type != type) {
        [self saveSelectResult];
        _type = type;
        [self configureTableView];
    }
    
}

- (void)configureTableView{
    switch (self.type) {
        case SelectTypeRegion:
            self.datasource = self.sourceDic[SelectViewControllerRegionKey];
            self.selectIndex = self.indexPathDic[SelectViewControllerRegionKey];
            self.selectTitle = self.datasource[self.selectIndex.row];
            break;
        case SelectTypePrice:
            self.datasource = self.sourceDic[SelectViewControllerPriceKey];
            if ([self.indexPathDic[SelectViewControllerPriceKey] isEqual:[NSNull null]]) {
                self.selectIndex = nil;
            }else{
                self.selectIndex = self.indexPathDic[SelectViewControllerPriceKey];
            }
            self.selectTitle = self.datasource[self.selectIndex.row];
            break;
        case SelectTypeArea:
            self.datasource = self.sourceDic[SelectViewControllerAreaKey];
            if ([self.indexPathDic[SelectViewControllerPriceKey] isEqual:[NSNull null]]) {
                self.selectIndex = nil;
            }else{
                self.selectIndex = self.indexPathDic[SelectViewControllerAreaKey];
            }
            self.selectTitle = self.datasource[self.selectIndex.row];
            break;
        case SelectTypeTime:
            self.datasource = self.sourceDic[SelectViewControllerTimeKey];
            self.selectIndex = self.indexPathDic[SelectViewControllerTimeKey];
            self.selectTitle = self.datasource[self.selectIndex.row];
            break;
        default:
            break;
    }
    if (self.tableView) {
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView reloadData];
    }
}

@end
