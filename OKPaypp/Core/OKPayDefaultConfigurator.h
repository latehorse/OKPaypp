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

@end

NS_ASSUME_NONNULL_END

