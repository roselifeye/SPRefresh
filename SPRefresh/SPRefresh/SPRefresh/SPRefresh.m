//
//  SPRefresh.m
//  SPRefresh
//
//  Created by sy2036 on 2015-09-17.
//  Copyright (c) 2015 Roselifeye. All rights reserved.
//

#import "SPRefresh.h"

#define AutomaticallyAdjustsScrollViewInsets 64

@interface SPRefresh () {
    UILabel *refreshLabel;
    UIView *refrehView;
    UIImageView *refreshImageView;
    UIActivityIndicatorView *refreshActivityView;
    
    BOOL isRefresh;
    BOOL isHeader;
    
    float refreshViewWidth;
    float refreshViewHeight;
    
    float labelWidth;
    float imageWith;
    
    float contentViewHeight;
    float lastPostion;
}

@end

@implementation SPRefresh

- (id)initWithScrollView:(UIScrollView *)refreshScrollView withHeader:(BOOL)header {
    self = [super init];
    if (self) {
        _refreshScrollView = refreshScrollView;
        isHeader = header;
        [self initRefreshView];
    }
    return self;
}

- (void)beginRefresh {
    if (!isRefresh) {
        isRefresh = YES;
        [refreshLabel setText:_refreshingText];
        [refreshImageView setHidden:YES];
        [refreshActivityView setHidden:NO];
        [refreshActivityView startAnimating];
        
        //  Set the position of refreshScrollView
        [UIView animateWithDuration:0.3f animations:^{
            if (isHeader) {
                int currentPosition = _refreshScrollView.contentOffset.y;
                if (currentPosition > -refreshViewHeight*1.5) {
                    _refreshScrollView.contentOffset = CGPointMake(0, currentPosition - refreshViewHeight*1.5);
                }
                [_refreshScrollView setContentInset:UIEdgeInsetsMake(AutomaticallyAdjustsScrollViewInsets+refreshViewHeight*1.5, 0, 0, 0)];
            } else {
                [_refreshScrollView setContentInset:UIEdgeInsetsMake(0, 0, refreshViewHeight, 0)];
            }
        }];
        _refreshBlockEnd();
    }
}

- (void)endRefresh {
    isRefresh = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3f animations:^{
            if (isHeader) {
                int currentPosition = _refreshScrollView.contentOffset.y;
                if (currentPosition != 0) {
                    _refreshScrollView.contentOffset = CGPointMake(0, currentPosition + refreshViewHeight*1.5);
                }
            }
            [_refreshScrollView setContentInset:UIEdgeInsetsMake(AutomaticallyAdjustsScrollViewInsets, 0, 0, 0)];
            [self setRefreshText:_defaultText andImageTransform:M_PI*2];
            [refreshImageView setHidden:NO];
            [refreshActivityView stopAnimating];
            [refreshActivityView setHidden:YES];
        }];
    });
}

- (void)initRefreshView {
    [self initDefaultValue];
    
    refrehView = [[UIView alloc] initWithFrame:CGRectMake(0, -refreshViewHeight, refreshViewWidth, refreshViewHeight)];
    [_refreshScrollView addSubview:refrehView];
    
    [self initRefreshLabel];
    [self initRefreshImage];
    [self initRefreshActivity];
    
    /**
     *  Setting KVO Observer for RefreshScrollView.
     *  keyPath is contentOffset
     */
    [_refreshScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

//  Set Default Value.
- (void)initDefaultValue {
    isRefresh = NO;
    refreshViewWidth = _refreshScrollView.frame.size.width;
    refreshViewHeight = 35;
    labelWidth = 130;
    imageWith = 13;
    
    lastPostion = 0;
    
    _refreshImageName = @"down";
    _defaultText = @"Pull to Refresh";
    _beginText = @"Release to Refresh";
    _refreshingText = @"Loading...";
}

- (void)initRefreshLabel {
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake((refreshViewWidth-labelWidth)/2, 0, labelWidth, refreshViewHeight)];
    [refreshLabel setTextAlignment:NSTextAlignmentCenter];
    [refreshLabel setFont:[UIFont systemFontOfSize:14.f]];
    [refreshLabel setText:_defaultText];
    [refrehView addSubview:refreshLabel];
}

- (void)initRefreshImage {
    refreshImageView = [[UIImageView alloc] initWithFrame:CGRectMake((refreshViewWidth-labelWidth)/2 - imageWith, 0, imageWith, refreshViewHeight)];
    [refreshImageView setImage:[UIImage imageNamed:_refreshImageName]];
    [refrehView addSubview:refreshImageView];
    
    [refreshImageView setHidden:NO];
}

- (void)initRefreshActivity {
    refreshActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [refreshActivityView setFrame:CGRectMake((refreshViewWidth-labelWidth)/2 - imageWith, 0, imageWith, refreshViewHeight)];
    [refrehView addSubview:refreshActivityView];
    
    [refreshActivityView setHidden:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (![@"contentOffset" isEqualToString:keyPath]) return;
    
    //  Get the Height of refreshScrollView.
    contentViewHeight = _refreshScrollView.contentSize.height;
    int currentPosition = _refreshScrollView.contentOffset.y;
    
    if (!isHeader) {
        CGRect frame = CGRectMake(0, contentViewHeight, refreshViewWidth, refreshViewHeight);
        if (contentViewHeight < _refreshScrollView.frame.size.height) {
            frame.origin.y = _refreshScrollView.frame.size.height - refreshViewHeight;
        }
        [refrehView setFrame:frame];
    }
    
    if (_refreshScrollView.dragging) {
        if (!isRefresh) {
            [UIView animateWithDuration:0.3 animations:^{
                //  When currentPosition is smaller than the value we want, the status will change
                if (isHeader) {
                    if (currentPosition < -refreshViewHeight*1.5) {
                        [self setRefreshText:_beginText andImageTransform:M_PI];
                    } else {
                        [self refreshViewUpdateWithImageTransform:M_PI*2];
                    }
                } else {
                    int currentBottomPosition = currentPosition - (contentViewHeight - _refreshScrollView.frame.size.height);
                    if ((currentBottomPosition > 0)) {
                        if (currentBottomPosition > refreshViewHeight*1.5) {
                            [self setRefreshText:_beginText andImageTransform:M_PI*2];
                        } else {
                            [self refreshViewUpdateWithImageTransform:M_PI];
                        }
                    }
                }
            }];
        }
    } else {
        if ([refreshLabel.text isEqualToString:_beginText]) {
            [self beginRefresh];
        }
    }
}

- (void)refreshViewUpdateWithImageTransform:(CGFloat)angle {
    int currentPosition = _refreshScrollView.contentOffset.y;
    if (currentPosition - lastPostion > 5) {
        lastPostion = currentPosition;
        [self setRefreshText:_defaultText andImageTransform:angle];
    } else if (lastPostion - currentPosition > 5) {
        lastPostion = currentPosition;
    }
}

- (void)setRefreshText:(NSString *)text andImageTransform:(CGFloat)angle {
    [refreshLabel setText:text];
    [refreshImageView setTransform:CGAffineTransformMakeRotation(angle)];
}

- (void)dealloc {
    [_refreshScrollView removeObserver:self forKeyPath:@"contentOffset"];
}

@end
