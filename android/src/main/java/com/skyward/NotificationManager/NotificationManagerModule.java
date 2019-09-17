package com.skyward.NotificationManager;

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
        promise.reject(e.getMessage());
      }
  }
}
