// DeviceAdminReceiverImpl.java
package com.cinisarboris.example.u04.oninit;

import android.app.admin.DeviceAdminReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

public class DeviceAdminReceiverImpl extends DeviceAdminReceiver {
    @Override
    public void onEnabled(Context context, Intent intent) {
        Log.d("DeviceAdmin", "Device Admin Enabled");
    }

    @Override
    public void onDisabled(Context context, Intent intent) {
        Log.d("DeviceAdmin", "Device Admin Disabled");
    }
}
