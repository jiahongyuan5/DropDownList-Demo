//
//  ViewController.m
//  SelectType
//
//  Created by gdxjhy on 16/6/21.
//  Copyright © 2016年 com.hongyuan.App. All rights reserved.
//

#import "ViewController.h"
#import "SelectViewController.h"
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
@property (nonatomic, strong) SelectViewController *selectVC;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.selectVC = [[SelectViewController alloc] init];
    self.selectVC.view.frame = CGRectMake(0, 116 - 507, 375, 507);
    self.selectVC.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell" forIndexPath:indexPath];
    return cell;
}

- (IBAction)handleSelectButtonAction:(UIButton *)sender{
    switch (sender.tag - 1000) {
        case 1:
            self.selectVC.type = SelectTypeRegion;
            break;
        case 2:
            self.selectVC.type = SelectTypePrice;
            break;
        case 3:
            self.selectVC.type = SelectTypeArea;
            break;
        case 4:
            self.selectVC.type = SelectTypeTime;
            break;
        default:
            break;
            
    }
    if (self.selectTag == 0) {
        [self addChildViewController:self.selectVC];
        [self.view insertSubview:self.selectVC.view aboveSubview:self.tableView];
        [UIView animateWithDuration:0.5 animations:^{
            self.selectVC.view.frame = CGRectMake(0, 116, 375, 502);
        } completion:^(BOOL finished) {
            
        }];
    }
    else{
        if (self.selectTag == sender.tag) {
            [UIView animateWithDuration:0.5 animations:^{
                self.selectVC.view.frame = CGRectMake(0, 116 - 507, 375, 502);
            } completion:^(BOOL finished) {
                [self.selectVC.view removeFromSuperview];
                [self.selectVC removeFromParentViewController];
                self.selectTag = 0;
            }];
            return;
        }
    }
    self.selectTag = sender.tag;
}

- (void)selectViewController:(SelectViewController *)selectVC didEndSelectionWithResult:(NSDictionary *)resultDic{
    DLog(@"%@",resultDic);
    self.selectTag = 0;
}
@end
