//
//  DSKeychainManager.h
//  KeychainManager
//
//  Created by XXL on 2017/5/8.
//  Copyright © 2017年 EasyMoveMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSKeychainItem.h"

@interface DSKeychainManager : NSObject

@property (nonatomic, copy, readonly, nullable) NSString *account;

@property (nonatomic, copy, readonly, nullable) NSString *password;

/** 经测试不用设置这个也能共享,只需打开Capabilities的keychain Sharing即可（keychain groups共享的APP要一样） */
@property (nonatomic, copy, nullable) NSString * accessGroup;

/** 初始化 */
+ (instancetype _Nullable )sharedInstance;

/**
 保存账号密码

 @param account 账号
 @param password 密码
 */
- (void)saveAccount:(NSString *_Nonnull)account password:(NSString *_Nonnull)password;

/**
 删除账号

 @param account 账号
 */
- (void)deleteAccount:(NSString *_Nonnull)account;

/**
 删除所有账号
 */
- (void)deleteAllAcount;

/**
 查询密码根据账号

 @param acount 账号
 @return 密码
 */
- (NSString *_Nonnull)passwordWithAccount:(NSString *_Nonnull)acount;


/**
 查询所有的账号密码

 @return DSKeychainItem对象数组
 */
- (NSArray <DSKeychainItem *>*_Nonnull)allAccountPassword;

@end


@interface DSKeychainManager (StoreAnyObject)

/**
 根据键值保存对象

 @param object 对象
 @param key 键值
 */
- (void)saveObject:(id _Nonnull)object forKey:(NSString *_Nonnull)key;

/**
 根据键值找到对象

 @param key 键值
 @return 对象
 */
- (id _Nonnull)objectForKey:(NSString *_Nonnull)key;

/**
 根据键值删除对应的对象

 @param key 键值
 */
- (void)removeObjectForKey:(NSString *_Nonnull)key;

/**
 删除所有
 */
- (void)removeAll;

@end
