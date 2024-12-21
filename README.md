# FaceTec App

## What is FaceTech?

**FaceTec** is a technology company specializing in advanced facial recognition and biometric solutions. Its primary focus is on providing software development kits (SDKs) that enable developers to integrate secure and reliable facial authentication into their applications for identity verification and fraud prevention.

### Key Features of FaceTec
1. **3D Liveness Detection**:
   - Uses 3D technology to confirm that the person being authenticated is a real, live human and not a spoof attempt like a photo or video.
   
2. **High Security**:
   - Provides encryption and anti-spoofing technologies to ensure secure and reliable authentication.

3. **Cross-Platform Support**:
   - Works on various platforms, including Android, iOS, and web browsers.

4. **Customizable SDK**:
   - Offers a developer-friendly SDK for integration into mobile and web applications.

5. **Scalability**:
   - Designed to handle a high volume of users, making it suitable for enterprises.

### Common Use Cases
1. **Identity Verification**:
   - Used in banking, financial services, and government applications to verify user identity remotely.

2. **Authentication**:
   - Provides biometric login for apps, replacing traditional passwords or PINs.

3. **Fraud Prevention**:
   - Ensures that only genuine users can access services, helping businesses prevent fraud.

4. **E-KYC (Know Your Customer)**:
   - Used during customer onboarding processes to confirm identities digitally.

### Industries That Use FaceTec
- **Financial Services**: Banking, fintech apps, and cryptocurrency platforms.
- **Healthcare**: Ensuring secure patient identification.
- **Retail and E-commerce**: Verifying customer identities for purchases or deliveries.
- **Government**: For digital identity programs and border control.

### Benefits
- Enhanced user convenience through quick and easy facial authentication.
- Improved security by reducing dependency on passwords and detecting spoof attempts.
- Cost-effective solution for identity verification compared to manual checks.

 [FaceTec official website](https://dev.facetec.com/).

## Structure Folders
    FaceTechApp/
    ├── android/
    │	├── app/
    │		 ├── facetec-sdk-96.105-minimal.aar
    │		 ├── facetec-sdk-96.105.aar
    ├── ios/
    ├── lib/
    │   ├── facetec_config.dart
    │   ├── main.dart
    ├── test/
    ├── pubspec.yaml
    ├── README.md
    └── .gitignore

## **Android `MainActivity` class** that integrates the **FaceTec SDK** into a Flutter application.

### **1. Class Overview**
The class extends `FlutterActivity`, which is the base activity for Flutter apps on Android. It integrates with the FaceTec SDK to perform biometric operations such as liveness detection.

---

### **2. Key Components**

#### **a. Method Channel**
```java
private static final String CHANNEL = "com.facetec.sdk";
```
- Defines a communication channel (`com.facetec.sdk`) for interacting between the Flutter Dart code and this native Android code.

---

#### **b. `configureFlutterEngine`**
```java
@Override
public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);

    BinaryMessenger binaryMessenger = flutterEngine.getDartExecutor().getBinaryMessenger();
    new MethodChannel(binaryMessenger, CHANNEL).setMethodCallHandler(this::onMethodCall);
}
```
- This sets up the `MethodChannel` when the Flutter app is running.
- `onMethodCall` handles incoming method calls from the Dart side.

---

### **3. Method Handling**

#### **a. `onMethodCall`**
```java
private void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
    if (Objects.equals(call.method, "initialize")) {
        String deviceKeyIdentifier = call.argument("deviceKeyIdentifier");
        String publicFaceScanEncryptionKey = call.argument("publicFaceScanEncryptionKey");
        initializeSDK(deviceKeyIdentifier, publicFaceScanEncryptionKey, result);
    }
    else if (Objects.equals(call.method, "startLiveness")) {
        startLiveness();
    }
    else {
        result.notImplemented();
    }
}
```
- Processes method calls from Flutter:
  - **`initialize`**: Initializes the FaceTec SDK using the `deviceKeyIdentifier` and `publicFaceScanEncryptionKey` provided by the Flutter side.
  - **`startLiveness`**: Launches a liveness detection session.
  - If the method is unrecognized, it returns `notImplemented()`.

---

### **4. Initializing the FaceTec SDK**
#### **a. Method**
```java
private void initializeSDK(String deviceKeyIdentifier, String publicFaceScanEncryptionKey, MethodChannel.Result result)
```
- **Input**:
  - `deviceKeyIdentifier` and `publicFaceScanEncryptionKey` (credentials for the FaceTec SDK).
  - `result`: Used to communicate the success or failure of the operation back to Flutter.
- **Process**:
  - A `FaceTecCustomization` object is used to customize the UI (e.g., setting a branding image).
  - The SDK is initialized in development mode.
- **Callback**:
  - Calls `result.success(true)` if initialization succeeds.
  - If it fails, it retrieves the SDK status and calls `result.error()`.

---

#### **b. Customization**
```java
FaceTecCustomization ftCustomization = new FaceTecCustomization();
ftCustomization.getOverlayCustomization().brandingImage = R.drawable.flutter_logo;
FaceTecSDK.setCustomization(ftCustomization);
```
- Sets the branding image for the FaceTec SDK UI using the Flutter logo.

---

### **5. Starting Liveness Detection**
#### **a. Method**
```java
private void startLiveness() {
    FaceTecSessionActivity.createAndLaunchSession(this, new FaceTecFaceScanProcessor() {
        @Override
        public void processSessionWhileFaceTecSDKWaits(FaceTecSessionResult faceTecSessionResult, FaceTecFaceScanResultCallback faceTecFaceScanResultCallback) {
            // TODO: Add code to handle processing
            faceTecFaceScanResultCallback.succeed();
        }
    });
}
```
- Launches a FaceTec liveness detection session.
- **FaceTecFaceScanProcessor**:
  - The session's result is processed through this callback.
  - For now, it simply calls `faceTecFaceScanResultCallback.succeed()` to mark the session as successful. You should add actual processing logic here (e.g., sending the face scan result to a server for verification).

---

### **6. Error Handling**
- If the SDK fails during initialization, it retrieves the error status:
```java
FaceTecSDKStatus status = FaceTecSDK.getStatus(context);
result.error(status.name(), status.toString(), null);
```
- Any unimplemented methods return:
```java
result.notImplemented();
```

---

### **Integrates with Flutter**
- The Flutter app calls methods like `initialize` and `startLiveness` through a Dart `MethodChannel`.
- This native code processes those calls and communicates back the results.

### **1. App Structure**

#### **Main Entry Point**
```dart
void main() {
  runApp(const MyApp());
}
```
- The `main` function is the app's entry point. It calls `runApp` with `MyApp`, which is the root widget of the application.

#### **MyApp Widget**
```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Face Tech',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Face Teck'),
    );
  }
}
```
- **Stateless Widget**: The `MyApp` class is a stateless widget that sets up the application.
- **MaterialApp**:
  - Configures the app theme and title.
  - Sets `MyHomePage` as the home screen.

#### **MyHomePage Widget**
```dart
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
```
- A **stateful widget** that displays the main interface for initializing the FaceTec SDK and starting the liveness detection.

---

### **2. MyHomePage State Management**

#### **State Variables**
```dart
bool _showLoading = true;
bool _isLivenessEnabled = false;

static const faceTecSDK = MethodChannel('com.facetec.sdk');
```
- `_showLoading`: Controls the visibility of the "Initializing SDK..." message.
- `_isLivenessEnabled`: Enables or disables the "Start" button.
- `faceTecSDK`: A `MethodChannel` to communicate with native Android code for FaceTec SDK operations.

#### **initState**
```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance
      .addPostFrameCallback((_) => _initializeFaceTecSDK());
}
```
- Called when the widget is first created.
- Adds a post-frame callback to call `_initializeFaceTecSDK` after the widget's build method.

---

### **3. SDK Initialization**

#### **_initializeFaceTecSDK Method**
```dart
Future<void> _initializeFaceTecSDK() async {
  try {
    if (FaceTecConfig.deviceKeyIdentifier.isEmpty) {
      return await _showErrorDialog(
          "Config Error", "You must define your deviceKeyIdentifier.");
    }

    await faceTecSDK.invokeMethod("initialize", {
      "deviceKeyIdentifier": FaceTecConfig.deviceKeyIdentifier,
      "publicFaceScanEncryptionKey": FaceTecConfig.publicFaceScanEncryptionKey
    });
    setState(() {
      _showLoading = false;
      _isLivenessEnabled = true;
    });
  } on PlatformException catch (e) {
    await _showErrorDialog("Initialize Error", "${e.code}: ${e.message}");
  }
}
```
- Checks for a valid `deviceKeyIdentifier`.
- Calls the `initialize` method in the native Android code using `faceTecSDK.invokeMethod`.
- If successful:
  - Hides the loading message (`_showLoading = false`).
  - Enables the "Start" button (`_isLivenessEnabled = true`).
- If an error occurs:
  - Displays an error dialog using `_showErrorDialog`.

---

### **4. Starting Liveness Detection**

#### **_startLiveness Method**
```dart
Future<void> _startLiveness() async {
  setState(() {
    _isLivenessEnabled = false;
  });

  await faceTecSDK.invokeMethod("startLiveness");
}
```
- Disables the "Start" button by setting `_isLivenessEnabled` to `false`.
- Invokes the `startLiveness` method in the native Android code using the `MethodChannel`.

---

### **5. Error Handling**
#### **_showErrorDialog Method**
```dart
Future<void> _showErrorDialog(String errorTitle, String errorMessage) async {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(errorTitle),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Dismiss"),
            )
          ],
        );
      });
}
```
- Displays an error dialog with a title and message.
- The "Dismiss" button closes the dialog.

---

### **6. UI Components**

#### **AppBar**
```dart
appBar: AppBar(
  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
  title: Text(widget.title),
),
```
- Displays the app title passed from the parent widget (`'Face Teck'`).

#### **Body**
```dart
body: Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      OutlinedButton(
        onPressed: _isLivenessEnabled
            ? () {
                _startLiveness();
              }
            : null,
        child: const Text('Start '),
      ),
      Visibility(
          visible: _showLoading,
          child: const Text('Initializing  SDK...'))
    ],
  ),
),
```
- **OutlinedButton**:
  - Disabled if `_isLivenessEnabled` is `false`.
  - Starts the liveness detection process when tapped.
- **Visibility**:
  - Displays "Initializing SDK..." while `_showLoading` is `true`.

---

### **Flow of the Application**

1. **App Launch**:
   - `initState` initializes the FaceTec SDK by calling `_initializeFaceTecSDK`.
2. **SDK Initialization**:
   - If successful:
     - Enables the "Start" button.
     - Hides the loading message.
   - If it fails:
     - Displays an error dialog.
3. **Liveness Detection**:
   - When the "Start" button is pressed, `_startLiveness` is invoked, which communicates with the native Android code to start the session.

---

