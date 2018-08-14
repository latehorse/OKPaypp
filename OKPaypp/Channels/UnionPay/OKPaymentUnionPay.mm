//
//  OKPaymentUnionPay.m
//  OKPaypp
//
//  Created by yuhanle on 2018/8/14.
//

#import "OKPaymentUnionPay.h"
#import "UPPaymentControl.h"

@implementation OKPaymentUnionPay

- (nonnull NSObject *)generatePayOrder:(nonnull NSObject *)charge {
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

- (void)jumpToPay:(nonnull NSObject *)order result:(nonnull OKPayppCompletion)completionBlock {
    [self jumpToPay:order viewController:nil result:completionBlock];
}

- (void)jumpToPay:(nonnull NSObject *)order viewController:(nullable UIViewController *)viewController result:(nonnull OKPayppCompletion)completionBlock {
    if ([[UPPaymentControl defaultControl] isPaymentAppInstalled]) {
        OKPayppLog(@"Unionpay is not installed");
    }
    
    if (!viewController) {
        OKPayppLog(@"Unionpay start error: viewController is not be nil.");
        OKPayppError *error = [[OKPayppError alloc] init];
        error.code = OKPayErrViewControllerIsNil;
        
        if (completionBlock) {
            completionBlock(nil, error);
        }
        return;
    }
    
    self.payCompletionBlock = completionBlock;
    [[UPPaymentControl defaultControl] startPay:(NSString *)order fromScheme:self.appScheme mode:self.tnmode viewController:viewController];
}

- (void)prepareWithSettings:(nonnull OKPayDefaultConfigurator *)payDefaultConfigurator {
    self.appScheme = payDefaultConfigurator.appScheme;
    self.tnmode = payDefaultConfigurator.tnmode;
}

#pragma mark - Public Method
- (BOOL)isAppInstalled {
    return [[UPPaymentControl defaultControl] isPaymentAppInstalled];
}

- (BOOL)handleOpenURL:(NSURL *)url withCompletion:(OKPayppCompletion)completion {
    __block BOOL success = NO;
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        if ([code isEqualToString:@"success"]) {
            success = YES;
            if (self.payCompletionBlock) {
                self.payCompletionBlock(@"", nil);
            }
            if (completion) {
                completion(@"", nil);
            }
        }
        else if ([code isEqualToString:@"fail"]) {
            OKPayppLog(@"Unionpay start error: fail.");
            OKPayppError *error = [[OKPayppError alloc] init];
            error.code = OKPayErrUnknownError;
            
            if (self.payCompletionBlock) {
                self.payCompletionBlock(nil, error);
            }
            if (completion) {
                completion(nil, error);
            }
        }
        else if ([code isEqualToString:@"cancel"]) {
            OKPayppLog(@"Unionpay start error: cancel.");
            OKPayppError *error = [[OKPayppError alloc] init];
            error.code = OKPayErrCancelled;
            
            if (self.payCompletionBlock) {
                self.payCompletionBlock(nil, error);
            }
            if (completion) {
                completion(nil, error);
            }
        }
    }];
    
    return success;
}

@end
