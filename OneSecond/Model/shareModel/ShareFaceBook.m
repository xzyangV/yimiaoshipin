//
//  ShareFaceBook.m
//  Up
//
//  Created by zhangyx on 14/7/9.
//  Copyright (c) 2014年 amy. All rights reserved.
//

#import "ShareFaceBook.h"
//#import "UserObject.h"

#import "MBProgressHUD+CMBProgressHUD.h"

@interface ShareFaceBook () {
    
}
@property (nonatomic,copy) GetUserInfoEventHandler getUserInfoResult;
@property (nonatomic,copy) PublishContentEventHandler publishContentResult;
@property (nonatomic,copy) AuthLoginEventHandler authLoginResult;
@property (nonatomic,copy) GetFriendList getFriendListResult;

@property (nonatomic,strong) NSDictionary *cacheSnsInfo;

@end

@implementation ShareFaceBook

static ShareFaceBook *shareFBInstace;
+ (ShareFaceBook *)shareToFBInstance
{
    if (shareFBInstace == nil) {
        shareFBInstace = [[ShareFaceBook alloc] init];
    }
    return shareFBInstace;
}


- (ShareUserInfo *)cacheUserInfo
{
    ShareUserInfo *cacheInfo = [[ShareUserInfo alloc] init];
    cacheInfo.type = ShareTypeFaceBook;
    if (self.cacheSnsInfo) {
        cacheInfo.uid = [NSString stringWithFormat:@"%@",[self.cacheSnsInfo objectForKey:@"id"]];
    }
    return cacheInfo;
}

- (BOOL)isAuthLoginResult
{
    if (FBSession.activeSession.state == FBSessionStateOpen) {
        return YES;
    }
    return NO;
}

- (void)logOut
{
    self.authLoginResult = nil;
    self.getUserInfoResult = nil;
    self.publishContentResult = nil;
    self.getFriendListResult = nil;
    
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (void)faceBookAuthLoginWithResult:(AuthLoginEventHandler)result
{
    self.authLoginResult = result;
    
    if (FBSession.activeSession.state == FBSessionStateOpen) {
        if (self.authLoginResult) {
            self.authLoginResult (YES,NO,nil);
        }
        return;
    }
    
    BOOL isallowLoginUI = YES;
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        isallowLoginUI = NO;
    }
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile",@"user_friends",@"publish_actions"]
                                       allowLoginUI:isallowLoginUI
                                  completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         
         if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
             if (self.authLoginResult) {
                 self.authLoginResult (NO,YES,nil);
             }
         }
         else {
             if (state == FBSessionStateOpen) {
                 
                 if (self.authLoginResult) {
                     self.authLoginResult (YES,NO,nil);
                 }

                 [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                     if (!error && [result isKindOfClass:[NSDictionary class]]) {
                         self.cacheSnsInfo = result;
//                         [UserObject loginUserObject].rmd_sns_id = [NSString stringWithFormat:@"%@",[self.cacheSnsInfo objectForKey:@"id"]];
                     }
                 }];
             }
             else {
                 NSLog(@"error = %@",error);
                 if (self.authLoginResult) {
                     self.authLoginResult (NO,NO,UPLocalizedString(@"Login failed", nil));
                 }
             }
         }
     }];
}

// 获取用户信息
- (void)getUserInfoWithResult:(GetUserInfoEventHandler)result
{
    self.getUserInfoResult = result;
    
    if (FBSession.activeSession.state == FBSessionStateOpen) {
        [self makeRequestForUserData];
        return;
    }

    BOOL isallowLoginUI = YES;
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        isallowLoginUI = NO;
    }

    // If the session state is any of the two "open" states when the button is clicked
//    if (FBSession.activeSession.state == FBSessionStateOpen
//        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
    
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
//        [FBSession.activeSession closeAndClearTokenInformation];
        
//        // If the session state is not any of the two "open" states when the button is clicked
//    }
//    else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile",@"user_friends",@"publish_actions"]
                                           allowLoginUI:isallowLoginUI
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             if (!error){
                 if (state == FBSessionStateOpen) {
                     [self makeRequestForUserData];
                 }
                 else {
                     
                     ShareUserInfo *tempInfo = nil;
                     if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                         tempInfo = [[ShareUserInfo alloc] init];
                         tempInfo.type = ShareTypeFaceBook;
                         tempInfo.isSelectedCancelBtn = YES;
                     }
                     if (self.getUserInfoResult) {
                         self.getUserInfoResult (NO,tempInfo);
                     }
                 }
             }
             else {
                 ShareUserInfo *tempInfo = nil;
                 if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                     tempInfo = [[ShareUserInfo alloc] init];
                     tempInfo.isSelectedCancelBtn = YES;
                     tempInfo.type = ShareTypeFaceBook;
                 }

                 if (self.getUserInfoResult) {
                     self.getUserInfoResult (NO,tempInfo);
                 }
                 NSString *errorDes = [self getErrorString:error];
                 NSLog(@"errorDes = %@",errorDes);
                 // Clear this token
             }
         }];
//    }
}

- (void)requestUserInfo
{
    // We will request the user's public picture and the user's birthday
    // These are the permissions we need:
    NSArray *permissionsNeeded = @[@"public_profile",@"user_friends",@"publish_actions"];
    
    // Request the permissions the user currently has
    [FBRequestConnection startWithGraphPath:@"/me/permissions"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error){
                                  // These are the current permissions the user has
                                  NSDictionary *currentPermissions = [(NSArray *)[result data] objectAtIndex:0];
                                  
                                  // We will store here the missing permissions that we will have to request
                                  NSMutableArray *requestPermissions = [[NSMutableArray alloc] initWithArray:@[]];
                                  
                                  // Check if all the permissions we need are present in the user's current permissions
                                  // If they are not present add them to the permissions to be requested
                                  for (NSString *permission in permissionsNeeded) {
                                      if (![currentPermissions objectForKey:permission]) {
                                          [requestPermissions addObject:permission];
                                      }
                                  }
                                  
                                  // If we have permissions to request
                                  if ([requestPermissions count] > 0) {
                                      // Ask for the missing permissions
                                      [FBSession.activeSession
                                       requestNewReadPermissions:requestPermissions
                                       completionHandler:^(FBSession *session, NSError *error) {
                                           if (!error) {
                                               // Permission granted, we can request the user information
                                               [self makeRequestForUserData];
                                           } else {
                                               // An error occurred, we need to handle the error
                                               // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                               NSLog(@"error %@", error.description);
                                           }
                                       }];
                                  } else {
                                      // Permissions are present
                                      // We can request the user information
                                      [self makeRequestForUserData];
                                  }
                                  
                              } else {
                                  // An error occurred, we need to handle the error
                                  // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                  NSLog(@"error %@", error.description);
                              }
                          }];
}

- (void)makeRequestForUserData
{
//    "first_name" = Yuxin;
//    gender = male;
//    id = 288482227997804;
//    "last_name" = Zhang;
//    link = "https://www.facebook.com/app_scoped_user_id/288482227997804/";
//    locale = "zh_CN";
//    name = "Yuxin  Zhang";
//    timezone = 8;
//    "updated_time" = "2013-01-23T05:09:11+0000";
//    verified = 0;
//    用户头像地址 @“http://graph.facebook.com/100000396765290/picture?type=large”

    [FBRequestConnection startWithGraphPath:@"me?fields=is_verified"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              NSLog(@"error = %@",error);
                              NSLog(@"result = %@",result);
                          }];

    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
//            NSLog(@"user info: %@", result);
            
            if (![result isKindOfClass:[NSDictionary class]]) {
                
                if (self.getUserInfoResult) {
                    self.getUserInfoResult (NO,nil);
                }
                return ;
            }
            
            NSDictionary *userInfoDic = (NSDictionary *)result;
            
            ShareUserInfo *snsUserInfo = [[ShareUserInfo alloc] init];
            snsUserInfo.type = ShareTypeFaceBook;
            snsUserInfo.uid = [NSString stringWithFormat:@"%@",[userInfoDic objectForKey:@"id"]];
            if ([[userInfoDic objectForKey:@"gender"] isEqualToString:@"male"]) {
                // nan
                [snsUserInfo setGender:0];
            }
            else if ([[userInfoDic objectForKey:@"gender"] isEqualToString:@"female"]) {
                // nv
                [snsUserInfo setGender:1];
            }
            else {
                [snsUserInfo setGender:2];
            }
            [snsUserInfo setNickname:[userInfoDic objectForKey:@"name"]];
            [snsUserInfo setIcon:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",snsUserInfo.uid]];
            
//            [UserObject loginUserObject].rmd_sns_id = snsUserInfo.uid;

            [FBRequestConnection startWithGraphPath:@"me?fields=is_verified"
                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//                                      NSLog(@"error = %@",error);
//                                      NSLog(@"result = %@",result);
                                      if ([[userInfoDic objectForKey:@"is_verified"] intValue] != 0) {
                                          [snsUserInfo setIsVerified:YES];
                                      }
                                      else {
                                          [snsUserInfo setIsVerified:NO];
                                      }
                                      self.cacheSnsInfo = result;
                                      
                                      if (self.getUserInfoResult) {
                                          self.getUserInfoResult (YES,snsUserInfo);
                                      }
                                  }];
            
        } else {
            // An error occurred, we need to handle the error
            // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
            NSLog(@"error %@", error.description);
            if (self.getUserInfoResult) {
                self.getUserInfoResult (NO,nil);
            }
        }
    }];
}

#pragma mark
#pragma mark get UserFriendList

- (void)getFriendListResult:(GetFriendList)result
{
    self.getFriendListResult = result;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self makeRequestForUserFriendList];
    });

}

- (void)makeRequestForUserFriendList
{
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//        NSLog(@"result = %@",result);
//        NSLog(@"error %@", error.description);
        NSMutableArray *returnArr = [NSMutableArray array];
        FBGraphObject *infoDic = (FBGraphObject *)result;
        NSArray *infoItems = [infoDic objectForKey:@"data"];
        for (NSDictionary *tempInfo in infoItems) {
            ShareUserInfo *snsInfo = [[ShareUserInfo alloc] init];
            snsInfo.uid = [tempInfo objectForKey:@"id"];
            snsInfo.nickname = [tempInfo objectForKey:@"name"];
            [returnArr addObject:snsInfo];
        }
        if (self.getFriendListResult) {
            self.getFriendListResult (returnArr,0,nil,nil);
        }
    }];
    
    /*
    [FBRequestConnection startWithGraphPath:@"/me/taggable_friends"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//                              NSLog(@"result = %@",result);
                              NSLog(@"error %@", error.description);
                              NSMutableArray *returnArr = [NSMutableArray array];
                              FBGraphObject *infoDic = (FBGraphObject *)result;
                              NSArray *infoItems = [infoDic objectForKey:@"data"];
                              for (NSDictionary *tempInfo in infoItems) {
                                  ShareUserInfo *snsInfo = [[ShareUserInfo alloc] init];
                                  snsInfo.uid = [tempInfo objectForKey:@"id"];
                                  snsInfo.nickname = [tempInfo objectForKey:@"name"];
                                  [returnArr addObject:snsInfo];
                                  [snsInfo release];
                              }
                              if (self.getFriendListResult) {
                                  self.getFriendListResult (returnArr,0,nil,nil);
                              }
                          }];
     */
}

#pragma mark 
#pragma mark 分享到facebook

// 分享到facebook
- (void)showShareWithContent:(ShareContent *)content
                      result:(PublishContentEventHandler)result
{
    self.publishContentResult = result;
    if (content.mediaType == PublishContentMediaTypeText) {
        [self makeRequestToUpdateStatus:content];
    }
    else if (content.mediaType == PublishContentMediaTypeImage) {
        [self makeRequestToUpdateImage:content];
    }
    else if (content.mediaType == PublishContentMediaTypeNews) {
        [self makeRequestToShareLink:content];
    }
}

- (void)makeRequestToShareLink:(ShareContent *)shareContent {
    
    // NOTE: pre-filling fields associated with Facebook posts,
    // unless the user manually generated the content earlier in the workflow of your app,
    // can be against the Platform policies: https://developers.facebook.com/policy
    
    // Put together the dialog parameters
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                   @"Sharing Tutorial", @"name",
//                                   @"Build great social apps and get more installs.", @"caption",
//                                   @"Allow your users to share stories on Facebook from your app using the iOS SDK.", @"description",
//                                   @"https://developers.facebook.com/docs/ios/share/", @"link",
//                                   @"http://i.imgur.com/g3Qc1HN.png", @"picture",
//                                   nil];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   shareContent.title, @"name",
                                   @"", @"caption",
                                   shareContent.desc, @"description",
                                   shareContent.url, @"link",
                                   shareContent.imagePath, @"picture",
                                   nil];

    // Make the request
    [FBRequestConnection startWithGraphPath:@"/me/feed"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  // Link posted successfully to Facebook
                                  NSLog(@"result: %@", result);
                                  if (self.publishContentResult) {
                                      self.publishContentResult (ShareTypeFaceBook,YES);
                                  }
                              } else {
                                  // An error occurred, we need to handle the error
                                  // See: https://developers.facebook.com/docs/ios/errors
                                  NSLog(@"%@", error.description);
                                  if (self.publishContentResult) {
                                      self.publishContentResult (ShareTypeFaceBook,NO);
                                  }
                              }
                          }];
}


- (void)makeRequestToUpdateStatus:(ShareContent *)shareContent {
    
    // NOTE: pre-filling fields associated with Facebook posts,
    // unless the user manually generated the content earlier in the workflow of your app,
    // can be against the Platform policies: https://developers.facebook.com/policy
    
    [FBRequestConnection startForPostStatusUpdate:shareContent.content
                                completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                    if (!error) {
                                        // Status update posted successfully to Facebook
                                        NSLog(@"result: %@", result);
                                        if (self.publishContentResult) {
                                            self.publishContentResult (ShareTypeFaceBook,YES);
                                        }
                                    } else {
                                        // An error occurred, we need to handle the error
                                        // See: https://developers.facebook.com/docs/ios/errors
                                        NSLog(@"%@", error.description);
                                        if (self.publishContentResult) {
                                            self.publishContentResult (ShareTypeFaceBook,NO);
                                        }
                                    }
                                }];
}

- (void)makeRequestToUpdateImage:(ShareContent *)shareContent
{
    UIImage *shareImage = shareContent.shareImage;
    if (!shareImage) {
        shareImage = [[UIImage alloc] initWithData:shareContent.shareImageData];
    }
    [FBRequestConnection startForUploadPhoto:shareImage completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            if (self.publishContentResult) {
                self.publishContentResult (ShareTypeFaceBook,YES);
            }
        } else {
            NSLog(@"%@", error.description);
            if (self.publishContentResult) {
                self.publishContentResult (ShareTypeFaceBook,NO);
            }
        }
    }];
}

- (NSString *)getErrorString:(NSError *)error
{
    NSString *errorDes = @"";
    // Handle errors
    if (error) {
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            //            alertTitle = @"Something went wrong";
            errorDes = [FBErrorUtility userMessageForError:error];
            //            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                errorDes = @"User cancelled login";
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                //                alertTitle = @"Session Error";
                errorDes = @"Your current session is no longer valid. Please log in again.";
                //                [self showMessage:alertText withTitle:alertTitle];
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                //                alertTitle = @"Something went wrong";
                errorDes = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                //                [self showMessage:alertText withTitle:alertTitle];
            }
        }
    }
    return errorDes;
}
@end
