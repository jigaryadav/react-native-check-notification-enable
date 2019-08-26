declare module 'react-native-check-notification-enable' {
  export interface NotificationManagerProps {
    areNotificationsEnabled: () => Promise
  }

  export const NotificationManager: {
    areNotificationsEnabled: () => Promise
  }
  export default NotificationManager
}
