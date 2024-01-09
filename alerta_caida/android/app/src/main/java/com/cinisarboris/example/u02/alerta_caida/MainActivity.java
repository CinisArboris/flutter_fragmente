package com.cinisarboris.example.u02.alerta_caida;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.cinisarboris.example/audio";

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
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }
}
