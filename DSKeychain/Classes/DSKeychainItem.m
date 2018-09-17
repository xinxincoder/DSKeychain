//
//  DSKeychainItem.m
//  KeychainManager
//
//  Created by XXL on 2017/5/9.
//  Copyright © 2017年 EasyMoveMobile. All rights reserved.
//

#import "DSKeychainItem.h"
#import <objc/runtime.h>

@interface DSKeychainItem ()

@property (nonatomic, copy) NSString *_Nullable account;
@property (nonatomic, copy) NSString *_Nullable password;
@property (nonatomic, copy) NSString *_Nonnull service;

@end

@implementation DSKeychainItem

- (instancetype _Nonnull)initWithService:(NSString * _Nonnull)service accessgroup:(NSString * _Nullable)accessgroup {
    self = [super init];
    if (self) {
        
        self.service = service;
        self.accessgroup = accessgroup;
        
    }
    return self;
}


- (NSMutableDictionary *)keychainItem {
    
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    [keychainItem setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    if (self.service) {
        
         [keychainItem setObject:self.service forKey:(__bridge id)kSecAttrService];
    }
    
    if (self.accessgroup) {
        
        [keychainItem setObject:self.accessgroup forKey:(__bridge id)kSecAttrAccessGroup];
    }

    return keychainItem;
}


#pragma mark - 增删改查
- (void)addItemWithAccount:(NSString * _Nonnull)account password:(NSString * _Nonnull)password {
    
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *keychainItem = [self keychainItem];
    [keychainItem setObject:account forKey:(__bridge id)kSecAttrAccount];
    [keychainItem setObject:passwordData forKey:(__bridge id)kSecValueData];
    
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)keychainItem, nil);
    [self printLogWithStatus:status tip:@"添加"];
}

- (void)deleteItemWithAccount:(NSString * _Nullable)account {
    
    NSMutableDictionary *keychainItem = [self keychainItem];
    
    if (account) {
    
        [keychainItem setObject:account forKey:(__bridge id)kSecAttrAccount];
    }
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)keychainItem);
    [self printLogWithStatus:status tip:@"删除"];
}

- (void)updateItemWithAccount:(NSString * _Nonnull)account password:(NSString * _Nonnull)password {
    
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *keychainItem = [self keychainItem];
    [keychainItem setObject:account forKey:(__bridge id)kSecAttrAccount];
    
    NSMutableDictionary *update = [NSMutableDictionary dictionary];
    [update setObject:passwordData forKey:(__bridge id)kSecValueData];
    
    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)keychainItem, (__bridge CFDictionaryRef)update);
    [self printLogWithStatus:status tip:@"更新"];
    
}

- (id _Nonnull)queryPasswordWithAccount:(NSString *_Nullable)acount {
    
    NSMutableDictionary *keychainItem = [self keychainItem];
    
    if (acount) {
        
        [keychainItem setObject:acount forKey:(__bridge id)kSecAttrAccount];
        [keychainItem setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    }else {
        
        [keychainItem setObject:(__bridge id)kSecMatchLimitAll forKey:(__bridge id)kSecMatchLimit];
        [keychainItem setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnRef];
    }
    
    [keychainItem setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    
    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, &result);
    
    if (acount) {
        
        NSString *password = nil;
        NSData *passwordData = (__bridge NSData *)result;
        password = [[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding];
        return password;
    }
    
    NSMutableArray *keychainItems = [NSMutableArray array];
    if (status == noErr) {
        
        NSArray *array = (__bridge NSArray *)result;
        
        for (NSDictionary *dic in array) {
            
            NSString *account = dic[(id)kSecAttrAccount];
            NSData *passwordData = dic[(id)kSecValueData];
            NSString *password = [[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding];
            NSString *service = dic[(id)kSecAttrService];
            NSLog(@"dic = %@,account = %@,password = %@,service = %@",dic,account,password,service);
            
            DSKeychainItem *keychainItem = [[DSKeychainItem alloc] init];
            keychainItem.account = account;
            keychainItem.password = password;
            [keychainItems addObject:keychainItem];
            
        }
    }
    
    return keychainItems;
}

- (void)printLogWithStatus:(OSStatus)status tip:(NSString *)tip {
    
    NSString *result = nil;
    
    if (status == noErr) {
        
        result = @"成功";
        
    }else {
        
        result = @"失败";
    }
    
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",tip,result]);
}

@end

@implementation DSKeychainItem (StoreAnyObject)
- (NSString *)storeService {
    
    return objc_getAssociatedObject(self, _cmd);
    
}

- (void)setStoreService:(NSString *)storeService {
    
    objc_setAssociatedObject(self, @selector(storeService), storeService, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSMutableDictionary *)storeKeychainItem {
    
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    [keychainItem setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    if (self.storeService) {
        
        [keychainItem setObject:self.storeService forKey:(__bridge id)kSecAttrService];
    }
    
    if (self.accessgroup) {
        
        [keychainItem setObject:self.accessgroup forKey:(__bridge id)kSecAttrAccessGroup];
    }
    
    return keychainItem;
}

- (void)saveObject:(id _Nonnull)object forKey:(NSString *_Nonnull)key {
    
    id obj = [self objectForKey:key];
    
    if (obj) {
        
        NSMutableDictionary *keychainItem = [self storeKeychainItem];
        [keychainItem setObject:key forKey:(__bridge id)kSecAttrAccount];
        
        NSMutableDictionary *update = [NSMutableDictionary dictionary];
        [keychainItem setObject:[NSKeyedArchiver archivedDataWithRootObject:object] forKey:(__bridge id)kSecValueData];
        
        OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)keychainItem, (__bridge CFDictionaryRef)update);
        [self printLogWithStatus:status tip:@"更新"];
        
    }else {
        
        NSMutableDictionary *keychainItem = [self storeKeychainItem];
        [keychainItem setObject:key forKey:(__bridge id)kSecAttrAccount];
        [keychainItem setObject:[NSKeyedArchiver archivedDataWithRootObject:object] forKey:(__bridge id)kSecValueData];
        OSStatus status = SecItemAdd((__bridge CFDictionaryRef)keychainItem, nil);
        [self printLogWithStatus:status tip:@"添加"];
    }
}

- (id _Nonnull)objectForKey:(NSString *_Nonnull)key {
    
    NSMutableDictionary *keychainItem = [self storeKeychainItem];
    [keychainItem setObject:key forKey:(__bridge id)kSecAttrAccount];
    [keychainItem setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [keychainItem setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, &result);
    
    id resultObject = nil;
    
    if (status == noErr) {
        
        NSData *data = (__bridge NSData *)result;
        resultObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return resultObject;
}

- (void)removeObjectForKey:(NSString *_Nullable)key {
    
     NSMutableDictionary *keychainItem = [self storeKeychainItem];
    
    if (key && ![key isEqualToString:@""]) {
        
        [keychainItem setObject:key forKey:(__bridge id)kSecAttrAccount];
    }
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)keychainItem);
    [self printLogWithStatus:status tip:@"删除"];
}

@end
