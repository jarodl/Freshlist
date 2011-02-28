//
//  InAppPurchaseManager.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/24/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
//

#import "InAppPurchaseManager.h"

@implementation InAppPurchaseManager

- (void)requestProUpgradeProductData
{
  NSSet *productIdentifiers = [NSSet setWithObject:@"com.freshlistapp.freshlist.freshlistpro" ];
  productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
  productsRequest.delegate = self;
  [productsRequest start];
  
  // we will release the request object in the delegate callback
}

#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
  NSArray *products = response.products;
  proUpgradeProduct = [products count] == 1 ? [[products objectAtIndex:0] retain] : nil;
  if (proUpgradeProduct)
  {
    NSLog(@"Product title: %@" , proUpgradeProduct.localizedTitle);
    NSLog(@"Product description: %@" , proUpgradeProduct.localizedDescription);
    NSLog(@"Product price: %@" , proUpgradeProduct.price);
    NSLog(@"Product id: %@" , proUpgradeProduct.productIdentifier);
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
