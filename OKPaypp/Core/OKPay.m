//
//  OKPay.m
//  OKPaypp
//
//  Created by yuhanle on 07/05/2018.
//
//

#import "OKPay.h"

@interface OKPay ()

@property (nonatomic, strong) OKPayment *payment;
@property (nonatomic, strong) OKPayDefaultConfigurator *payDefaultConfigurator;

@end

@implementation OKPay

+ (instancetype)sharedPay {
    static dispatch_once_t onceToken;
    static OKPay *instance;
    dispatch_once(&onceToken, ^{
        instance = [[OKPay alloc] init];
    });
    return instance;
}

+ (void)payment:(OKPayment *)payment withOrderInfo:(NSObject *)charge withCompletion:(OKPayppCompletion)completionBlock {
    [self payment:payment withOrderInfo:charge viewController:nil withCompletion:completionBlock];
}

+ (void)payment:(OKPayment *)payment withOrderInfo:(NSObject *)charge viewController:(nullable UIViewController *)viewController withCompletion:(OKPayppCompletion)completionBlock {
    
    OKPay *pay = [OKPay sharedPay];
    
    if (pay.payment) {
        pay.payment = nil;
    }
    pay.payment = payment;
    
    if ([pay.payment respondsToSelector:@selector(prepareWithSettings:)]) {
        [pay.payment prepareWithSettings:pay.payDefaultConfigurator];
    }
    
    pay.payment.payCompletionBlock = completionBlock;
    NSObject *order = [pay.payment generatePayOrder:charge];
    if (order == nil) {
        if (completionBlock) {
            OKPayppError *error = [[OKPayppError alloc] init];
            error.code = OKPayErrInvalidCharge;
            completionBlock(nil, error);
        }
        return;
    }
    
    [pay.payment jumpToPay:order viewController:viewController result:completionBlock];
}

+ (BOOL)handleOpenURL:(NSURL *)URL sourceApplication:(nullable NSString *)application {
    return [[OKPay sharedPay].payment handleOpenURL:URL];
}

+ (void)setPayPayDefaultConfigurator:(OKPayDefaultConfigurator *)payDefaultConfigurator {
    [OKPay sharedPay].payDefaultConfigurator = payDefaultConfigurator;
}

+ (void)setDebugMode:(BOOL)enabled {
    [[OKPay sharedPay].payment setDebugMode:enabled];
}

+ (BOOL)isAppInstalled {
    return [[OKPay sharedPay].payment isAppInstalled];
}

@end

