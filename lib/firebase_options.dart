import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB1JhWlhKz6b8Q7WVUwTTlll-sX9LhkqjI',
    appId: '1:481250244224:android:1fedb27daec994ad2fd865',
    messagingSenderId: '481250244224',
    projectId: 'nexacode-73a1a',
    storageBucket: 'nexacode-73a1a.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD0HMQld0po03C1TA1Wfp5UryXCwJQznpA',
    appId: '1:481250244224:web:97af3a0ce7656b1f2fd865',
    messagingSenderId: '481250244224',
    projectId: 'nexacode-73a1a',
    authDomain: 'nexacode-73a1a.firebaseapp.com',
    storageBucket: 'nexacode-73a1a.firebasestorage.app',
    measurementId: 'G-LZDE5J836W',
  );

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;

    throw UnsupportedError('Platform not supported');
  }
}
