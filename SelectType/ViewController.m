//
//  ViewController.m
//  SelectType
//
//  Created by gdxjhy on 16/6/21.
//  Copyright © 2016年 com.hongyuan.App. All rights reserved.
//

#import "ViewController.h"
#import "SelectViewController.h"
#import "NormalTableViewCell.h"
#ifdef DEBUG

#define DLog(format,...) NSLog(@"%s[Line %d]"format,__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__)
#else

#define DLog(...)

#endif

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, SelectViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *zoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *totalPriBtn;
@property (weak, nonatomic) IBOutlet UIButton *areaBtn;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSInteger selectTag;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell" forIndexPath:indexPath];
    return cell;
}

- (IBAction)handleSelectButtonAction:(UIButton *)sender{
    SelectViewController *selectVC = nil;
    if (self.selectTag == 0) {
        NSIndexPath *regionIndex = [NSIndexPath indexPathForRow:5 inSection:0];
        NSIndexPath *priceIndex = [NSIndexPath indexPathForRow:3 inSection:0];
        NSIndexPath *areaIndex = [NSIndexPath indexPathForRow:2 inSection:0];
        NSIndexPath *timeIndex = [NSIndexPath indexPathForRow:1 inSection:0];
        NSDictionary *selDictionary = @{SelectViewControllerRegionKey:regionIndex,SelectViewControllerPriceKey:priceIndex,SelectViewControllerAreaKey:areaIndex,SelectViewControllerTimeKey:timeIndex};
        selectVC = [[SelectViewController alloc] initWithSelectDictionary:selDictionary];
        selectVC.view.frame = CGRectMake(0, 116 - 507, 375, 507);
        selectVC.delegate = self;
        [self addChildViewController:selectVC];
        [self.view insertSubview:selectVC.view aboveSubview:self.tableView];
        [UIView animateWithDuration:0.5 animations:^{
            selectVC.view.frame = CGRectMake(0, 116, 375, 507);
        } completion:^(BOOL finished) {
            
        }];
    }
    else{
        selectVC = [[self childViewControllers] firstObject];
        if (self.selectTag == sender.tag) {
            SelectViewController *selectVC = [[self childViewControllers] firstObject];
            [UIView animateWithDuration:0.5 animations:^{
                selectVC.view.frame = CGRectMake(0, 116 - 507, 375, 507);
            } completion:^(BOOL finished) {
                [selectVC.view removeFromSuperview];
                [selectVC removeFromParentViewController];
                self.selectTag = 0;
            }];
            return;
        }
    }
    switch (sender.tag - 1000) {
        case 1:
            selectVC.type = SelectTypeRegion;
            break;
        case 2:
            selectVC.type = SelectTypePrice;
            break;
        case 3:
            selectVC.type = SelectTypeArea;
            break;
        case 4:
            selectVC.type = SelectTypeTime;
            break;
        default:
            break;
            
    }
    self.selectTag = sender.tag;
}

- (void)selectViewController:(SelectViewController *)selectVC didEndSelectionWithResult:(NSDictionary *)resultDic{
    DLog(@"%@",resultDic);
    self.selectTag = 0;
}
@end
