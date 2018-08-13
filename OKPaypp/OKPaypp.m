//
//  OKPaypp.m
//  OKPaypp
//
//  Created by yuhanle on 2018/8/1.
//

#import "OKPaypp.h"
#import "OKPay.h"

NSString * const kOKPaySuccessMessage           = @"订单支付成功";
NSString * const kOKPayFailureMessage           = @"订单支付失败";
NSString * const kOKPayCancelMessage            = @"用户中途取消";

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

@implementation OKPaypp

+ (void)setPayPayDefaultConfigurator:(OKPayDefaultConfigurator *)payDefaultConfigurator {
    [OKPay setPayPayDefaultConfigurator:payDefaultConfigurator];
}

+ (void)createPayment:(NSObject *)charge viewController:(UIViewController *)viewController appURLScheme:(NSString *)scheme withCompletion:(OKPayppCompletion)completionBlock {
    OKPayment *payment = [[OKPayment alloc] init];
    [OKPay payment:payment withOrderInfo:charge withCompletion:completionBlock];
}

+ (void)createPatment:(NSObject *)charge appURLScheme:(NSString *)scheme withCompletion:(OKPayppCompletion)completionBlock {
    [self createPayment:charge viewController:nil appURLScheme:scheme withCompletion:completionBlock];
}

+ (BOOL)handleOpenURL:(NSURL *)url withCompletion:(OKPayppCompletion)completion {
    return [OKPay handleOpenURL:url sourceApplication:@""];
}

+ (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication withCompletion:(OKPayppCompletion)completion {
    return [OKPay handleOpenURL:url sourceApplication:sourceApplication];
}

+ (NSString *)version {
    return @"0.1.0";
}

+ (void)setDebugMode:(BOOL)enabled {
    [OKPay setDebugMode:enabled];
}

@end


