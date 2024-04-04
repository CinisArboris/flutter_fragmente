package com.cinisarboris.example.u02.onalert;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Intent;
import android.os.IBinder;

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;

public class AlertaCaidaService extends Service {
    // Identificador único de la notificación
    private static final int NOTIFICATION_ID = 777;
    private static final String DEFAULT_TITLE = "Alerta Caida";
    private static final String DEFAULT_MESSAGE = "La app está en segundo plano";

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        // Obtén el título y mensaje del intent, o utiliza los valores por defecto si no se proporcionan
        String title = intent.getStringExtra("title");
        String message = intent.getStringExtra("message");

        if (title == null || title.isEmpty()) {
            title = DEFAULT_TITLE;
        }

        if (message == null || message.isEmpty()) {
            message = DEFAULT_MESSAGE;
        }

        // Configura la notificación persistente
        Notification notification = buildNotification(title, message);
        startForeground(NOTIFICATION_ID, notification);

        // Aquí puedes agregar la lógica que quieras ejecutar en tu servicio
        // Por ejemplo, escuchar eventos de Firebase, etc.

        // Devuelve START_STICKY si quieres que el servicio se reinicie automáticamente si el sistema lo detiene
        return START_STICKY;
    }

    private Notification buildNotification(String title, String message) {
        // Construye la notificación persistente
        NotificationChannel channel = new NotificationChannel(
            "channel_id",
            "Channel Name",
            NotificationManager.IMPORTANCE_DEFAULT
        );
        getSystemService(NotificationManager.class).createNotificationChannel(channel);

        NotificationCompat.Builder builder = new NotificationCompat.Builder(this, "channel_id")
                // Icono de notificación
                .setSmallIcon(R.drawable.scorpion_icon)
                // Título personalizable
                .setContentTitle(title)
                // Mensaje personalizable
                .setContentText(message)
                .setPriority(NotificationCompat.PRIORITY_DEFAULT);

        return builder.build();
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        // Este es un servicio sin enlace, por lo que devolvemos null
        return null;
    }
}
