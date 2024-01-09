package com.cinisarboris.example.u02.alerta_caida;

import android.content.Context;
import android.media.AudioManager;

public class AudioHelper {

    private Context context;

    // Constructor que recibe el contexto de la aplicación o actividad
    public AudioHelper(Context context) {
        this.context = context;
    }

    // Método para establecer el volumen al máximo en la salida de música
    public void setVolumeToMax() {
        AudioManager audioManager = (AudioManager) context.getSystemService(Context.AUDIO_SERVICE);
        // Asegurarse de que estamos ajustando el volumen de la música
        int maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC);
        audioManager.setStreamVolume(
                AudioManager.STREAM_MUSIC,
                maxVolume,
                AudioManager.FLAG_SHOW_UI
        );
    }
}
