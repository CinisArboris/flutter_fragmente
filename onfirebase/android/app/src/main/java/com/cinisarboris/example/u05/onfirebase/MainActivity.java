package com.cinisarboris.example.u05.onfirebase;

import io.flutter.embedding.android.FlutterActivity;
import android.os.Bundle; // Importa Bundle aquí
import android.os.Build;
import android.app.NotificationChannel;
import android.app.NotificationManager;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        createNotificationChannel();
    }

    private void createNotificationChannel() {
        // Crea el canal de notificaciones para API 26+
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            CharSequence name = getString(R.string.channel_name);
            String description = getString(R.string.channel_description);
            int importance = NotificationManager.IMPORTANCE_HIGH;
            NotificationChannel channel = new NotificationChannel("high_importance_channel", name, importance);
            channel.setDescription(description);
            // Registra el canal en el sistema
            NotificationManager notificationManager = getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
        }
    }
}
