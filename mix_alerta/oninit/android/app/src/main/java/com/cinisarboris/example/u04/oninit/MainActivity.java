// MainActivity.java
package com.cinisarboris.example.u04.oninit;

import io.flutter.embedding.android.FlutterActivity;
import android.os.Bundle;
import android.content.Intent;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.ComponentName;
import android.app.admin.DevicePolicyManager;

public class MainActivity extends FlutterActivity {
    static final int REQUEST_CODE_ENABLE_ADMIN = 1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Intent serviceIntent = new Intent(this, BackgroundService.class);
        startService(serviceIntent);
        requestAdminPermission();
    }

    private void requestAdminPermission() {
        ComponentName deviceAdmin = new ComponentName(this, DeviceAdminReceiverImpl.class);
        Intent intent = new Intent(DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN);
        intent.putExtra(DevicePolicyManager.EXTRA_DEVICE_ADMIN, deviceAdmin);
        intent.putExtra(DevicePolicyManager.EXTRA_ADD_EXPLANATION, 
            "Tu mensaje explicativo sobre por qué necesitas permisos de administrador.");
        startActivityForResult(intent, REQUEST_CODE_ENABLE_ADMIN);
    }

    @Override
    public void onBackPressed() {
        new AlertDialog.Builder(this)
            .setTitle("Confirmación de Salida")
            .setMessage("¿Estás seguro de que deseas cerrar la aplicación?")
            .setPositiveButton("Sí", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    MainActivity.super.onBackPressed();
                }
            })
            .setNegativeButton("No", null)
            .show();
    }
}
