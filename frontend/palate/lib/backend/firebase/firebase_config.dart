import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAuuk3NnKc-bD6gG4I9PC9Fg13MTEB8kkI",
            authDomain: "palate-mvp.firebaseapp.com",
            projectId: "palate-mvp",
            storageBucket: "palate-mvp.firebasestorage.app",
            messagingSenderId: "371653324669",
            appId: "1:371653324669:web:b0ccb3565ca985412d6614",
            measurementId: "G-YJ526J7DYJ"));
  } else {
    await Firebase.initializeApp();
  }
}
