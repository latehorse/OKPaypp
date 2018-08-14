//
//  OKPaymentUnionPay.h
//  OKPaypp
//
//  Created by yuhanle on 2018/8/14.
//

#import <Foundation/Foundation.h>
#import <OKPaypp/OKPayment.h>

@interface OKPaymentUnionPay : NSObject <OKPayment>

//应用注册scheme,在AlixPayDemo-Info.plist定义URL types
@property (nonatomic, strong) NSString *appScheme;
//标识运行环境 00 代表接入生产环境（正式版本需要） 01 代表接入开发测试环境（测试版本需要）
@property (nonatomic, strong) NSString *tnmode;
//支付结果回调
@property (nonatomic, copy) OKPayppCompletion payCompletionBlock;

@end
