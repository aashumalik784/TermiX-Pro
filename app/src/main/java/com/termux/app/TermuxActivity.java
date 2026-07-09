package com.termux.app;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.view.KeyEvent;
import android.view.WindowManager;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.viewpager.widget.ViewPager;

import com.google.android.material.snackbar.Snackbar;
import com.termux.app.fragments.settings.TermuxPreferencesFragment;
import com.termux.shared.activity.ActivityUtils;
import com.termux.shared.android.AndroidUtils;
import com.termux.shared.errors.Errno;
import com.termux.shared.errors.Error;
import com.termux.shared.file.FileUtils;
import com.termux.shared.logger.Logger;
import com.termux.shared.shell.command.ExecutionCommand;
import com.termux.shared.shell.command.result.ResultConfig;
import com.termux.shared.shell.command.result.ResultData;
import com.termux.shared.termux.TermuxConstants;
import com.termux.shared.termux.settings.preferences.TermuxAppSharedPreferences;
import com.termux.shared.view.KeyboardUtils;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

/**
 * A {@link Activity} which displays the main terminal UI with a {@link ViewPager} to switch
 * between multiple terminal sessions.
 */
public class TermuxActivity extends Activity implements TermuxActivityRootView.TermuxActivityViewClient {
    
    private static final String TAG = "TermuxActivity";
    
    /** The {@link ViewPager} which displays the sessions. */
    private ViewPager mViewPager;
    
    /** The {@link TermuxActivityRootView} which contains the {@link #mViewPager}. */
    private TermuxActivityRootView mTermuxActivityRootView;
    
    /** The {@link TermuxTerminalSessionActivityClient} which handles session events. */
    private TermuxTerminalSessionActivityClient mTermuxTerminalSessionActivityClient;
    
    /** The {@link TermuxTerminalViewClient} which handles view events. */
    private TermuxTerminalViewClient mTermuxTerminalViewClient;
    
    /** The {@link TermuxService} which manages the sessions. */
    private TermuxService mTermuxService;
    
    /** Flag to track if TermiX-Pro setup is complete. */
    private boolean mTermiXProSetupComplete = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        // Initialize TermiX-Pro auto-setup
        initializeTermiXPro();
        
        // ... rest of original onCreate code remains same
        setContentView(R.layout.activity_termux);
        
        mTermuxActivityRootView = findViewById(R.id.termux_activity_root_view);
        mViewPager = mTermuxActivityRootView.findViewById(R.id.view_pager);
        
        // ... rest of original initialization code
    }
    
    /**
     * Initialize TermiX-Pro development environment
     * This runs on first launch to install 14 programming tools
     */
    private void initializeTermiXPro() {
        new Thread(() -> {
            File setupMarker = new File(Environment.getExternalStorageDirectory(), ".termix-pro-initialized");
            
            if (!setupMarker.exists()) {
                Logger.d(TAG, "TermiX-Pro first launch detected. Starting auto-setup...");
                
                try {
                    // Run setup script
                    ProcessBuilder pb = new ProcessBuilder(
                        "sh",
                        "-c",
                        "sh /data/data/com.termux/files/home/termux-app/scripts/autostart-termix-pro.sh"
                    );
                    pb.redirectErrorStream(true);
                    Process process = pb.start();
                    process.waitFor();
                    
                    Logger.d(TAG, "TermiX-Pro setup completed");
                } catch (IOException | InterruptedException e) {
                    Logger.e(TAG, "TermiX-Pro setup failed", e);
                }
            } else {
                mTermiXProSetupComplete = true;
                Logger.d(TAG, "TermiX-Pro already initialized");
            }
        }).start();
    }
    
    /**
     * Start web dashboard for TermiX-Pro
     */
    private void startWebDashboard() {
        new Thread(() -> {
            try {
                ProcessBuilder pb = new ProcessBuilder(
                    "sh",
                    "-c",
                    "sh /data/data/com.termux/files/home/termux-app/scripts/termix-web"
                );
                pb.redirectErrorStream(true);
                Process process = pb.start();
                process.waitFor();
            } catch (IOException | InterruptedException e) {
                Logger.e(TAG, "Failed to start web dashboard", e);
            }
        }).start();
    }
    
    // ... rest of original TermuxActivity methods remain unchanged
    // All original Termux functionality is preserved
    
    @Override
    public boolean onKeyUp(int keyCode, KeyEvent event) {
        // Original Termux key handling
        return super.onKeyUp(keyCode, event);
    }
    
    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions,
                                          @NonNull int[] grantResults) {
        // Original permission handling
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
    }
    
    // ... all other original methods
}
