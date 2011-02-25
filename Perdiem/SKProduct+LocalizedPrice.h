//
//  SKProduct+LocalizedPrice.h
//  Perdiem
//
//  Created by Jarod Luebbert on 2/24/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface SKProduct (LocalizedPrice)

@property (nonatomic, readonly) NSString *localizedPrice;

@end
