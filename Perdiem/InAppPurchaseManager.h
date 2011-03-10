//
//  InAppPurchaseManager.h
//  Perdiem
//
//  Created by Jarod Luebbert on 2/24/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
//

#import <StoreKit/StoreKit.h>

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"

@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
  SKProduct *proUpgradeProduct;
  SKProduct *discountProUpgradeProduct;
  SKProductsRequest *productsRequest;
}

- (void)loadStore;
- (BOOL)canMakePurchases;
- (void)purchaseProUpgrade;
- (void)purchaseDiscountProUpgrade;
- (void)requestProUpgradeProductData;
- (void)startStatusIndicators;
- (void)stopStatusIndicators;

@end
