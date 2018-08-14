//
//  OKPaymentAlipay.h
//  OKPaypp
//
//  Created by yuhanle on 2018/8/14.
//

#import <Foundation/Foundation.h>
#import <OKPaypp/OKPayment.h>

@interface OKPaymentAlipay : NSObject

//应用注册scheme,在AlixPayDemo-Info.plist定义URL types
@property (nonatomic, strong) NSString *appScheme;
//支付结果回调
@property (nonatomic, copy) OKPayppCompletion payCompletionBlock;

@end
