package com.skyward.NotificationManager;

import android.annotation.TargetApi;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.os.Build;

import com.facebook.react.bridge.*;
import com.facebook.react.bridge.Promise;
import androidx.core.app.NotificationManagerCompat;


public class NotificationManagerModule extends ReactContextBaseJavaModule {
  public NotificationManagerModule(ReactApplicationContext reactContext) {
    super(reactContext);
  }

  @Override
  public String getName() {
    return "NotificationManager";
  }

  @ReactMethod
  public void areNotificationsEnabled(final Promise promise) {
    try {
      Boolean areEnabled = NotificationManagerCompat.from(getReactApplicationContext()).areNotificationsEnabled();
      promise.resolve(areEnabled);
    } catch (Exception e) {
      promise.reject(e);
    }
  }

  @TargetApi(Build.VERSION_CODES.O)
  private void retrieveNotificationChannelsOnAndroidOreo(Promise promise) {
    NotificationManager notificationManager = getReactApplicationContext().getSystemService(NotificationManager.class);
    if (notificationManager == null) {
      promise.reject("no_notification_manager_service", "Could not retrieve Android NotificationManager service");
      return;
    }

    try {
      WritableArray notificationsChannels = Arguments.createArray();
      for (NotificationChannel notificationChannel : notificationManager.getNotificationChannels()) {
        WritableMap channel = Arguments.createMap();
        channel.putString("id", notificationChannel.getId());
        channel.putBoolean("isEnabled", notificationChannel.getImportance() != NotificationManager.IMPORTANCE_NONE);
        channel.putBoolean("isBadgeEnabled", notificationChannel.canShowBadge());
        channel.putBoolean("isSoundEnabled", notificationChannel.getSound() != null);
        channel.putBoolean("shownInNotificationCenter", false);
        channel.putBoolean("shownInLockScreen", notificationChannel.getLockscreenVisibility() > 0);
        channel.putBoolean("shownAsHeadsupDisplay", notificationChannel.getImportance() >= NotificationManager.IMPORTANCE_HIGH);
        notificationsChannels.pushMap(channel);
      }
      promise.resolve(notificationsChannels);
    } catch (Exception e) {
      promise.reject(e);
    }
  }

  @ReactMethod
  public void retrieveNotificationChannels(Promise promise) {
    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
      WritableArray notificationsChannels = Arguments.createArray();
      promise.resolve(notificationsChannels);
      return;
    }

    retrieveNotificationChannelsOnAndroidOreo(promise);
  }

  @ReactMethod
  public void retrieveGlobalNotificationSettings(Promise promise) {
    int importance;
    try {
      importance = NotificationManagerCompat.from(getReactApplicationContext()).getImportance();
    } catch (Exception e) {
      promise.reject(e);
      return;
    }

    WritableMap settings = Arguments.createMap();
    switch (importance) {
      default:
        promise.reject(new RuntimeException("unknown importance value: " + importance));
        return;
      case NotificationManagerCompat.IMPORTANCE_NONE:
        settings.putBoolean("isEnabled", false);
        settings.putBoolean("isBadgeEnabled", false);
        settings.putBoolean("isSoundEnabled", false);
        settings.putBoolean("shownInNotificationCenter", false);
        settings.putBoolean("shownInLockScreen", false);
        settings.putBoolean("shownAsHeadsupDisplay", false);
        break;
      case NotificationManagerCompat.IMPORTANCE_MIN:
      case NotificationManagerCompat.IMPORTANCE_LOW:
        settings.putBoolean("isEnabled", true);
        settings.putBoolean("isBadgeEnabled", true);
        settings.putBoolean("isSoundEnabled", false);
        settings.putBoolean("shownInNotificationCenter", true);
        settings.putBoolean("shownInLockScreen", true);
        settings.putBoolean("shownAsHeadsupDisplay", false);
        break;
      case NotificationManagerCompat.IMPORTANCE_DEFAULT:
      case NotificationManagerCompat.IMPORTANCE_UNSPECIFIED:
        settings.putBoolean("isEnabled", true);
        settings.putBoolean("isBadgeEnabled", true);
        settings.putBoolean("isSoundEnabled", true);
        settings.putBoolean("shownInNotificationCenter", true);
        settings.putBoolean("shownInLockScreen", true);
        settings.putBoolean("shownAsHeadsupDisplay", false);
        break;
      case NotificationManagerCompat.IMPORTANCE_HIGH:
      case NotificationManagerCompat.IMPORTANCE_MAX:
        settings.putBoolean("isEnabled", true);
        settings.putBoolean("isBadgeEnabled", true);
        settings.putBoolean("isSoundEnabled", true);
        settings.putBoolean("shownInNotificationCenter", true);
        settings.putBoolean("shownInLockScreen", true);
        settings.putBoolean("shownAsHeadsupDisplay", true);
        break;
    }
    promise.resolve(settings);
  }
}
