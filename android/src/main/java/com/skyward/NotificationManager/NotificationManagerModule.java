package com.skyward.NotificationManager;

import com.facebook.react.uimanager.*;
import com.facebook.react.bridge.*;
import com.facebook.react.bridge.Promise;
import com.facebook.systrace.Systrace;
import com.facebook.systrace.SystraceMessage;
import android.net.wifi.ScanResult;
import android.net.wifi.WifiManager;
import android.net.wifi.WifiConfiguration;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.content.Context;
import java.util.List;
import com.facebook.systrace.Systrace;
import com.facebook.systrace.SystraceMessage;

// import com.facebook.react.LifecycleState;
import com.facebook.react.ReactInstanceManager;
import com.facebook.react.ReactRootView;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.modules.core.DefaultHardwareBackBtnHandler;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.facebook.react.shell.MainReactPackage;
import com.facebook.soloader.SoLoader;

import java.util.Map;
import java.util.HashMap;
import java.util.concurrent.TimeUnit;

import android.support.v4.app.NotificationManagerCompat;


public class NotificationManagerModule extends ReactContextBaseJavaModule {
  public NotificationManagerModule(ReactApplicationContext reactContext) {
    super(reactContext);
  }

  private static final String NOTIFICATION_ERROR = "NOTIFICATION_ERROR";

  @Override
  public String getName() {
    return "NotificationManager";
  }

  @ReactMethod
  public void areNotificationsEnabled(final Promise promise) {
      try {
        Boolean areEnabled = NotificationManagerCompat.from(getReactApplicationContext()).areNotificationsEnabled();
        promise.resolve(areEnabled);
      }catch (Exception e) {
        promise.reject(e.getMessage());
      }
  }
}
