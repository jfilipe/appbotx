//
//  ABXVersionNotificationView.m
//  Sample Project
//
//  Created by Stuart Hall on 18/06/2014.
//  Copyright (c) 2014 Appbot. All rights reserved.
//

#import "ABXVersionNotificationView.h"

#import "ABXAppStore.h"

@implementation ABXVersionNotificationView

+ (void)fetchAndShowInController:(UIViewController*)controller
                     foriTunesID:(NSString*)itunesId
                 backgroundColor:(UIColor*)backgroundColor
                       textColor:(UIColor*)textColor
                     buttonColor:(UIColor*)buttonColor

{
    [ABXVersion fetchCurrentVersion:^(ABXVersion *version, ABXVersion *currentVersion, ABXResponseCode responseCode, NSInteger httpCode, NSError *error) {
        if (responseCode == ABXResponseCodeSuccess) {
            if (currentVersion && [currentVersion isNewerThanCurrent]) {
                // Check if it is live on the store
                [currentVersion isLiveVersion:itunesId country:@"us" complete:^(BOOL matches) {
                    if (matches) {
                        // Show the view
                        [ABXNotificationView show:[NSString stringWithFormat:@"An update to version %@ is available", currentVersion.version]
                                       actionText:NSLocalizedString(@"Update", nil)
                                  backgroundColor:backgroundColor
                                        textColor:textColor
                                      buttonColor:buttonColor
                                     inController:controller
                                      actionBlock:^(ABXNotificationView *view) {
                                          // Throw them to the App Store
                                          [view dismiss];
                                          [ABXAppStore openAppStoreForApp:itunesId];
                                      }
                                     dismissBlock:^(ABXNotificationView *view) {
                                         // Any action you want
                                     }];
                    }
                }];
            }
            else if (version) {
                // We got a match!
                if (![version hasSeen]) {
                    // Show the view
                    [ABXNotificationView show:[NSString stringWithFormat:@"You've just updated to v%@", version.version]
                                   actionText:NSLocalizedString(@"Learn More", nil)
                              backgroundColor:backgroundColor
                                    textColor:textColor
                                  buttonColor:buttonColor
                                 inController:controller
                                  actionBlock:^(ABXNotificationView *view) {
                                      // Take them to all the versions, or you could choose
                                      // to just show the one version
                                      [version markAsSeen];
                                      [view dismiss];
                                      [ABXVersionsViewController showFromController:controller];
                                  }
                                 dismissBlock:^(ABXNotificationView *view) {
                                     // Here you can mark it as seen if you
                                     // don't want it to appear again
                                     [version markAsSeen];
                                 }];
                }
            }
        }
    }];
}

@end