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
        NSInteger code = [resultDic[@"code"] integerValue];
        OKPayppError *error = nil;
        if (code != 0) {
            error = [[OKPayppError alloc] init];
            error.code = OKPayErrCancelled;
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
        NSInteger code = [resultDic[@"code"] integerValue];
        OKPayppError *error = nil;
        if (code != 0) {
            success = NO;
            error = [[OKPayppError alloc] init];
            error.code = OKPayErrCancelled;
        }else {
            success = YES;
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
