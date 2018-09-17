//
//  DSKeychainManager.m
//  KeychainManager
//
//  Created by XXL on 2017/5/8.
//  Copyright © 2017年 EasyMoveMobile. All rights reserved.
//

#import "DSKeychainManager.h"

static NSString * const SERVICE = @"KEYCHAIN_SERVICE";
static NSString * const STORESERVICE = @"KEYCHAIN_STORESERVICE";

@interface DSKeychainManager ()

/** 主要用于区分keychain */
@property (nonatomic, copy) NSString *service;

@property (nonatomic, strong) DSKeychainItem *keychainItem;

@end

@implementation DSKeychainManager

/** 初始化 */
+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    static DSKeychainManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[DSKeychainManager alloc] init];
        manager.service = SERVICE;
        [manager initData];
    });
    return manager;
}

- (void)initData {
    
    DSKeychainItem *keychainItem = [[DSKeychainItem alloc] initWithService:SERVICE accessgroup:self.accessGroup];
    keychainItem.storeService = STORESERVICE;
    self.keychainItem = keychainItem;
}

- (void)setAccessGroup:(NSString *)accessGroup {
    _accessGroup = accessGroup;
    
    self.keychainItem.accessgroup = _accessGroup;
}

- (void)saveAccount:(NSString *_Nonnull)account password:(NSString *_Nonnull)password {
    
    NSString *oldPassword = [self.keychainItem queryPasswordWithAccount:account];
    
    if (oldPassword && ![oldPassword isEqualToString:@""]) {
        
        [self.keychainItem updateItemWithAccount:account password:password];
        
    }else {
        
        [self.keychainItem addItemWithAccount:account password:password];
    }
}

- (void)deleteAccount:(NSString *_Nonnull)account {
    
    [self.keychainItem deleteItemWithAccount:account];
}

- (void)deleteAllAcount {
    
    [self.keychainItem deleteItemWithAccount:nil];
}

- (NSString *_Nonnull)passwordWithAccount:(NSString *_Nonnull)acount {
    
    return [self.keychainItem queryPasswordWithAccount:acount];
}

- (NSArray <DSKeychainItem *>*_Nonnull)allAccountPassword {
    
    return [self.keychainItem queryPasswordWithAccount:nil];
}

@end


@implementation DSKeychainManager (StoreAnyObject)

- (void)saveObject:(id _Nonnull)object forKey:(NSString *_Nonnull)key {
    
    [self.keychainItem saveObject:object forKey:key];
}

- (id _Nonnull)objectForKey:(NSString *_Nonnull)key {
    
    return [self.keychainItem objectForKey:key];
}

- (void)removeObjectForKey:(NSString *_Nonnull)key {
    
    [self.keychainItem removeObjectForKey:key];
}

- (void)removeAll {
    
    [self.keychainItem removeObjectForKey:nil];
}

@end
