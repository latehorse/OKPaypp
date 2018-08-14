//
//  OKPayDefaultConfigurator.h
//  OKPaypp
//
//  Created by yuhanle on 07/05/2018.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OKPayDefaultConfigurator : NSObject

//应用注册scheme,在AlixPayDemo-Info.plist定义URL types
@property (nonatomic, strong) NSString *appScheme;

#if __has_include(<OKPaypp/OKPaymentWx.h>)

//微信支付

/**
 *  微信支付的AppId
 */
@property (nonatomic, copy) NSString *wxPayAppId;

/**
 *  appdesc 应用附加信息，长度不超过1024字节
 */
@property (nonatomic, copy, nullable) NSString *WXAppdesc;

#endif

#if __has_include(<OKPaypp/OKPaymentUnionPay.h>)
//标识运行环境 00 代表接入生产环境（正式版本需要） 01 代表接入开发测试环境（测试版本需要）
@property (nonatomic, strong) NSString *tnmode;
#endif

@end

NS_ASSUME_NONNULL_END

