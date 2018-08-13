//
//  OKPay.h
//  OKPaypp
//
//  Created by yuhanle on 07/05/2018.
//
//

#import <Foundation/Foundation.h>
#import "OKPayment.h"
#import "OKPayDefaultConfigurator.h"

NS_ASSUME_NONNULL_BEGIN

@interface OKPay : NSObject

/**
 *  单例支付类
 *
 *  @return 支付对象
 */
+ (instancetype)sharedPay;

/**
 * 支付配置
 */
+ (void)setPayPayDefaultConfigurator:(OKPayDefaultConfigurator *)payDefaultConfigurator;

/**
 *  支付调用接口(支付宝/微信)
 *  说明： *微信支付 success：YES,去后端验证，否则提示用户支付失败信息
 *  注意：不能success=YES，作为用户支付成功的结果，应以服务器端的接收的支付通知或查询API返回的结果为准
 *  @param charge           以kOKPayOrderKey为key的订单，对应的value为格式参考readme说明文档
 *  @param completionBlock  支付结果回调 Block
 */
+ (void)payment:(OKPayment *)payment withOrderInfo:(NSObject *)charge withCompletion:(OKPayppCompletion)completionBlock;

/**
 *  支付调用接口
 *
 *  @param charge           以kOKPayOrderKey为key的订单，对应的value为格式参考readme说明文档
 *  @param viewController   银联渠道需要
 *  @param completionBlock  支付结果回调 Block
 */
+ (void)payment:(OKPayment *)payment withOrderInfo:(NSObject *)charge viewController:(nullable UIViewController *)viewController withCompletion:(OKPayppCompletion)completionBlock;

/**
 回调结果接口（支付宝/微信/测试模式）
 
 @param URL 结果url
 @param application 源应用 Bundle identifier
 @return 当无法处理 URL 或者 URL 格式不正确时，会返回 NO。
 */
+ (BOOL)handleOpenURL:(NSURL *)URL sourceApplication:(nullable NSString *)application;

/**
 * 设置是否是测试环境，银联支付有环境配置
 */
+ (void)setDebugMode:(BOOL)enabled;

/**
 * @brief 检查第三方支付App是否已被用户安装
 *
 * @return 已安装返回YES，未安装返回NO。
 */
+ (BOOL)isAppInstalled;

@end

NS_ASSUME_NONNULL_END
