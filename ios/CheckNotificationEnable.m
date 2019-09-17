#import "CheckNotificationEnable.h"
#import <UserNotifications/UserNotifications.h>

@implementation NotificationManager

RCT_EXPORT_MODULE()

API_AVAILABLE(ios(10.0))
static bool mapAuthorizationStatus(UNAuthorizationStatus status) {
	switch (status) {
		default:
			// unknown value, map it to false
			return false;
		case UNAuthorizationStatusDenied:
		case UNAuthorizationStatusNotDetermined:
			return false;
		case UNAuthorizationStatusAuthorized:
		case UNAuthorizationStatusProvisional:
			return true;
	}

}

API_AVAILABLE(ios(10.0))
static bool mapNotificationSetting(UNNotificationSetting setting) {
	switch (setting) {
		default:
			// unknown value, map it to false
			return false;
		case UNNotificationSettingNotSupported:
			// if this feature isn't supported, we just set this to false so it disregards this check
			return false;
		case UNNotificationSettingDisabled:
			return false;
		case UNNotificationSettingEnabled:
			return true;
	}
}

RCT_EXPORT_METHOD(areNotificationsEnabled:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
	if (@available(iOS 10.0, *)) {
		[[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
			bool isAuthorized = mapAuthorizationStatus(settings.authorizationStatus);
			bool isShownInNotificationCenter = mapNotificationSetting(settings.notificationCenterSetting);
			bool isShownInLockScreen = mapNotificationSetting(settings.lockScreenSetting);
			bool isShownOnCarPlay = mapNotificationSetting(settings.carPlaySetting);
			bool isShownAsAlert = mapNotificationSetting(settings.alertSetting);
			bool result = isAuthorized && (isShownInNotificationCenter || isShownInLockScreen || isShownOnCarPlay || isShownAsAlert);
			resolve([NSNumber numberWithBool:result]);
		}];
	} else {
		// Fallback for iOS <10
		BOOL remoteNotificationsEnabled = [UIApplication sharedApplication].isRegisteredForRemoteNotifications;
		UIUserNotificationType userNotificationSettingsTypes = ([UIApplication sharedApplication].currentUserNotificationSettings).types;
		bool result = remoteNotificationsEnabled && (userNotificationSettingsTypes & (UIUserNotificationTypeBadge | UIUserNotificationTypeAlert)) != 0;
		resolve([NSNumber numberWithBool:result]);
	}
}

RCT_EXPORT_METHOD(retrieveGlobalNotificationSettings:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
	if (@available(iOS 10.0, *)) {
		[[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
			NSMutableDictionary *notificationSettings = [NSMutableDictionary dictionary];
			[notificationSettings setValue:[NSNumber numberWithBool:mapAuthorizationStatus(settings.authorizationStatus)] forKey:@"isEnabled"];
			[notificationSettings setValue:[NSNumber numberWithBool:mapNotificationSetting(settings.badgeSetting)] forKey:@"isBadgeEnabled"];
			[notificationSettings setValue:[NSNumber numberWithBool:mapNotificationSetting(settings.soundSetting)] forKey:@"isSoundEnabled"];
			[notificationSettings setValue:[NSNumber numberWithBool:mapNotificationSetting(settings.notificationCenterSetting)] forKey:@"shownInNotificationCenter"];
			[notificationSettings setValue:[NSNumber numberWithBool:mapNotificationSetting(settings.lockScreenSetting)] forKey:@"shownInLockScreen"];
			[notificationSettings setValue:[NSNumber numberWithBool:mapNotificationSetting(settings.alertSetting)] forKey:@"shownAsHeadsupDisplay"];
			resolve(notificationSettings);
		}];
	} else {
		// Fallback for iOS <10
		BOOL remoteNotificationsEnabled = [UIApplication sharedApplication].isRegisteredForRemoteNotifications;
		UIUserNotificationType userNotificationSettingsTypes = ([UIApplication sharedApplication].currentUserNotificationSettings).types;
		NSMutableDictionary *notificationSettings = [NSMutableDictionary dictionary];
		[notificationSettings setValue:[NSNumber numberWithBool:remoteNotificationsEnabled] forKey:@"isEnabled"];
		[notificationSettings setValue:[NSNumber numberWithBool:(userNotificationSettingsTypes & UIUserNotificationTypeBadge) != 0] forKey:@"isBadgeEnabled"];
		[notificationSettings setValue:[NSNumber numberWithBool:(userNotificationSettingsTypes & UIUserNotificationTypeSound) != 0] forKey:@"isSoundEnabled"];
		[notificationSettings setValue:[NSNumber numberWithBool:TRUE] forKey:@"shownInNotificationCenter"];
		[notificationSettings setValue:[NSNumber numberWithBool:TRUE] forKey:@"shownInLockScreen"];
		[notificationSettings setValue:[NSNumber numberWithBool:(userNotificationSettingsTypes & UIUserNotificationTypeAlert) != 0] forKey:@"shownAsHeadsupDisplay"];
		resolve(notificationSettings);
	}

}

RCT_EXPORT_METHOD(retrieveNotificationChannels:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
	// iOS does not support notification channels
	resolve([NSArray array]);
}

@end
