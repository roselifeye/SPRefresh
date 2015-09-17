//
//  SPBlockTypeDef.h
//  
//
//  Created by sy2036 on 2015-09-17.
//
//

#ifndef _SPBlockTypeDef_h
#define _SPBlockTypeDef_h

typedef void(^SPBlock)(void);
typedef void(^SPBOOLBlock)(BOOL resSPt);
typedef void(^SPBlockBlock)(SPBlock block);
typedef void(^SPObjectBlock)(id obj);
typedef void(^SPArrayBlock)(NSArray *array);
typedef void(^SPMutableArrayBlock)(NSMutableArray *array);
typedef void(^SPDictionaryBlock)(NSDictionary *dic);
typedef void(^SPErrorBlock)(NSError *error);
typedef void(^SPIndexBlock)(NSInteger index);
typedef void(^SPFloatBlock)(CGFloat afloat);
typedef void(^SPStringBlock)(NSString *str);

typedef void(^SPBlockRequestEnd)(BOOL resSPt, NSString *resSPtMessage, id object);

typedef void(^SPCancelBlock)(id viewController);
typedef void(^SPFinishedBlock)(id viewController, id object);

typedef void(^SPSendRequestAndResendRequestBlock)(id sendBlock, id resendBlock);

#endif
