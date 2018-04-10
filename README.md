## react-native-check-notification-enable
Device Information for react-native

## Installation

First you need to install react-native-check-notification-enable:

```javascript
npm install react-native-check-notification-enable --save
```

* In `android/setting.gradle`

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

```es6
// for es6
import { NotificationManager } from 'react-native-check-notification-enable'

NotificationManager.areNotificationsEnabled().then((e)=>{
  console.log(e);
}).catch((e)=>{
  console.log(e);
})
