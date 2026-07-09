package com.termux.app;

import android.app.Activity;
import android.os.Bundle;
import java.io.File;

public class TermuxActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        initializeTermiXPro();
        setContentView(R.layout.activity_termux);
    }

    private void initializeTermiXPro() {
        new Thread(() -> {
            File setupMarker = new File(android.os.Environment.getExternalStorageDirectory(), ".termix-pro-initialized");
            if (!setupMarker.exists()) {
                try {
                    ProcessBuilder pb = new ProcessBuilder("sh", "-c", "sh /data/data/com.termux/files/home/termux-app/scripts/autostart-termix-pro.sh");
                    pb.start().waitFor();
                } catch (Exception e) { e.printStackTrace(); }
            }
        }).start();
    }
}
