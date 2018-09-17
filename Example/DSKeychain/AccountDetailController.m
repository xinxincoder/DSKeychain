//
//  AccountDetailController.m
//  KeychainManager
//
//  Created by XXL on 2017/5/9.
//  Copyright © 2017年 CustomUI. All rights reserved.
//

#import "AccountDetailController.h"
#import <DSKeychain/DSKeychain-umbrella.h>

@interface AccountDetailController ()

@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveItem;

@property (strong, nonatomic) IBOutlet UITextField *accountTextField;

@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation AccountDetailController

- (IBAction)accountAciton:(UITextField *)sender {
    
    if (sender.text.length > 0 && self.passwordTextField.text.length > 0) {
        
        self.saveItem.enabled = YES;
        
    }else {
        
        self.saveItem.enabled = NO;
    }
}

- (IBAction)passwordAction:(UITextField *)sender {
    
    if (sender.text.length > 0 && self.accountTextField.text.length > 0) {
        
        self.saveItem.enabled = YES;
        
    }else {
        
        self.saveItem.enabled = NO;
    }

}
- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)saveAction:(UIBarButtonItem *)sender {
    
    [[DSKeychainManager sharedInstance] saveAccount:self.accountTextField.text password:self.passwordTextField.text];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.saveItem.enabled = NO;
    
    if (self.account) {
        
        NSString *password = [[DSKeychainManager sharedInstance] passwordWithAccount:self.account];
        
        self.accountTextField.text = self.account;
        self.passwordTextField.text = password;
    }
    
  
}


@end
