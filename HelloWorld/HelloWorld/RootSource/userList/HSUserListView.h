//
//  HSUserListView.h
//  HSRoomUI
//
//  Created by Chenfy on 2022/4/1.
//  Copyright © 2022 刘强强. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,HSListChooseType) {
    HSListChooseType_None,  //未选择
    HSListChooseType_All,   //所有人
    HSListChooseType_User,  //某个人
};

@protocol HSUserListViewDelegate <NSObject>

- (void)listCallBack:(HSListChooseType)type index:(NSInteger)index list:(NSArray *)list;

@end

@interface HSUserListView : UIView

@property(nonatomic,weak)id <HSUserListViewDelegate>delegate;

- (void)showListView:(NSArray *)users;

@end

NS_ASSUME_NONNULL_END
