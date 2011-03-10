//
//  InAppPurchaseManager.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/24/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
//

#import "InAppPurchaseManager.h"
#import "PerdiemAppDelegate.h"
#import "MBProgressHUD+RFhelpers.h"
#import "Globals.h"

@implementation InAppPurchaseManager

- (void)requestProUpgradeProductData
{
  NSSet *productIdentifiers = [NSSet setWithObjects:kInAppPurchaseProUpgradeProductId,
                               kInAppPurchaseDiscountProUpgradeProductId,
                               nil ];
  productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
  productsRequest.delegate = self;
  [productsRequest start];
  
  // we will release the request object in the delegate callback
}

- (void)purchaseProUpgrade
{
  SKPayment *payment = [SKPayment paymentWithProductIdentifier:kInAppPurchaseProUpgradeProductId];
  [[SKPaymentQueue defaultQueue] addPayment:payment];
  [self startStatusIndicators];
}

- (void)purchaseDiscountProUpgrade
{
  SKPayment *payment = [SKPayment paymentWithProductIdentifier:kInAppPurchaseDiscountProUpgradeProductId];
  [[SKPaymentQueue defaultQueue] addPayment:payment];
  [self startStatusIndicators];
}

- (void)loadStore
{
  // restarts any purchases if they were interrupted last time the app was open
  [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
  
  // get the product description (defined in early sections)
  [self requestProUpgradeProductData];
}

- (BOOL)canMakePurchases
{
  return [SKPaymentQueue canMakePayments];
}

#pragma -
#pragma Purchase helpers

//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
  if ([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseProUpgradeProductId])
  {
    // save the transaction receipt to disk
    [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"proUpgradeTransactionReceipt" ];
    [[NSUserDefaults standardUserDefaults] synchronize];
  }
  else if ([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseDiscountProUpgradeProductId])
  {
    [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"proUpgradeDiscountTransactionReceipt" ];
    [[NSUserDefaults standardUserDefaults] synchronize];
  }
}

//
// enable pro features
//
- (void)provideContent:(NSString *)productId
{
  if ([productId isEqualToString:kInAppPurchaseProUpgradeProductId] ||
      [productId isEqualToString:kInAppPurchaseDiscountProUpgradeProductId])
  {
    // enable the pro features
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isProUpgradePurchased];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [(PerdiemAppDelegate*)[UIApplication sharedApplication].delegate removeBanner];
  }
}

//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
  // remove the transaction from the payment queue.
  [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
  
  NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
  if (wasSuccessful)
  {
    // send out a notification that we’ve finished the transaction
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
  }
  else
  {
    // send out a notification for the failed transaction
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
  }
}

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
  [self recordTransaction:transaction];
  [self provideContent:transaction.payment.productIdentifier];
  [self finishTransaction:transaction wasSuccessful:YES];
  [self stopStatusIndicators];
}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
  [self recordTransaction:transaction.originalTransaction];
  [self provideContent:transaction.originalTransaction.payment.productIdentifier];
  [self finishTransaction:transaction wasSuccessful:YES];
  [self stopStatusIndicators];
}

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
  if (transaction.error.code != SKErrorPaymentCancelled)
  {
    // error!
    [self finishTransaction:transaction wasSuccessful:NO];
  }
  else
  {
    // this is fine, the user just cancelled, so don’t notify
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
  }
  [self stopStatusIndicators];
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
  for (SKPaymentTransaction *transaction in transactions)
  {
    switch (transaction.transactionState)
    {
      case SKPaymentTransactionStatePurchased:
        [self completeTransaction:transaction];
        break;
      case SKPaymentTransactionStateFailed:
        [self failedTransaction:transaction];
        break;
      case SKPaymentTransactionStateRestored:
        [self restoreTransaction:transaction];
        break;
      default:
        break;
    }
  }
}

- (void)stopStatusIndicators
{
  [[MBProgressHUD sharedProgressHUD] hideAnimated:YES];
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)startStatusIndicators
{
  [[MBProgressHUD sharedProgressHUD] showAnimated:YES];
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
  NSArray *products = response.products;
  proUpgradeProduct = [products count] >= 1 ? [[products objectAtIndex:0] retain] : nil;
  discountProUpgradeProduct = [products count] >= 2 ? [[products objectAtIndex:1] retain] : nil;
  if (proUpgradeProduct && discountProUpgradeProduct)
  {
    NSLog(@"Product title: %@" , proUpgradeProduct.localizedTitle);
    NSLog(@"Product description: %@" , proUpgradeProduct.localizedDescription);
    NSLog(@"Product price: %@" , proUpgradeProduct.price);
    NSLog(@"Product id: %@" , proUpgradeProduct.productIdentifier);
    
    NSLog(@"Product title: %@" , discountProUpgradeProduct.localizedTitle);
    NSLog(@"Product description: %@" , discountProUpgradeProduct.localizedDescription);
    NSLog(@"Product price: %@" , discountProUpgradeProduct.price);
    NSLog(@"Product id: %@" , discountProUpgradeProduct.productIdentifier);
  }
  
  for (NSString *invalidProductId in response.invalidProductIdentifiers)
  {
    NSLog(@"Invalid product id: %@" , invalidProductId);
  }
  
  // finally release the reqest we alloc/init’ed in requestProUpgradeProductData
  [productsRequest release];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}

@end
