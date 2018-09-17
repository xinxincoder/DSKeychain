//
//  AllAccountController.m
//  KeychainManager
//
//  Created by XXL on 2017/5/9.
//  Copyright © 2017年 CustomUI. All rights reserved.
//

#import "AllAccountController.h"
#import <DSKeychain/DSKeychain-umbrella.h>
#import "AccountDetailController.h"

static NSString *const ReuseIdentifier = @"ReuseIdentifier";

@interface AllAccountController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) IBOutlet UIButton *strBtn;
@property (strong, nonatomic) IBOutlet UIButton *dicBtn;
@property (strong, nonatomic) IBOutlet UIButton *arrBtn;
@property (strong, nonatomic) IBOutlet UIButton *numBtn;
@property (strong, nonatomic) IBOutlet UIButton *dateBtn;

@end

@implementation AllAccountController

- (IBAction)storeAnyObject:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    id object = nil;
    
    if ([sender.currentTitle isEqualToString:@"NSString"]) {
        
        object = @"this is a string";
    }
    
    if ([sender.currentTitle isEqualToString:@"NSDictionary"]) {
        
        object = @{@"123":@"qwe",@"234":@"wer"};
    }
    if ([sender.currentTitle isEqualToString:@"NSArray"]) {
        
        object = @[@"123",@"234",@"345"];
    }
    if ([sender.currentTitle isEqualToString:@"NSNumber"]) {
        
        object = @(YES);
    }
    if ([sender.currentTitle isEqualToString:@"NSDate"]) {
        
        object = [NSDate date];
    }
    
    if (sender.selected) {
        
        [[DSKeychainManager sharedInstance] saveObject:object forKey:sender.currentTitle];
        
    }else {
        
        [[DSKeychainManager sharedInstance] removeObjectForKey:sender.currentTitle];
    }
    
    NSLog(@"object = %@",object);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    NSString *str = [[DSKeychainManager sharedInstance] objectForKey:@"NSString"];
    self.strBtn.selected = str;
    NSLog(@"str = %@",str);
    
    NSDictionary *dic = [[DSKeychainManager sharedInstance] objectForKey:@"NSDictionary"];
    self.dicBtn.selected = dic;
    NSLog(@"dic = %@",dic);
    
    NSArray *arr = [[DSKeychainManager sharedInstance] objectForKey:@"NSArray"];
    self.arrBtn.selected = arr;
    NSLog(@"arr = %@",arr);
    
    NSNumber *num = [[DSKeychainManager sharedInstance] objectForKey:@"NSNumber"];
    self.numBtn.selected = num;
    NSLog(@"num = %@",num);
    
    NSDate *date = [[DSKeychainManager sharedInstance] objectForKey:@"NSDate"];
    self.dateBtn.selected = date;
    NSLog(@"date = %@",date);
        
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:ReuseIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSArray *array = [[DSKeychainManager sharedInstance] allAccountPassword];
    
    NSLog(@"%@",array);
    
    [self.tableview reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[DSKeychainManager sharedInstance] allAccountPassword].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    DSKeychainItem *item = [[DSKeychainManager sharedInstance] allAccountPassword][indexPath.row];
    ;
    cell.textLabel.text = item.account;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    DSKeychainItem *item = [[DSKeychainManager sharedInstance] allAccountPassword][indexPath.row];
    ;
    UIStoryboard *storyboard  = [UIStoryboard storyboardWithName:@"Keychain" bundle:nil];
    
    AccountDetailController *controller = [storyboard instantiateViewControllerWithIdentifier:@"AccountDetailController"];
    controller.account = item.account;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:navi animated:YES completion:NULL];
    
}

@end
