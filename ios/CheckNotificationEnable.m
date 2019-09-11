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

@end
