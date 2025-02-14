//
//  OKPayment.h
//  OKPaypp
//
//  Created by yuhanle on 07/05/2018.
//
//

#import <Foundation/Foundation.h>
#import "OKPayDefaultConfigurator.h"
#import "OKPaypp.h"

#ifdef DEBUG
#define OKPayppLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define OKPayppLog(...)
#endif

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kOKPayOrderKey;

@protocol OKPayment <NSObject>

@required

- (void)prepareWithSettings:(OKPayDefaultConfigurator *)payDefaultConfigurator;

/**
 *  生成支付订单
 *
 *  @param charge Charge 对象(JSON 格式字符串 或 NSDictionary)
 */
- (NSObject *)generatePayOrder:(NSObject *)charge;

/**
 去支付

 @param order 订单信息
 @param completionBlock 支付结果回调
 */
- (void)jumpToPay:(NSObject *)order result:(OKPayppCompletion)completionBlock;

/**
 去支付

 @param order 订单信息
 @param viewController 当前业务
 @param completionBlock 支付结果回调
 */
- (void)jumpToPay:(NSObject *)order viewController:(nullable UIViewController*)viewController result:(OKPayppCompletion)completionBlock;

@optional

/*! @brief 检查第三方支付App是否已被用户安装
 *
 * @return 已安装返回YES，未安装返回NO。
 */
- (BOOL)isAppInstalled;

/**
 处理支付结果
 
 @param url 支付结果信息
 @param completion 支付结果回调 Block，保证跳转支付过程中，当 app 被 kill 掉时，能通过这个接口得到支付结果
 @return 处理结果
 */
- (BOOL)handleOpenURL:(NSURL *)url withCompletion:(OKPayppCompletion)completion;

/**
 注册APPId

 @param appid appid
 @return 注册结果
 */
- (BOOL)registerApp:(NSString *)appid;

/**
 设置开发模式

 @param enabled 开启关闭
 */
- (void)setDebugMode:(BOOL)enabled;

@end

NS_ASSUME_NONNULL_END
