import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'facetec_config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

 
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showLoading = true;
  bool _isLivenessEnabled = false;

  static const faceTecSDK = MethodChannel('com.facetec.sdk');

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        
        title: Text(widget.title),
      ),
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
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _initializeFaceTecSDK());
  }

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

  Future<void> _startLiveness() async {
    setState(() {
      _isLivenessEnabled = false;
    });

    await faceTecSDK.invokeMethod("startLiveness");
  }

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
}
