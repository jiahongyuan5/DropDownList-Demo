//
//  SelectViewController.m
//  SelectType
//
//  Created by gdxjhy on 16/6/21.
//  Copyright © 2016年 com.hongyuan.App. All rights reserved.
//

#import "SelectViewController.h"
#import "SelectTableViewCell.h"
#import "IntervalTableViewCell.h"

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

@property (nonatomic, strong) NSDictionary *originDic; //初始化的字典

@property (nonatomic, strong) NSMutableDictionary *resultDic;//返回结果的字典

@end

@implementation SelectViewController

- (NSMutableDictionary *)resultDic{
    if (!_resultDic) {
        self.resultDic = [NSMutableDictionary dictionary];
    }
    return _resultDic;
}

- (instancetype)initWithSelectDictionary:(NSDictionary *)selDic{
    self = [super init];
    if (self) {
        self.originDic = selDic;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"SelectTableViewCell" bundle:nil] forCellReuseIdentifier:@"SelectCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"IntervalTableViewCell" bundle:nil] forCellReuseIdentifier:@"IntervalCell"];
    if (self.originDic) {
        self.resultDic = [self convertIndexPathDictionary:self.originDic];
    }
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && (self.type == SelectTypeArea || self.type == SelectTypePrice)) {
        IntervalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IntervalCell" forIndexPath:indexPath];
        cell.fromTextField.delegate = self;
        cell.toTextField.delegate = self;
        [cell setValueIntervalWithString:self.datasource[self.selectIndex.row]];
        cell.titleLabel.text = self.datasource[indexPath.row];
        [self setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0) cell:cell indexPath:indexPath];
        return cell;
    }
    SelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectCell" forIndexPath:indexPath];
    cell.titleLabel.text = self.datasource[indexPath.row];
    [self setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0) cell:cell indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[SelectTableViewCell class]]) {
        if (![self.selectIndex isEqual:indexPath]) {
            SelectTableViewCell *deselCell = [tableView cellForRowAtIndexPath:self.selectIndex];
            [deselCell.selectImg setImage:[UIImage imageNamed:@"xuanzhong"]];
            SelectTableViewCell *selCell = (SelectTableViewCell *)cell;
            [selCell.selectImg setImage:[UIImage imageNamed:@"Select"]];
            self.selectIndex = indexPath;
            switch (self.type) {
                case SelectTypeRegion:
                    [self.resultDic setValue:selCell.titleLabel.text forKey:SelectViewControllerRegionKey];
                    break;
                case SelectTypePrice:
                case SelectTypeArea:
                {
                    IntervalTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                    [cell setValueIntervalWithString:selCell.textLabel.text];
                }
                    break;
                case SelectTypeTime:
                    [self.resultDic setValue:selCell.titleLabel.text forKey:SelectViewControllerTimeKey];
                    break;
                default:
                    break;
                    
            }
        }
        
    }
}


#pragma mark - textField代理方法

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    SelectTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.selectIndex];
    [cell.selectImg setImage:[UIImage imageNamed:@"xuanzhong"]];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 私有方法
/**
 *  转换初始的只含indexPath的字典为含选择内容的字典
 *
 *  @param indexPathDic 含indexPath的字典
 *
 *  @return 含选择内容的字典
 */
- (NSMutableDictionary *)convertIndexPathDictionary:(NSDictionary *)indexPathDic{
    NSDictionary *sourceDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SelectList" ofType:@"plist"]];
    NSArray *keyArray = @[SelectViewControllerRegionKey,SelectViewControllerPriceKey,SelectViewControllerAreaKey,SelectViewControllerTimeKey];
    NSMutableDictionary *messageDic = [NSMutableDictionary dictionary];
    for (int i = 0; i < keyArray.count; i++) {
        NSArray *dataArr = sourceDic[keyArray[i]];
        NSString *message = [dataArr objectAtIndex:[indexPathDic[keyArray[i]] row]];
        [messageDic setObject:message forKey:keyArray[i]];
    }
    return messageDic;
}

/**
 *  点击确定按钮的响应方法
 *
 *  @param sender 点击的按钮
 */
- (IBAction)handleOKButtonAction:(UIButton *)sender {
    if (self.type == SelectTypePrice || self.type == SelectTypeArea) {
        [self saveSelectResult];
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(0, 116 - 507, 375, 507);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        if ([self.delegate respondsToSelector:@selector(selectViewController:didEndSelectionWithResult:)]) {
            [self.delegate selectViewController:self didEndSelectionWithResult:[self resultDictionary]];
        }
    }];
    
}

- (NSDictionary *)resultDictionary{
    return [NSDictionary dictionaryWithDictionary:self.resultDic];
}


- (void)saveSelectResult{
    if (self.type == SelectTypePrice) {
        IntervalTableViewCell *intervalCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSString *resultStr = [NSString stringWithFormat:@"%@-%@W",intervalCell.fromTextField.text,intervalCell.toTextField.text];
        [self.resultDic setObject:resultStr forKey:SelectViewControllerPriceKey];
    }else if (self.type == SelectTypeArea){
        IntervalTableViewCell *intervalCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSString *resultStr = [NSString stringWithFormat:@"%@-%@",intervalCell.fromTextField.text,intervalCell.toTextField.text];
        [self.resultDic setObject:resultStr forKey:SelectViewControllerAreaKey];
    }
}

/**
 *  设置tableView要显示的数据类型
 *
 *  @param type 数据的类型
 */
- (void)setType:(SelectType)type{
    if (_type != type) {
        if (_type != 0) {
            [self saveSelectResult];
        }
        _type = type;
        SelectTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.selectIndex];
        [cell.selectImg setImage:[UIImage imageNamed:@"xuanzhong"]];
        NSDictionary *sourceDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SelectList" ofType:@"plist"]];
        NSIndexPath *indexPath = nil;
        switch (type) {
            case SelectTypeRegion:
                self.datasource = sourceDic[SelectViewControllerRegionKey];
                indexPath = self.originDic[SelectViewControllerRegionKey] ?: [NSIndexPath indexPathForRow:0 inSection:0];
                break;
            case SelectTypePrice:
                self.datasource = sourceDic[SelectViewControllerPriceKey];
                indexPath = self.originDic[SelectViewControllerPriceKey] ?: [NSIndexPath indexPathForRow:1 inSection:0];
                break;
            case SelectTypeArea:
                self.datasource = sourceDic[SelectViewControllerAreaKey];
                indexPath = self.originDic[SelectViewControllerAreaKey] ?: [NSIndexPath indexPathForRow:1 inSection:0];
                break;
            case SelectTypeTime:
                self.datasource = sourceDic[SelectViewControllerTimeKey];
                indexPath = self.originDic[SelectViewControllerTimeKey] ?: [NSIndexPath indexPathForRow:0 inSection:0];
                break;
            default:
                break;
        }
        self.selectIndex = indexPath;
        if ([self.tableView numberOfRowsInSection:0] > 0) {
            [self.tableView reloadData];
            SelectTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.selectIndex];
            [cell.selectImg setImage:[UIImage imageNamed:@"Select"]];
        }
    }
    
}
/**
 *  为每一个Cell添加分割线
 *
 *  @param inset     分割线的边距，只对左、右边距有效
 *  @param cell      需要添加分割线的Cell
 *  @param indexPath cell在tableView中的位置
 */
- (void)setSeparatorInset:(UIEdgeInsets)inset cell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    CGRect separatorframe = CGRectMake(inset.left, cell.contentView.bounds.size.height - 0.5, cell.contentView.bounds.size.width - inset.left - inset.right, 0.5);
    UIView *separator = [[UIView alloc] initWithFrame:separatorframe];
    separator.backgroundColor = UIColorFromRGB(0xaaaaaa);
    if ([self.tableView numberOfRowsInSection:indexPath.section] == indexPath.row + 1) {
        separatorframe.origin.x = 0;
        separator.frame = separatorframe;
    }
    [cell.contentView addSubview:separator];
}

@end
