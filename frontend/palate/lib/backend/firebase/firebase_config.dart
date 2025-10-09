import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyD_IJ4ij-m37EJsxbsDgmhMvWm5430wf-E",
            authDomain: "palate-cve8jj.firebaseapp.com",
            projectId: "palate-cve8jj",
            storageBucket: "palate-cve8jj.firebasestorage.app",
            messagingSenderId: "322049939075",
            appId: "1:322049939075:web:26f22d2d262a585c0d2db6"));
  } else {
    await Firebase.initializeApp();
  }
}
