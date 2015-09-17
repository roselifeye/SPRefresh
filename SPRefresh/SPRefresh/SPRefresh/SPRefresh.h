//
//  SPRefresh.h
//  SPRefresh
//
//  Created by sy2036 on 2015-09-17.
//  Copyright (c) 2015 Roselifeye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SPBlockTypeDef.h"

@interface SPRefresh : NSObject

@property (nonatomic, strong) UIScrollView *refreshScrollView;

/**
 *  This method will called during the refresh.
 *  User can add their functions in the block, like request network service.
 */
@property (nonatomic, copy) SPBlock refreshBlockEnd;

/**
 *  Refresh View Image Name.
 *  Default is @"down", arrow image.
 */
@property (nonatomic, assign) NSString *refreshImageName;

/**
 *  Default Refresh Text.
 *  Default is @"Pull to Refresh".
 */
@property (nonatomic, assign) NSString *defaultText;

/**
 *  The displaying text when user already pull up or down the refresh view.
 *  Default is @"Release to Refresh".
 */
@property (nonatomic, assign) NSString *beginText;

/**
 *  The displaying text during refreshing.
 *  Default is @"Loading...".
 */
@property (nonatomic, assign) NSString *refreshingText;

/**
 *  Init Refresh Header
 *
 *  @param refreshScrollView The target view which is added the Refresh Header.
 *
 *  @param header If the refresh view is added to the header, set YES, otherwise, set NO.
 *
 *  @return Refresh Header self.
 */
- (id)initWithScrollView:(UIScrollView *)refreshScrollView withHeader:(BOOL)header;

/**
 *  This function will be called when user is refresh their controller.
 *  User still can forced call it whenever they want.
 */
- (void)beginRefresh;

/**
 *  End the refresh function.
 *  Please add it after the ScrollView refresh, like [tableView reloadData];
 */
- (void)endRefresh;


@end
