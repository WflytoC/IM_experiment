//
//  TTChatController.m
//  UNeed
//
//  Created by wcshinestar on 1/2/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

#import "TTChatController.h"
#import "TTTools.h"

@interface TTChatController ()

@end

@implementation TTChatController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_CHATROOM),@(ConversationType_GROUP),@(ConversationType_APPSERVICE),@(ConversationType_SYSTEM)]];
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),@(ConversationType_GROUP)]];
}


- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath{
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    NSString *title = model.targetId;
    NSString *own = [TTTools obtainInfo:@"user_email"];
    NSString *realTitle = [own isEqualToString:title] ? @"自己" : title;
    conversationVC.title = realTitle;
    [self.navigationController pushViewController:conversationVC animated:YES];
}





@end
