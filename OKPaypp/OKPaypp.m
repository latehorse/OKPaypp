//
//  OKPaypp.m
//  OKPaypp
//
//  Created by yuhanle on 2018/8/1.
//

#import "OKPaypp.h"
#import "OKPayment.h"

NSString * const kOKPaySuccessMessage   = @"订单支付成功";
NSString * const kOKPayFailureMessage   = @"订单支付失败";
NSString * const kOKPayCancelMessage    = @"用户中途取消";

@interface OKPaypp ()

@property (nonatomic, strong) id <OKPayment> payment;
@property (nonatomic, strong) OKPayDefaultConfigurator *payDefaultConfigurator;

@end

@implementation OKPaypp

+ (instancetype)sharedPay {
    static dispatch_once_t onceToken;
    static OKPaypp *instance;
    dispatch_once(&onceToken, ^{
        instance = [[OKPaypp alloc] init];
    });
    return instance;
}

#pragma mark - Public Method
+ (void)setPayPayDefaultConfigurator:(OKPayDefaultConfigurator *)payDefaultConfigurator {
    [[OKPaypp sharedPay] setPayDefaultConfigurator:payDefaultConfigurator];
}

+ (void)createPayment:(NSObject *)charge viewController:(UIViewController *)viewController appURLScheme:(NSString *)scheme withCompletion:(OKPayppCompletion)completionBlock {
    [self createPayment:charge channel:OKPayChannleAlipay viewController:viewController appURLScheme:scheme withCompletion:completionBlock];
}

+ (void)createPayment:(NSObject *)charge channel:(OKPayChannle)channel viewController:(UIViewController *)viewController appURLScheme:(NSString *)scheme withCompletion:(OKPayppCompletion)completionBlock {
    [[OKPaypp sharedPay] createPayment:charge channel:channel viewController:viewController appURLScheme:scheme withCompletion:completionBlock];
}

+ (void)createPatment:(NSObject *)charge appURLScheme:(NSString *)scheme withCompletion:(OKPayppCompletion)completionBlock {
    [self createPayment:charge viewController:nil appURLScheme:scheme withCompletion:completionBlock];
}

+ (BOOL)handleOpenURL:(NSURL *)url withCompletion:(OKPayppCompletion)completion {
    return [[OKPaypp sharedPay].payment handleOpenURL:url withCompletion:completion];
}

+ (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication withCompletion:(OKPayppCompletion)completion {
    return [[OKPaypp sharedPay].payment handleOpenURL:url withCompletion:completion];;
}

+ (NSString *)version {
    return @"0.1.0";
}

+ (void)setDebugMode:(BOOL)enabled {
    [[OKPaypp sharedPay].payment setDebugMode:enabled];
}

#pragma mark - Pravite Method
- (void)createPayment:(NSObject *)charge channel:(OKPayChannle)channel viewController:(UIViewController *)viewController appURLScheme:(NSString *)scheme withCompletion:(OKPayppCompletion)completionBlock {
    /**
     *
     * 此处需要根据charge 字段来判断渠道信息
     * 示例中：我们暂时使用 scheme 字段区分，只有支付宝需要这个字段
     */
    if (channel == OKPayChannleAlipay) {
        // 支付宝支付
#if __has_include(<OKPaypp/OKPaymentAlipay.h>)
        self.payment = [[NSClassFromString(@"OKPaymentAlipay") alloc] init];
        [self.payment prepareWithSettings:self.payDefaultConfigurator];
        [self.payment jumpToPay:[self.payment generatePayOrder:charge] result:completionBlock];
#else
        OKPayppLog(@"Alipay error: please import Alipay sdk.");
        OKPayppError *error = [[OKPayppError alloc] init];
        error.code = OKPayErrInvalidChannel;
        
        if (completionBlock) {
            completionBlock(nil, error);
        }
#endif
    }else if (channel == OKPayChannleWx) {
        // 微信支付
#if __has_include(<OKPaypp/OKPaymentWx.h>)
        self.payment = [[NSClassFromString(@"OKPaymentWx") alloc] init];
        [self.payment prepareWithSettings:self.payDefaultConfigurator];
        [self.payment jumpToPay:[self.payment generatePayOrder:charge] result:completionBlock];
#else
        OKPayppLog(@"Wxpay error: please import Wxpay sdk.");
        OKPayppError *error = [[OKPayppError alloc] init];
        error.code = OKPayErrInvalidChannel;
        
        if (completionBlock) {
            completionBlock(nil, error);
        }
#endif
    }else if (channel == OKPayChannleUnionPay) {
        // 银联支付
#if __has_include(<OKPaypp/OKPaymentUnionPay.h>)
        self.payment = [[NSClassFromString(@"OKPaymentUnionPay") alloc] init];
        [self.payment prepareWithSettings:self.payDefaultConfigurator];
        [self.payment jumpToPay:[self.payment generatePayOrder:charge] viewController:viewController result:completionBlock];
#else
        OKPayppLog(@"Unionpay error: please import Unionpay sdk.");
        OKPayppError *error = [[OKPayppError alloc] init];
        error.code = OKPayErrInvalidChannel;
        
        if (completionBlock) {
            completionBlock(nil, error);
        }
#endif
    }
}

@end

@implementation OKPayppError

- (NSString *)getMsg {
    switch (self.code) {
        case OKPayErrInvalidCharge:
            return @"无效支付信息";
            break;
        case OKPayErrInvalidCredential:
            return @"无效信用卡";
            break;
        case OKPayErrInvalidChannel:
            return @"无效支付渠道";
            break;
        case OKPayErrWxNotInstalled:
            return @"微信未安装";
            break;
        case OKPayErrWxAppNotSupported:
            return @"微信不支持此功能";
            break;
        case OKPayErrCancelled:
            return @"用户中途取消";
            break;
        case OKPayErrUnknownCancel:
            return @"未知原因取消";
            break;
        case OKPayErrViewControllerIsNil:
            return @"viewController 不能为 nil";
            break;
        case OKPayErrTestmodeNotifyFailed:
            return @"测试模式通知失败";
            break;
        case OKPayErrChannelReturnFail:
            return @"渠道返回错误";
            break;
        case OKPayErrConnectionError:
            return @"连接错误";
            break;
        case OKPayErrUnknownError:
            return @"未知错误";
            break;
        case OKPayErrActivation:
            return @"激活错误";
            break;
        case OKPayErrRequestTimeOut:
            return @"请求超时";
            break;
        case OKPayErrProcessing:
            return @"处理错误";
            break;
        case OKPayErrQqNotInstalled:
            return @"QQ未安装";
            break;
        default:
            break;
    }
    return @"未知错误";
}

@end
