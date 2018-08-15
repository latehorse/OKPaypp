//
//  OKPaymentWx.m
//  OKPaypp
//
//  Created by yuhanle on 2018/8/14.
//

#import "OKPaymentWx.h"
#import "WXApi.h"

@interface OKPaymentWx () <WXApiDelegate>

//处理支付结果回调
@property (nonatomic, copy) OKPayppCompletion handleCompletionBlock;

@end

@implementation OKPaymentWx 

#pragma mark - WXApiDelegate
- (void)onReq:(BaseReq *)req {
    OKPayppLog(@"Wxpay req: %@ %@", @(req.type), req.openID);
}

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        OKPayppError *error = nil;
        if (resp.errCode == 0) {
            // 成功
            OKPayppLog(@"Wxpay result success");
        }else {
            error = [[OKPayppError alloc] init];
            if (resp.errCode == -1) {
                OKPayppLog(@"Wxpay result error: %@ %@", @(resp.errCode), resp.errStr);
                error.code = OKPayErrInvalidCharge;
            }else if (resp.errCode == -2) {
                OKPayppLog(@"Wxpay result error: %@ %@", @(resp.errCode), resp.errStr);
                error.code = OKPayErrCancelled;
            }else if (resp.errCode == -3) {
                OKPayppLog(@"Wxpay result error: %@ %@", @(resp.errCode), resp.errStr);
                error.code = OKPayErrInvalidCredential;
            }else if (resp.errCode == -4) {
                OKPayppLog(@"Wxpay result error: %@ %@", @(resp.errCode), resp.errStr);
                error.code = OKPayErrConnectionError;
            }else if (resp.errCode == -5) {
                OKPayppLog(@"Wxpay result error: %@ %@", @(resp.errCode), resp.errStr);
                error.code = OKPayErrWxAppNotSupported;
            }else {
                OKPayppLog(@"Wxpay result error: %@ %@", @(resp.errCode), resp.errStr);
                error.code = OKPayErrUnknownError;
            }
        }
        
        if (_payCompletionBlock) {
            _payCompletionBlock(resp.errStr, error);
        }
        
        if (_handleCompletionBlock) {
            _handleCompletionBlock(resp.errStr, error);
        }
    }
}

#pragma mark - OKPayment
- (void)prepareWithSettings:(OKPayDefaultConfigurator *)payDefaultConfigurator {
    self.appScheme = payDefaultConfigurator.appScheme;
    [WXApi registerApp:payDefaultConfigurator.wxPayAppId];
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
    if ([WXApi isWXAppInstalled]) {
        OKPayppLog(@"wx is not installed");
        OKPayppError *error = [[OKPayppError alloc] init];
        error.code = OKPayErrWxNotInstalled;
        
        if (completionBlock) {
            completionBlock(nil, error);
        }
        return;
    }
    
    if ([WXApi isWXAppSupportApi]) {
        OKPayppLog(@"wxapi is not support");
        OKPayppError *error = [[OKPayppError alloc] init];
        error.code = OKPayErrWxAppNotSupported;
        
        if (completionBlock) {
            completionBlock(nil, error);
        }
        return;
    }
    
    self.payCompletionBlock = completionBlock;
    
    NSDictionary *response = (NSDictionary *)order;
    PayReq *req = [[PayReq alloc] init];
    req.partnerId = [response objectForKey:@"partnerid"];
    req.prepayId = [response objectForKey:@"prepayid"];
    req.package = [response objectForKey:@"package"];
    req.nonceStr = [response objectForKey:@"noncestr"];
    req.timeStamp = [[response objectForKey:@"timestamp"]intValue];
    req.sign = [response objectForKey:@"sign"];
    
    [WXApi sendReq:req];
}

#pragma mark - Public Method
- (BOOL)isAppInstalled {
    return [WXApi isWXAppInstalled];
}

- (BOOL)handleOpenURL:(NSURL *)url withCompletion:(OKPayppCompletion)completion {
    self.handleCompletionBlock = completion;
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)registerApp:(NSString *)appid {
    return [WXApi registerApp:appid];
}

- (void)setDebugMode:(BOOL)enabled {
    if (enabled) {
        [WXApi startLogByLevel:WXLogLevelDetail logBlock:^(NSString *log) {
            OKPayppLog(@"%@", log);
        }];
    }else {
        [WXApi stopLog];
    }
}

@end
