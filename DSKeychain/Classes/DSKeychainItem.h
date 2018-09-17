//
//  DSKeychainItem.h
//  KeychainManager
//
//  Created by XXL on 2017/5/9.
//  Copyright © 2017年 EasyMoveMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSKeychainItem : NSObject

@property (nonatomic, copy, readonly) NSString * _Nullable account;

@property (nonatomic, copy, readonly) NSString * _Nullable password;

@property (nonatomic, copy) NSString *_Nullable accessgroup;

- (instancetype _Nonnull)initWithService:(NSString * _Nonnull)service accessgroup:(NSString * _Nullable)accessgroup;

/**增
 添加keychainItem

 @param account 账号
 @param password 密码
 */
- (void)addItemWithAccount:(NSString * _Nonnull)account password:(NSString * _Nonnull)password;

/**删
 通过账号删除keychainItem，如果账号为空，则删除全部

 @param account 账号
 */
- (void)deleteItemWithAccount:(NSString * _Nullable)account;

/**改
 更新keychainItem

 @param account 账号
 @param password 密码
 */
- (void)updateItemWithAccount:(NSString * _Nonnull)account password:(NSString * _Nonnull)password;

/**查
 通过账号查询密码,如果账号为空，则查全部
 
 @param acount 账号
 */
- (id _Nonnull)queryPasswordWithAccount:(NSString *_Nullable)acount;

@end

@interface DSKeychainItem (StoreAnyObject)

/** 保存任何对象的用同一个storeService */
@property (nonatomic, copy) NSString * _Nonnull storeService;

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
 根据键值删除对应的对象,如果键值为空则删除所有
 
 @param key 键值
 */
- (void)removeObjectForKey:(NSString *_Nullable)key;

@end

