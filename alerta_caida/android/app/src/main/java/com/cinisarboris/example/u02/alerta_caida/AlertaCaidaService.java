package com.cinisarboris.example.u02.alerta_caida;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import androidx.annotation.Nullable;

public class AlertaCaidaService extends Service {
    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        // Este es un servicio sin enlace, por lo que devolvemos null
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        // Aquí puedes agregar la lógica que quieras ejecutar en tu servicio
        // Por ejemplo, escuchar eventos de Firebase, etc.

        // Devuelve START_STICKY si quieres que el servicio se reinicie automáticamente si el sistema lo detiene
        return START_STICKY;
    }
}
