package com.esgi.co_habit_frontend

import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Autoriser les connexions HTTP pour le développement
        System.setProperty("net.openid.appauth.ConnectionBuilder", "com.esgi.co_habit_frontend.InsecureConnectionBuilder")
    }
}
