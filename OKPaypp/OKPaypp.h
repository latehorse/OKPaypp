//
//  OKPaypp.h
//  OKPaypp
//
//  Created by yuhanle on 07/05/2018.
//
//

#ifndef OKPaypp_h
#define OKPaypp_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "OKPayDefaultConfigurator.h"

typedef NS_ENUM(NSUInteger, OKPayErrorOption)
{
    OKPayErrInvalidCharge,
    OKPayErrInvalidCredential,
    OKPayErrInvalidChannel,
    OKPayErrWxNotInstalled,
    OKPayErrWxAppNotSupported,
    OKPayErrCancelled,
    OKPayErrUnknownCancel,
    OKPayErrViewControllerIsNil,
    OKPayErrTestmodeNotifyFailed,
    OKPayErrChannelReturnFail,
    OKPayErrConnectionError,
    OKPayErrUnknownError,
    OKPayErrActivation,
    OKPayErrRequestTimeOut,
    OKPayErrProcessing,
    OKPayErrQqNotInstalled,
};

typedef NS_ENUM(NSUInteger, OKPayChannle) {
    OKPayChannleAlipay,     //!< 支付宝支付 默认
    OKPayChannleWx,         //!< 微信支付
    OKPayChannleUnionPay,   //!< 银联支付
};

@interface OKPayppError : NSObject

@property (nonatomic, assign) OKPayErrorOption code;

- (NSString *)getMsg;

@end


typedef void (^OKPayppCompletion)(NSString *result, OKPayppError *error);


@class OKPayDefaultConfigurator;
@interface OKPaypp : NSObject

/**
 * 支付配置
 */
+ (void)setPayPayDefaultConfigurator:(OKPayDefaultConfigurator *)payDefaultConfigurator;

/**
 支付调用接口

 @param charge Charge 对象(JSON 格式字符串 或 NSDictionary)
 @param viewController 银联渠道需要
 @param scheme URL Scheme，支付宝渠道需要
 @param completionBlock 支付结果回调
 */
+ (void)createPayment:(NSObject *)charge viewController:(UIViewController *)viewController appURLScheme:(NSString *)scheme withCompletion:(OKPayppCompletion)completionBlock;

/**
支付调用接口

@param charge Charge 对象(JSON 格式字符串 或 NSDictionary)
@param channel 支付渠道
@param viewController 银联渠道需要
@param scheme URL Scheme，支付宝渠道需要
@param completionBlock 支付结果回调
*/
+ (void)createPayment:(NSObject *)charge channel:(OKPayChannle)channel viewController:(UIViewController *)viewController appURLScheme:(NSString *)scheme withCompletion:(OKPayppCompletion)completionBlock;

/**
 支付调用接口（支付宝/微信）

 @param charge Charge 对象（JSON 格式字符串 或 NSDictionary）
 @param scheme URL Scheme，支付宝渠道回调需要
 @param completionBlock 支付结果回调
 */
+ (void)createPatment:(NSObject *)charge appURLScheme:(NSString *)scheme withCompletion:(OKPayppCompletion)completionBlock;

/**
 回调结果接口（支付宝/微信/测试模式）

 @param url 结果url
 @param completion 支付结果回调 Block，保证跳转支付过程中，当 app 被 kill 掉时，能通过这个接口得到支付结果
 @return 当无法处理 URL 或者 URL 格式不正确时，会返回 NO。
 */
+ (BOOL)handleOpenURL:(NSURL *)url withCompletion:(OKPayppCompletion)completion;

/**
 回调结果接口（支付宝/微信/测试模式）

 @param url 结果url
 @param sourceApplication 源应用 Bundle identifier
 @param completion 支付结果回调 Block，保证跳转支付过程中，当 app 被 kill 掉时，能通过这个接口得到支付结果
 @return 当无法处理 URL 或者 URL 格式不正确时，会返回 NO。
 */
+ (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication withCompletion:(OKPayppCompletion)completion;

/**
 版本号

 @return OKPaypp SDK 版本号
 */
+ (NSString *)version;

/**
 *  设置 Debug 模式
 *
 *  @param enabled    是否启用
 */
+ (void)setDebugMode:(BOOL)enabled;

@end

#endif /* OKPaypp_h */
