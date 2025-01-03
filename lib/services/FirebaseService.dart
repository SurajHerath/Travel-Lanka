import 'package:firebase_core/firebase_core.dart';

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyCZwPOixZaBiqejg3kG0A_auNdWmxLZ2vo',
      appId: '1:143088996995:android:54d6ca1bd634100e4d01b6',
      messagingSenderId: 'sendid',
      projectId: 'travellanka-eb5e7',
      storageBucket: 'travellanka-eb5e7.firebasestorage.app',
    ),
  );
}
