//
//  OKPaymentAlipay.m
//  OKPaypp
//
//  Created by yuhanle on 2018/8/14.
//

#import "OKPaymentAlipay.h"
#import <AlipaySDK/AlipaySDK.h>

@interface OKPaymentAlipay ()

@end

@implementation OKPaymentAlipay

#pragma mark - OKPayment
- (void)prepareWithSettings:(OKPayDefaultConfigurator *)payDefaultConfigurator {
    self.appScheme = payDefaultConfigurator.appScheme;
}

- (NSObject *)generatePayOrder:(NSObject *)charge {
    if ([charge isKindOfClass:[NSDictionary class]]) {
        return ((NSDictionary *)charge)[kOKPayOrderKey];
    }
    if ([charge isKindOfClass:[NSString class]]) {
        NSString *json = (NSString *)charge;
        NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (dict) {
            return dict[kOKPayOrderKey];
        }
    }
    return nil;
}

- (void)jumpToPay:(NSObject *)order result:(OKPayppCompletion)completionBlock {
    [self jumpToPay:order viewController:nil result:completionBlock];
}

- (void)jumpToPay:(NSObject *)order viewController:(nullable UIViewController*)viewController result:(OKPayppCompletion)completionBlock {
    self.payCompletionBlock = completionBlock;
    
    [[AlipaySDK defaultService] payOrder:(NSString *)order fromScheme:self.appScheme callback:^(NSDictionary *resultDic) {
        NSString *result = resultDic[@"result"];
        NSInteger code = [resultDic[@"resultStatus"] integerValue];
        OKPayppError *error = nil;
        if (code == 9000) {
            // 支付成功
            
        }else {
            // 支付失败
            error = [[OKPayppError alloc] init];
            if (code == 8000) {
                //正在处理中，支付结果未知（有可能已经支付成功）,请查询商户订单列表中订单的支付状态
                error.code = OKPayErrProcessing;
            }else if (code == 4000) {
                // 支付失败
                error.code = OKPayErrChannelReturnFail;
            }else if (code == 5000) {
                // 重复请求
                error.code = OKPayErrInvalidCharge;
            }else if (code == 6001) {
                // 用户中途取消
                error.code = OKPayErrCancelled;
            }else if (code == 6002) {
                // 网络连接出错
                error.code = OKPayErrConnectionError;
            }else if (code == 6004) {
                // 支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
                error.code = OKPayErrRequestTimeOut;
            }else {
                // 其他错误
                error.code = OKPayErrUnknownError;
            }
        }
        
        if (self.payCompletionBlock) {
            self.payCompletionBlock(result, error);
        }
    }];
}

#pragma mark - Public Method
- (BOOL)handleOpenURL:(NSURL *)url withCompletion:(OKPayppCompletion)completion {
    __block BOOL success = NO;
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSString *result = resultDic[@"result"];
        NSInteger code = [resultDic[@"resultStatus"] integerValue];
        OKPayppError *error = nil;
        if (code == 9000) {
            // 支付成功
            success = YES;
        }else {
            // 支付失败
            error = [[OKPayppError alloc] init];
            if (code == 8000) {
                //正在处理中，支付结果未知（有可能已经支付成功）,请查询商户订单列表中订单的支付状态
                error.code = OKPayErrProcessing;
            }else if (code == 4000) {
                // 支付失败
                error.code = OKPayErrChannelReturnFail;
            }else if (code == 5000) {
                // 重复请求
                error.code = OKPayErrInvalidCharge;
            }else if (code == 6001) {
                // 用户中途取消
                error.code = OKPayErrCancelled;
            }else if (code == 6002) {
                // 网络连接出错
                error.code = OKPayErrConnectionError;
            }else if (code == 6004) {
                // 支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
                error.code = OKPayErrRequestTimeOut;
            }else {
                // 其他错误
                error.code = OKPayErrUnknownError;
            }
        }
        
        if (self.payCompletionBlock) {
            self.payCompletionBlock(result, error);
        }
        
        if (completion) {
            completion(result, error);
        }
    }];
    
    return success;
}

@end
