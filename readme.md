## react-native-check-notification-enable
Check if notifications are enabled for a React ative device running on Android.

| Version | React Native Support | Android Support | iOS Support |
|---|---|---|---|
| 1.1.0 | 0.47-0.54 | 8.1 | NONE |
| 1.0.4 | 0.46 | 8.1 | NONE |

*Complies with [react-native-version-support-table](https://github.com/dangnelson/react-native-version-support-table)*

## Installation

First you need to install react-native-check-notification-enable:

```javascript
npm install react-native-check-notification-enable --save
```

* In `android/settings.gradle`

```gradle
...
include ':react-native-check-notification-enable', ':app'
project(':react-native-check-notification-enable').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-check-notification-enable/android')
```

* In `android/app/build.gradle`

```gradle
...
dependencies {
    ...
    compile project(':react-native-check-notification-enable')
}
```

* register module (in MainActivity.java)

On newer versions of React Native (0.18+):

```java
import com.skyward.NotificationManager.NotificationManager; // <--- import

public class MainActivity extends ReactActivity {
  ......

  /**
   * A list of packages used by the app. If the app uses additional views
   * or modules besides the default ones, add more packages here.
   */
    @Override
    protected List<ReactPackage> getPackages() {
      return Arrays.<ReactPackage>asList(
        new NotificationManager() // <------ add here
        new MainReactPackage());
    }
}
```

## Example

### Load module
```javascript
var NotificationManager = require('react-native-check-notification-enable');
```

```javascript
// for es6
import NotificationManager from 'react-native-check-notification-enable'

// use as a promise...
NotificationManager.areNotificationsEnabled().then((e)=>{
  console.log(e);
}).catch((e)=>{
  console.log(e);
})

// ...or an async function
const enabled = await NotificationManager.areNotificationsEnabled();
```