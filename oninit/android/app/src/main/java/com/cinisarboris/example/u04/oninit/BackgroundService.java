//BackgroundService.java
package com.cinisarboris.example.u04.oninit;

import android.app.Service;
import android.content.Intent;
import android.os.Handler;
import android.os.IBinder;
import android.util.Log;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.os.Build;

public class BackgroundService extends Service {
    private final Handler handler = new Handler();
    private Runnable runnable = new Runnable() {
        @Override
        public void run() {
            Log.d("BackgroundService", "Este mensaje se imprime cada 5 segundos");
            handler.postDelayed(this, 5000);
        }
    };

    @Override
    public void onCreate() {
        super.onCreate();
        startForegroundService();
        handler.postDelayed(runnable, 0);
    }

    private void startForegroundService() {
        String channelId = "background_service_channel";
        String channelName = "Background Service";
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(channelId, channelName, NotificationManager.IMPORTANCE_DEFAULT);
            NotificationManager notificationManager = getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);

            Notification notification = new Notification.Builder(this, channelId)
                    .setContentTitle("Servicio en Primer Plano")
                    .setContentText("El servicio está ejecutándose en primer plano.")
                    .setSmallIcon(R.drawable.blackhole)
                    .build();

            startForeground(1, notification);
        }
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        handler.removeCallbacks(runnable);
        stopForeground(true);
    }
}
