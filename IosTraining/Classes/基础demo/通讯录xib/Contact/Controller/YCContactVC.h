//
//  YCContactVC.h
//  UI
//
//  Created by release on 2020/8/16.
//  Copyright © 2020 Mr. release. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YCContactItem;
@interface YCContactVC : UITableViewController

@property(nonatomic,strong)NSString *account;

@property(nonatomic,strong)YCContactItem *contactItem; 

@end

NS_ASSUME_NONNULL_END
