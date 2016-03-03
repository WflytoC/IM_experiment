//
//  TTDetailCell.h
//  UNeed
//
//  Created by wcshinestar on 12/31/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTDetail;
@class TTDetailCell;

@protocol DetailCellDelegate <NSObject>

- (void)DetailBtnClick:(TTDetailCell *)detailCell;

@end

@interface TTDetailCell : UITableViewCell

@property(nonatomic,strong)TTDetail* detail;
@property(nonatomic,weak)id<DetailCellDelegate> clickDelegate;

@end
