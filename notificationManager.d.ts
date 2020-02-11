declare module 'react-native-check-notification-enable' {
  interface NotificationSettings {
    isEnabled: boolean;
    isBadgeEnabled: boolean;
    isSoundEnabled: boolean;
    shownInNotificationCenter: boolean;
    shownInLockScreen: boolean;
    shownAsHeadsupDisplay: boolean;
  }

  interface NotificationChannel extends NotificationSettings {
    id: string;
  }

  export const NotificationManager: {
    areNotificationsEnabled: () => Promise<boolean>,
    retrieveGlobalNotificationSettings: () => Promise<NotificationSettings>,
    retrieveNotificationChannels: () => Promise<NotificationChannel[]>,
  }
  export default NotificationManager
}
