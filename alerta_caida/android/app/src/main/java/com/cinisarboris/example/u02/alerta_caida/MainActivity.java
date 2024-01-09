package com.cinisarboris.example.u02.alerta_caida;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle; // Importar Bundle
import android.os.PowerManager;
import android.net.Uri; // Importar Uri
import android.provider.Settings;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.cinisarboris.example/audio";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        checkBatteryOptimizations();
    }

    private void checkBatteryOptimizations() {
        String packageName = getPackageName();
        PowerManager pm = (PowerManager) getSystemService(Context.POWER_SERVICE);
        if (!pm.isIgnoringBatteryOptimizations(packageName)) {
            Intent intent = new Intent();
            intent.setAction(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS);
            intent.setData(Uri.parse("package:" + packageName));
            startActivity(intent);
        }
    }

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("setVolumeToMax")) {
                                AudioHelper audioHelper = new AudioHelper(getApplicationContext());
                                audioHelper.setVolumeToMax();
                                result.success(null);
                            } else if (call.method.equals("vibratePhone")) {
                                AudioHelper audioHelper = new AudioHelper(getApplicationContext());
                                audioHelper.vibratePhone();
                                result.success(null);
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }
}
