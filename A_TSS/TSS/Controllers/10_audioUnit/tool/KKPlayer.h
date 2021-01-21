//
//  KKPlayer.h
//  TSS
//
//  Created by Chenfy on 2021/1/12.
//  Copyright © 2021 Chenfy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class KKPlayer;


@protocol KKPlayerDelegate <NSObject>

- (void)onPlayToEnd:(KKPlayer *)player;

@end

@interface KKPlayer : NSObject

@property (nonatomic, weak) id<KKPlayerDelegate> delegate;

- (void)play:(NSString *)address;



@end

NS_ASSUME_NONNULL_END
