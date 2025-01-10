[33mcommit 146f9f8669f29f6941371368728e7d8375cae459[m
Author: ayushqui <proayush736@gmail.com>
Date:   Wed Sep 25 09:07:14 2024 +0530

    dolby and other things

[1mdiff --git a/parts/src/org/lineageos/settings/BootCompletedReceiver.java b/parts/src/org/lineageos/settings/BootCompletedReceiver.java[m
[1mindex 116fd97..c7445d0 100644[m
[1m--- a/parts/src/org/lineageos/settings/BootCompletedReceiver.java[m
[1m+++ b/parts/src/org/lineageos/settings/BootCompletedReceiver.java[m
[36m@@ -22,9 +22,7 @@[m [mimport android.content.Context;[m
 import android.content.Intent;[m
 import android.content.IntentFilter;[m
 import android.util.Log;[m
[31m-[m
 import org.lineageos.settings.refreshrate.RefreshUtils;[m
[31m-import org.lineageos.settings.thermal.ThermalUtils;[m
 [m
 public class BootCompletedReceiver extends BroadcastReceiver {[m
 [m
[36m@@ -35,6 +33,6 @@[m [mpublic class BootCompletedReceiver extends BroadcastReceiver {[m
     public void onReceive(final Context context, Intent intent) {[m
         if (DEBUG) Log.d(TAG, "Received boot completed intent");[m
         RefreshUtils.initialize(context);[m
[31m-        ThermalUtils.startService(context);[m
     }[m
[32m+[m
 }[m
[1mdiff --git a/parts/src/org/lineageos/settings/RefreshRateTileService.java b/parts/src/org/lineageos/settings/RefreshRateTileService.java[m
[1mdeleted file mode 100644[m
[1mindex f3f6bce..0000000[m
[1m--- a/parts/src/org/lineageos/settings/RefreshRateTileService.java[m
[1m+++ /dev/null[m
[36m@@ -1,114 +0,0 @@[m
[31m-/*[m
[31m- * Copyright (C) 2021 crDroid Android Project[m
[31m- * Copyright (C) 2021 Chaldeaprjkt[m
[31m- *[m
[31m- * Licensed under the Apache License, Version 2.0 (the "License");[m
[31m- * you may not use this file except in compliance with the License.[m
[31m- * You may obtain a copy of the License at[m
[31m- *[m
[31m- *      http://www.apache.org/licenses/LICENSE-2.0[m
[31m- *[m
[31m- * Unless required by applicable law or agreed to in writing, software[m
[31m- * distributed under the License is distributed on an "AS IS" BASIS,[m
[31m- * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.[m
[31m- * See the License for the specific language governing permissions and[m
[31m- * limitations under the License.[m
[31m- */[m
[31m-[m
[31m-package org.lineageos.settings;[m
[31m-[m
[31m-import android.content.Context;[m
[31m-import android.provider.Settings;[m
[31m-import android.service.quicksettings.Tile;[m
[31m-import android.service.quicksettings.TileService;[m
[31m-import android.view.Display;[m
[31m-[m
[31m-import java.util.ArrayList;[m
[31m-import java.util.List;[m
[31m-import java.util.Locale;[m
[31m-[m
[31m-public class RefreshRateTileService extends TileService {[m
[31m-    private static final String KEY_MIN_REFRESH_RATE = "min_refresh_rate";[m
[31m-    private static final String KEY_PEAK_REFRESH_RATE = "peak_refresh_rate";[m
[31m-[m
[31m-    private Context context;[m
[31m-    private Tile tile;[m
[31m-[m
[31m-    private final List<Float> availableRates = new ArrayList<>();[m
[31m-    private int activeRateMin;[m
[31m-    private int activeRateMax;[m
[31m-[m
[31m-    @Override[m
[31m-    public void onCreate() {[m
[31m-        super.onCreate();[m
[31m-        context = getApplicationContext();[m
[31m-        Display.Mode mode = context.getDisplay().getMode();[m
[31m-        Display.Mode[] modes = context.getDisplay().getSupportedModes();[m
[31m-        for (Display.Mode m : modes) {[m
[31m-            float rate = Float.valueOf(String.format(Locale.US, "%.02f", m.getRefreshRate()));[m
[31m-            if (m.getPhysicalWidth() == mode.getPhysicalWidth() &&[m
[31m-                m.getPhysicalHeight() == mode.getPhysicalHeight()) {[m
[31m-                availableRates.add(rate);[m
[31m-            }[m
[31m-        }[m
[31m-        syncFromSettings();[m
[31m-    }[m
[31m-[m
[31m-    private int getSettingOf(String key) {[m
[31m-        float rate = Settings.System.getFloat(context.getContentResolver(), key, 120);[m
[31m-        return availableRates.indexOf([m
[31m-                Float.valueOf(String.format(Locale.US, "%.02f", rate)));[m
[31m-    }[m
[31m-[m
[31m-    private void syncFromSettings() {[m
[31m-        activeRateMin = getSettingOf(KEY_MIN_REFRESH_RATE);[m
[31m-        activeRateMax = getSettingOf(KEY_PEAK_REFRESH_RATE);[m
[31m-    }[m
[31m-[m
[31m-    private void cycleRefreshRate() {[m
[31m-        if(activeRateMax == 0){[m
[31m-    	    if(activeRateMin == 0){[m
[31m-                activeRateMin= availableRates.size();[m
[31m-	    }[m
[31m-	    activeRateMax = activeRateMin;[m
[31m-	    float rate = availableRates.get(activeRateMin - 1);[m
[31m-  	    Settings.System.putFloat(context.getContentResolver(), KEY_MIN_REFRESH_RATE, rate);[m
[31m-        }[m
[31m-        float rate = availableRates.get(activeRateMax - 1);[m
[31m-        Settings.System.putFloat(context.getContentResolver(), KEY_PEAK_REFRESH_RATE, rate);[m
[31m-    }[m
[31m-[m
[31m-    private String getFormatRate(float rate) {[m
[31m-        return String.format("%.02f Hz", rate)[m
[31m-                            .replaceAll("[\\.,]00", "");[m
[31m-    }[m
[31m-[m
[31m-    private void updateTileView() {[m
[31m-        String displayText;[m
[31m-        float min = availableRates.get(activeRateMin);[m
[31m-        float max = availableRates.get(activeRateMax);[m
[31m-[m
[31m-        displayText = String.format(Locale.US, min == max ? "%s" : "%s - %s",[m
[31m-            getFormatRate(min), getFormatRate(max));[m
[31m-        tile.setContentDescription(displayText);[m
[31m-        tile.setSubtitle(displayText);[m
[31m-        tile.setState(min == max ? Tile.STATE_ACTIVE : Tile.STATE_INACTIVE);[m
[31m-        tile.updateTile();[m
[31m-    }[m
[31m-[m
[31m-    @Override[m
[31m-    public void onStartListening() {[m
[31m-        super.onStartListening();[m
[31m-        tile = getQsTile();[m
[31m-        syncFromSettings();[m
[31m-        updateTileView();[m
[31m-    }[m
[31m-[m
[31m-    @Override[m
[31m-    public void onClick() {[m
[31m-        super.onClick();[m
[31m-        cycleRefreshRate();[m
[31m-        syncFromSettings();[m
[31m-        updateTileView();[m
[31m-    }[m
[31m-}[m
[1mdiff --git a/parts/src/org/lineageos/settings/dolby/DolbyActivity.java b/parts/src/org/lineageos/settings/dolby/DolbyActivity.java[m
[1mnew file mode 100644[m
[1mindex 0000000..346eeac[m
[1m--- /dev/null[m
[1m+++ b/parts/src/org/lineageos/settings/dolby/DolbyActivity.java[m
[36m@@ -0,0 +1,46 @@[m
[32m+[m[32m/*[m
[32m+[m[32m * Copyright (C) 2023 The LineageOS Project[m
[32m+[m[32m *[m
[32m+[m[32m * Licensed under the Apache License, Version 2.0 (the "License");[m
[32m+[m[32m * you may not use this file except in compliance with the License.[m
[32m+[m[32m * You may obtain a copy of the License at[m
[32m+[m[32m *[m
[32m+[m[32m *      http://www.apache.org/licenses/LICENSE-2.0[m
[32m+[m[32m *[m
[32m+[m[32m * Unless required by applicable law or agreed to in writing, software[m
[32m+[m[32m * distributed under the License is distributed on an "AS IS" BASIS,[m
[32m+[m[32m * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.[m
[32m+[m[32m * See the License for the specific language governing permissions and[m
[32m+[m[32m * limitations under the License.[m
[32m+[m[32m */[m
[32m+[m
[32m+[m[32mpackage org.lineageos.settings.dolby;[m
[32m+[m
[32m+[m[32mimport android.content.ComponentName;[m
[32m+[m[32mimport android.content.Intent;[m
[32m+[m[32mimport android.os.Bundle;[m
[32m+[m[32mimport android.widget.Toast;[m
[32m+[m
[32m+[m[32mimport com.android.settingslib.collapsingtoolbar.CollapsingToolbarBaseActivity;[m
[32m+[m
[32m+[m[32mpublic class DolbyActivity extends CollapsingToolbarBaseActivity {[m
[32m+[m
[32m+[m[32m    private static final String DAX_PACKAGE_NAME = "com.dolby.daxappui";[m
[32m+[m[32m    private static final String DAX_ACTIVITY = "com.dolby.daxappui.MainActivity";[m
[32m+[m
[32m+[m[32m    @Override[m
[32m+[m[32m    protected void onCreate(Bundle savedInstanceState) {[m
[32m+[m[32m        // super.onCreate(savedInstanceState);[m
[32m+[m
[32m+[m[32m        ComponentName componentName = new ComponentName(DAX_PACKAGE_NAME, DAX_ACTIVITY);[m
[32m+[m[32m        Intent intent = new Intent();[m
[32m+[m[32m        intent.setComponent(componentName);[m
[32m+[m[32m        startActivity(intent);[m
[32m+[m[32m        // if (intent != null) {[m
[32m+[m[32m        //     startActivity(intent);[m
[32m+[m[32m        // } else {[m
[32m+[m[32m        //     Toast.makeText(getApplicationContext(), "DaxUI not installed", Toast.LENGTH_SHORT).show();[m[41m  [m
[32m+[m[32m        // }[m
[32m+[m[41m        [m
[32m+[m[32m    }[m
[32m+[m[32m}[m
[1mdiff --git a/parts/src/org/lineageos/settings/thermal/ThermalSettingsActivity.java b/parts/src/org/lineageos/settings/speaker/ClearSpeakerActivity.java[m
[1msimilarity index 63%[m
[1mrename from parts/src/org/lineageos/settings/thermal/ThermalSettingsActivity.java[m
[1mrename to parts/src/org/lineageos/settings/speaker/ClearSpeakerActivity.java[m
[1mindex b41fd05..d1e74a4 100644[m
[1m--- a/parts/src/org/lineageos/settings/thermal/ThermalSettingsActivity.java[m
[1m+++ b/parts/src/org/lineageos/settings/speaker/ClearSpeakerActivity.java[m
[36m@@ -1,5 +1,5 @@[m
 /*[m
[31m- * Copyright (C) 2020 The LineageOS Project[m
[32m+[m[32m * Copyright (C) 2020 Paranoid Android[m
  *[m
  * Licensed under the Apache License, Version 2.0 (the "License");[m
  * you may not use this file except in compliance with the License.[m
[36m@@ -14,31 +14,22 @@[m
  * limitations under the License.[m
  */[m
 [m
[31m-package org.lineageos.settings.thermal;[m
[32m+[m[32mpackage org.lineageos.settings.speaker;[m
 [m
 import android.os.Bundle;[m
[31m-import android.view.MenuItem;[m
 [m
 import com.android.settingslib.collapsingtoolbar.CollapsingToolbarBaseActivity;[m
 import com.android.settingslib.widget.R;[m
 [m
[31m-public class ThermalSettingsActivity extends CollapsingToolbarBaseActivity {[m
[32m+[m[32mpublic class ClearSpeakerActivity extends CollapsingToolbarBaseActivity {[m
 [m
[31m-    private static final String TAG_THERMAL = "thermal";[m
[32m+[m[32m    private static final String TAG_CLEARSPEAKER = "clearspeaker";[m
 [m
     @Override[m
     protected void onCreate(Bundle savedInstanceState) {[m
         super.onCreate(savedInstanceState);[m
[31m-        getFragmentManager().beginTransaction().replace(R.id.content_frame,[m
[31m-                new ThermalSettingsFragment(), TAG_THERMAL).commit();[m
[31m-    }[m
 [m
[31m-    @Override[m
[31m-    public boolean onOptionsItemSelected(MenuItem item) {[m
[31m-        if (item.getItemId() == android.R.id.home) {[m
[31m-            onBackPressed();[m
[31m-            return true;[m
[31m-        }[m
[31m-        return false;[m
[32m+[m[32m        getFragmentManager().beginTransaction().replace(R.id.content_frame,[m
[32m+[m[32m                new ClearSpeakerFragment(), TAG_CLEARSPEAKER).commit();[m
     }[m
 }[m
[1mdiff --git a/parts/src/org/lineageos/settings/speaker/ClearSpeakerFragment.java b/parts/src/org/lineageos/settings/speaker/ClearSpeakerFragment.java[m
[1mnew file mode 100644[m
[1mindex 0000000..7242bc1[m
[1m--- /dev/null[m
[1m+++ b/parts/src/org/lineageos/settings/speaker/ClearSpeakerFragment.java[m
[36m@@ -0,0 +1,111 @@[m
[32m+[m[32m/*[m
[32m+[m[32m * Copyright (C) 2023 Paranoid Android[m
[32m+[m[32m *[m
[32m+[m[32m * Licensed under the Apache License, Version 2.0 (the "License");[m
[32m+[m[32m * you may not use this file except in compliance with the License.[m
[32m+[m[32m * You may obtain a copy of the License at[m
[32m+[m[32m *[m
[32m+[m[32m *      http://www.apache.org/licenses/LICENSE-2.0[m
[32m+[m[32m *[m
[32m+[m[32m * Unless required by applicable law or agreed to in writing, software[m
[32m+[m[32m * distributed under the License is distributed on an "AS IS" BASIS,[m
[32m+[m[32m * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.[m
[32m+[m[32m * See the License for the specific language governing permissions and[m
[32m+[m[32m * limitations under the License.[m
[32m+[m[32m */[m
[32m+[m
[32m+[m[32mpackage org.lineageos.settings.speaker;[m
[32m+[m
[32m+[m[32mimport android.content.res.AssetFileDescriptor;[m
[32m+[m[32mimport android.media.AudioAttributes;[m
[32m+[m[32mimport android.media.AudioManager;[m
[32m+[m[32mimport android.media.MediaPlayer;[m
[32m+[m[32mimport android.os.Bundle;[m
[32m+[m[32mimport android.os.Handler;[m
[32m+[m[32mimport android.os.Looper;[m
[32m+[m[32mimport android.util.Log;[m
[32m+[m
[32m+[m[32mimport androidx.preference.Preference;[m
[32m+[m[32mimport androidx.preference.PreferenceFragment;[m
[32m+[m[32mimport androidx.preference.SwitchPreference;[m
[32m+[m
[32m+[m[32mimport org.lineageos.settings.R;[m
[32m+[m
[32m+[m[32mimport java.io.IOException;[m
[32m+[m
[32m+[m[32mpublic class ClearSpeakerFragment extends PreferenceFragment implements[m
[32m+[m[32m        Preference.OnPreferenceChangeListener {[m
[32m+[m
[32m+[m[32m    private static final String TAG = "ClearSpeakerFragment";[m
[32m+[m[32m    private static final String PREF_CLEAR_SPEAKER = "clear_speaker_pref";[m
[32m+[m[32m    private static final int PLAY_DURATION_MS = 30000;[m
[32m+[m
[32m+[m[32m    private Handler mHandler = new Handler(Looper.getMainLooper());[m
[32m+[m[32m    private MediaPlayer mMediaPlayer;[m
[32m+[m[32m    private SwitchPreference mClearSpeakerPref;[m
[32m+[m
[32m+[m[32m    @Override[m
[32m+[m[32m    public void onCreatePreferences(Bundle savedInstanceState, String rootKey) {[m
[32m+[m[32m        addPreferencesFromResource(R.xml.clear_speaker_settings);[m
[32m+[m
[32m+[m[32m        mClearSpeakerPref = findPreference(PREF_CLEAR_SPEAKER);[m
[32m+[m[32m        mClearSpeakerPref.setOnPreferenceChangeListener(this);[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    @Override[m
[32m+[m[32m    public boolean onPreferenceChange(Preference preference, Object newValue) {[m
[32m+[m[32m        if (preference == mClearSpeakerPref) {[m
[32m+[m[32m            boolean value = (Boolean) newValue;[m
[32m+[m[32m            if (value && startPlaying()) {[m
[32m+[m[32m                mHandler.removeCallbacksAndMessages(null);[m
[32m+[m[32m                mHandler.postDelayed(this::stopPlaying, PLAY_DURATION_MS);[m
[32m+[m[32m                return true;[m
[32m+[m[32m            }[m
[32m+[m[32m        }[m
[32m+[m[32m        return false;[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    @Override[m
[32m+[m[32m    public void onStop() {[m
[32m+[m[32m        super.onStop();[m
[32m+[m[32m        stopPlaying();[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    public boolean startPlaying() {[m
[32m+[m[32m        getActivity().setVolumeControlStream(AudioManager.STREAM_MUSIC);[m
[32m+[m[32m        mMediaPlayer = new MediaPlayer();[m
[32m+[m[32m        mMediaPlayer.setAudioAttributes(new AudioAttributes.Builder()[m
[32m+[m[32m                .setUsage(AudioAttributes.USAGE_MEDIA)[m
[32m+[m[32m                .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)[m
[32m+[m[32m                .build());[m
[32m+[m[32m        mMediaPlayer.setLooping(true);[m
[32m+[m[32m        try (AssetFileDescriptor afd = getResources().openRawResourceFd([m
[32m+[m[32m                R.raw.clear_speaker_sound)) {[m
[32m+[m[32m            mMediaPlayer.setDataSource(afd);[m
[32m+[m[32m            mMediaPlayer.setVolume(1.0f, 1.0f);[m
[32m+[m[32m            mMediaPlayer.prepare();[m
[32m+[m[32m            mMediaPlayer.start();[m
[32m+[m[32m            mClearSpeakerPref.setEnabled(false);[m
[32m+[m[32m        } catch (IOException | IllegalArgumentException e) {[m
[32m+[m[32m            Log.e(TAG, "Failed to play speaker clean sound!", e);[m
[32m+[m[32m            return false;[m
[32m+[m[32m        }[m
[32m+[m[32m        return true;[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    public void stopPlaying() {[m
[32m+[m[32m        if (mMediaPlayer != null && mMediaPlayer.isPlaying()) {[m
[32m+[m[32m            try {[m
[32m+[m[32m                mMediaPlayer.stop();[m
[32m+[m[32m            } catch (IllegalStateException e) {[m
[32m+[m[32m                Log.e(TAG, "Failed to stop media player!", e);[m
[32m+[m[32m            } finally {[m
[32m+[m[32m                mMediaPlayer.reset();[m
[32m+[m[32m                mMediaPlayer.release();[m
[32m+[m[32m                mMediaPlayer=null;[m
[32m+[m[32m            }[m
[32m+[m[32m        }[m
[32m+[m[32m        mClearSpeakerPref.setEnabled(true);[m
[32m+[m[32m        mClearSpeakerPref.setChecked(false);[m
[32m+[m[32m    }[m
[32m+[m[32m}[m
[1mdiff --git a/parts/src/org/lineageos/settings/thermal/ThermalService.java b/parts/src/org/lineageos/settings/thermal/ThermalService.java[m
[1mdeleted file mode 100644[m
[1mindex 37dc983..0000000[m
[1m--- a/parts/src/org/lineageos/settings/thermal/ThermalService.java[m
[1m+++ /dev/null[m
[36m@@ -1,96 +0,0 @@[m
[31m-/*[m
[31m- * Copyright (C) 2020 The LineageOS Project[m
[31m- *[m
[31m- * Licensed under the Apache License, Version 2.0 (the "License");[m
[31m- * you may not use this file except in compliance with the License.[m
[31m- * You may obtain a copy of the License at[m
[31m- *[m
[31m- *      http://www.apache.org/licenses/LICENSE-2.0[m
[31m- *[m
[31m- * Unless required by applicable law or agreed to in writing, software[m
[31m- * distributed under the License is distributed on an "AS IS" BASIS,[m
[31m- * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.[m
[31m- * See the License for the specific language governing permissions and[m
[31m- * limitations under the License.[m
[31m- */[m
[31m-[m
[31m-package org.lineageos.settings.thermal;[m
[31m-[m
[31m-import android.app.ActivityTaskManager;[m
[31m-import android.app.TaskStackListener;[m
[31m-import android.app.Service;[m
[31m-import android.content.BroadcastReceiver;[m
[31m-import android.content.ComponentName;[m
[31m-import android.content.Context;[m
[31m-import android.content.Intent;[m
[31m-import android.content.IntentFilter;[m
[31m-import android.content.res.Configuration;[m
[31m-import android.os.IBinder;[m
[31m-import android.os.RemoteException;[m
[31m-import android.util.Log;[m
[31m-[m
[31m-public class ThermalService extends Service {[m
[31m-[m
[31m-    private static final String TAG = "ThermalService";[m
[31m-    private static final boolean DEBUG = false;[m
[31m-[m
[31m-    private String mPreviousApp;[m
[31m-    private ThermalUtils mThermalUtils;[m
[31m-[m
[31m-    private BroadcastReceiver mIntentReceiver = new BroadcastReceiver() {[m
[31m-        @Override[m
[31m-        public void onReceive(Context context, Intent intent) {[m
[31m-            mPreviousApp = "";[m
[31m-            mThermalUtils.setDefaultThermalProfile();[m
[31m-        }[m
[31m-    };[m
[31m-[m
[31m-    @Override[m
[31m-    public void onCreate() {[m
[31m-        if (DEBUG) Log.d(TAG, "Creating service");[m
[31m-        try {[m
[31m-            ActivityTaskManager.getService().registerTaskStackListener(mTaskListener);[m
[31m-        } catch (RemoteException e) {[m
[31m-            // Do nothing[m
[31m-        }[m
[31m-        mThermalUtils = new ThermalUtils(this);[m
[31m-        registerReceiver();[m
[31m-        super.onCreate();[m
[31m-    }[m
[31m-[m
[31m-    @Override[m
[31m-    public int onStartCommand(Intent intent, int flags, int startId) {[m
[31m-        if (DEBUG) Log.d(TAG, "Starting service");[m
[31m-        return START_STICKY;[m
[31m-    }[m
[31m-[m
[31m-    @Override[m
[31m-    public IBinder onBind(Intent intent) {[m
[31m-        return null;[m
[31m-    }[m
[31m-[m
[31m-    private void registerReceiver() {[m
[31m-        IntentFilter filter = new IntentFilter();[m
[31m-        filter.addAction(Intent.ACTION_SCREEN_OFF);[m
[31m-        filter.addAction(Intent.ACTION_SCREEN_ON);[m
[31m-        this.registerReceiver(mIntentReceiver, filter);[m
[31m-    }[m
[31m-[m
[31m-    private final TaskStackListener mTaskListener = new TaskStackListener() {[m
[31m-        @Override[m
[31m-        public void onTaskStackChanged() {[m
[31m-            try {[m
[31m-                final ActivityTaskManager.RootTaskInfo focusedTask =[m
[31m-                        ActivityTaskManager.getService().getFocusedRootTaskInfo();[m
[31m-                if (focusedTask != null && focusedTask.topActivity != null) {[m
[31m-                    ComponentName taskComponentName = focusedTask.topActivity;[m
[31m-                    String foregroundApp = taskComponentName.getPackageName();[m
[31m-                    if (!foregroundApp.equals(mPreviousApp)) {[m
[31m-                        mThermalUtils.setThermalProfile(foregroundApp);[m
[31m-                        mPreviousApp = foregroundApp;[m
[31m-                    }[m
[31m-                }[m
[31m-            } catch (Exception e) {}[m
[31m-        }[m
[31m-    };[m
[31m-}[m
[1mdiff --git a/parts/src/org/lineageos/settings/thermal/ThermalSettingsFragment.java b/parts/src/org/lineageos/settings/thermal/ThermalSettingsFragment.java[m
[1mdeleted file mode 100644[m
[1mindex 0fe045c..0000000[m
[1m--- a/parts/src/org/lineageos/settings/thermal/ThermalSettingsFragment.java[m
[1m+++ /dev/null[m
[36m@@ -1,433 +0,0 @@[m
[31m-/**[m
[31m- * Copyright (C) 2020 The LineageOS Project[m
[31m- *[m
[31m- * Licensed under the Apache License, Version 2.0 (the "License");[m
[31m- * you may not use this file except in compliance with the License.[m
[31m- * You may obtain a copy of the License at[m
[31m- *[m
[31m- *      http://www.apache.org/licenses/LICENSE-2.0[m
[31m- *[m
[31m- * Unless required by applicable law or agreed to in writing, software[m
[31m- * distributed under the License is distributed on an "AS IS" BASIS,[m
[31m- * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.[m
[31m- * See the License for the specific language governing permissions and[m
[31m- * limitations under the License.[m
[31m- */[m
[31m-[m
[31m-package org.lineageos.settings.thermal;[m
[31m-[m
[31m-import android.annotation.Nullable;[m
[31m-import android.content.Context;[m
[31m-import android.content.Intent;[m
[31m-import android.content.pm.ApplicationInfo;[m
[31m-import android.content.pm.PackageManager;[m
[31m-import android.content.pm.ResolveInfo;[m
[31m-import android.os.Bundle;[m
[31m-import android.text.TextUtils;[m
[31m-import android.util.TypedValue;[m
[31m-import android.view.LayoutInflater;[m
[31m-import android.view.View;[m
[31m-import android.view.ViewGroup;[m
[31m-import android.widget.AdapterView;[m
[31m-import android.widget.BaseAdapter;[m
[31m-import android.widget.ImageView;[m
[31m-import android.widget.ListView;[m
[31m-import android.widget.SectionIndexer;[m
[31m-import android.widget.Spinner;[m
[31m-import android.widget.TextView;[m
[31m-[m
[31m-import androidx.annotation.NonNull;[m
[31m-import androidx.preference.PreferenceFragment;[m
[31m-import androidx.recyclerview.widget.RecyclerView;[m
[31m-import androidx.recyclerview.widget.LinearLayoutManager;[m
[31m-[m
[31m-import com.android.settingslib.applications.ApplicationsState;[m
[31m-[m
[31m-import org.lineageos.settings.R;[m
[31m-[m
[31m-import java.util.ArrayList;[m
[31m-import java.util.Arrays;[m
[31m-import java.util.HashMap;[m
[31m-import java.util.List;[m
[31m-import java.util.Map;[m
[31m-[m
[31m-public class ThermalSettingsFragment extends PreferenceFragment[m
[31m-        implements ApplicationsState.Callbacks {[m
[31m-[m
[31m-    private AllPackagesAdapter mAllPackagesAdapter;[m
[31m-    private ApplicationsState mApplicationsState;[m
[31m-    private ApplicationsState.Session mSession;[m
[31m-    private ActivityFilter mActivityFilter;[m
[31m-    private Map<String, ApplicationsState.AppEntry> mEntryMap =[m
[31m-            new HashMap<String, ApplicationsState.AppEntry>();[m
[31m-[m
[31m-    private ThermalUtils mThermalUtils;[m
[31m-    private RecyclerView mAppsRecyclerView;[m
[31m-[m
[31m-    @Override[m
[31m-    public void onCreatePreferences(Bundle savedInstanceState, String rootKey) {[m
[31m-    }[m
[31m-[m
[31m-    @Override[m
[31m-    public void onCreate(Bundle savedInstanceState) {[m
[31m-        super.onCreate(savedInstanceState);[m
[31m-[m
[31m-        mApplicationsState = ApplicationsState.getInstance(getActivity().getApplication());[m
[31m-        mSession = mApplicationsState.newSession(this);[m
[31m-        mSession.onResume();[m
[31m-        mActivityFilter = new ActivityFilter(getActivity().getPackageManager());[m
[31m-[m
[31m-        mAllPackagesAdapter = new AllPackagesAdapter(getActivity());[m
[31m-[m
[31m-        mThermalUtils = new ThermalUtils(getActivity());[m
[31m-    }[m
[31m-[m
[31m-    @Override[m
[31m-    public View onCreateView(LayoutInflater inflater, ViewGroup container,[m
[31m-            Bundle savedInstanceState) {[m
[31m-        return inflater.inflate(R.layout.thermal_layout, container, false);[m
[31m-    }[m
[31m-[m
[31m-    @Override[m
[31m-    public void onViewCreated(final View view, @Nullable Bundle savedInstanceState) {[m
[31m-        super.onViewCreated(view, savedInstanceState);[m
[31m-[m
[31m-        mAppsRecyclerView = view.findViewById(R.id.thermal_rv_view);[m
[31m-        mAppsRecyclerView.setLayoutManager(new LinearLayoutManager(getActivity()));[m
[31m-        mAppsRecyclerView.setAdapter(mAllPackagesAdapter);[m
[31m-    }[m
[31m-[m
[31m-[m
[31m-    @Override[m
[31m-    public void onResume() {[m
[31m-        super.onResume();[m
[31m-        getActivity().setTitle(getResources().getString(R.string.thermal_title));[m
[31m-        rebuild();[m
[31m-    }[m
[31m-[m
[31m-    @Override[m
[31m-    public void onDestroy() {[m
[31m-        super.onDestroy();[m
[31m-[m
[31m-        mSession.onPause();[m
[31m-        mSession.onDestroy();[m
[31m-    }[m
[31m-[m
[31m-    @Override[m
[31m-    public void onPackageListChanged() {[m
[31m-        mActivityFilter.updateLauncherInfoList();[m
[31m-        rebuild();[m
[31m-    }[m
[31m-[m
[31m-    @Override[m
[31m-    public void onRebuildComplete(ArrayList<ApplicationsState.AppEntry> entries) {[m
[31m-        if (entries != null) {[m
[31m-            handleAppEntries(entries);[m
[31m-            mAllPackagesAdapter.notifyDataSetChanged();[m
[31m-        }[m
[31m-    }[m
[31m-[m
[31m-    @Override[m
[31m-    public void onLoadEntriesCompleted() {[m
[31m-        rebuild();[m
[31m-    }[m
[31m-[m
[31m-    @Override[m
[31m-    public void onAllSizesComputed() {[m
[31m-    }[m
[31m-[m
[31m-    @Override[m
[31m-    public void onLauncherInfoChanged() {[m
[31m-    }[m
[31m-[m
[31m-    @Override[m
[31m-    public void onPackageIconChanged() {[m
[31m-    }[m
[31m-[m
[31m-    @Override[m
[31m-    public void onPackageSizeChanged(String packageName) {[m
[31m-    }[m
[31m-[m
[31m-    @Override[m
[31m-    public void onRunningStateChanged(boolean running) {[m
[31m-    }[m
[31m-[m
[31m-    private void handleAppEntries(List<ApplicationsState.AppEntry> entries) {[m
[31m-        final ArrayList<String> sections = new ArrayList<String>();[m
[31m-        final ArrayList<Integer> positions = new ArrayList<Integer>();[m
[31m-        final PackageManager pm = getActivity().getPackageManager();[m
[31m-        String lastSectionIndex = null;[m
[31m-        int offset = 0;[m
[31m-[m
[31m-        for (int i = 0; i < entries.size(); i++) {[m
[31m-            final ApplicationInfo info = entries.get(i).info;[m
[31m-            final String label = (String) info.loadLabel(pm);[m
[31m-            final String sectionIndex;[m
[31m-[m
[31m-            if (!info.enabled) {[m
[31m-                sectionIndex = "--"; // XXX[m
[31m-            } else if (TextUtils.isEmpty(label)) {[m
[31m-                sectionIndex = "";[m
[31m-            } else {[m
[31m-                sectionIndex = label.substring(0, 1).toUpperCase();[m
[31m-            }[m
[31m-[m
[31m-            if (lastSectionIndex == null ||[m
[31m-                    !TextUtils.equals(sectionIndex, lastSectionIndex)) {[m
[31m-                sections.add(sectionIndex);[m
[31m-                positions.add(offset);[m
[31m-                lastSectionIndex = sectionIndex;[m
[31m-            }[m
[31m-[m
[31m-            offset++;[m
[31m-        }[m
[31m-[m
[31m-        mAllPackagesAdapter.setEntries(entries, sections, positions);[m
[31m-        mEntryMap.clear();[m
[31m-        for (ApplicationsState.AppEntry e : entries) {[m
[31m-            mEntryMap.put(e.info.packageName, e);[m
[31m-        }[m
[31m-    }[m
[31m-[m
[31m-    private void rebuild() {[m
[31m-        mSession.rebuild(mActivityFilter, ApplicationsState.ALPHA_COMPARATOR);[m
[31m-    }[m
[31m-[m
[31m-    private int getStateDrawable(int state) {[m
[31m-        switch (state) {[m
[31m-            case ThermalUtils.STATE_BENCHMARK:[m
[31m-                return R.drawable.ic_thermal_benchmark;[m
[31m-            case ThermalUtils.STATE_BROWSER:[m
[31m-                return R.drawable.ic_thermal_browser;[m
[31m-            case ThermalUtils.STATE_CAMERA:[m
[31m-                return R.drawable.ic_thermal_camera;[m
[31m-            case ThermalUtils.STATE_DIALER:[m
[31m-                return R.drawable.ic_thermal_dialer;[m
[31m-            case ThermalUtils.STATE_GAMING:[m
[31m-                return R.drawable.ic_thermal_gaming;[m
[31m-            case ThermalUtils.STATE_STREAMING:[m
[31m-                return R.drawable.ic_thermal_streaming;[m
[31m-            case ThermalUtils.STATE_DEFAULT:[m
[31m-            default:[m
[31m-                return R.drawable.ic_thermal_default;[m
[31m-        }[m
[31m-    }[m
[31m-[m
[31m-    private class ViewHolder extends RecyclerView.ViewHolder {[m
[31m-        private TextView title;[m
[31m-        private Spinner mode;[m
[31m-        private ImageView icon;[m
[31m-        private View rootView;[m
[31m-        private ImageView stateIcon;[m
[31m-[m
[31m-        private ViewHolder(View view) {[m
[31m-            super(view);[m
[31m-            this.title = view.findViewById(R.id.app_name);[m
[31m-            this.mode = view.findViewById(R.id.app_mode);[m
[31m-            this.icon = view.findViewById(R.id.app_icon);[m
[31m-            this.stateIcon = view.findViewById(R.id.state);[m
[31m-            this.rootView = view;[m
[31m-[m
[31m-            view.setTag(this);[m
[31m-        }[m
[31m-    }[m
[31m-[m
[31m-    private class ModeAdapter extends BaseAdapter {[m
[31m-[m
[31m-        private final LayoutInflater inflater;[m
[31m-        private final int[] items = {[m
[31m-                R.string.thermal_default,[m
[31m-                R.string.thermal_benchmark,[m
[31m-                R.string.thermal_browser,[m
[31m-                R.string.thermal_camera,[m
[31m-                R.string.thermal_dialer,[m
[31m-                R.string.thermal_gaming,[m
[31m-                R.string.thermal_streaming[m
[31m-        };[m
[31m-[m
[31m-        private ModeAdapter(Context context) {[m
[31m-            inflater = LayoutInflater.from(context);[m
[31m-        }[m
[31m-[m
[31m-        @Override[m
[31m-        public int getCount() {[m
[31m-            return items.length;[m
[31m-        }[m
[31m-[m
[31m-        @Override[m
[31m-        public Object getItem(int position) {[m
[31m-            return items[position];[m
[31m-        }[m
[31m-[m
[31m-        @Override[m
[31m-        public long getItemId(int position) {[m
[31m-            return 0;[m
[31m-        }[m
[31m-[m
[31m-        @Override[m
[31m-        public View getView(int position, View convertView, ViewGroup parent) {[m
[31m-            TextView view;[m
[31m-            if (convertView != null) {[m
[31m-                view = (TextView) convertView;[m
[31m-            } else {[m
[31m-                view = (TextView) inflater.inflate(android.R.layout.simple_spinner_dropdown_item,[m
[31m-                        parent, false);[m
[31m-            }[m
[31m-[m
[31m-            view.setText(items[position]);[m
[31m-            view.setTextSize(14f);[m
[31m-            return view;[m
[31m-        }[m
[31m-    }[m
[31m-[m
[31m-    private class AllPackagesAdapter extends RecyclerView.Adapter<ViewHolder>[m
[31m-            implements AdapterView.OnItemSelectedListener, SectionIndexer {[m
[31m-[m
[31m-        private List<ApplicationsState.AppEntry> mEntries = new ArrayList<>();[m
[31m-        private String[] mSections;[m
[31m-        private int[] mPositions;[m
[31m-[m
[31m-        public AllPackagesAdapter(Context context) {[m
[31m-            mActivityFilter = new ActivityFilter(context.getPackageManager());[m
[31m-        }[m
[31m-[m
[31m-        @Override[m
[31m-        public int getItemCount() {[m
[31m-            return mEntries.size();[m
[31m-        }[m
[31m-[m
[31m-        @Override[m
[31m-        public long getItemId(int position) {[m
[31m-            return mEntries.get(position).id;[m
[31m-        }[m
[31m-[m
[31m-        @NonNull[m
[31m-        @Override[m
[31m-        public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {[m
[31m-            return new ViewHolder(LayoutInflater.from(parent.getContext())[m
[31m-                    .inflate(R.layout.thermal_list_item, parent, false));[m
[31m-        }[m
[31m-[m
[31m-        @Override[m
[31m-        public void onBindViewHolder(ViewHolder holder, int position) {[m
[31m-            Context context = holder.itemView.getContext();[m
[31m-            ApplicationsState.AppEntry entry = mEntries.get(position);[m
[31m-            if (entry == null) {[m
[31m-                return;[m
[31m-            }[m
[31m-[m
[31m-            holder.mode.setAdapter(new ModeAdapter(context));[m
[31m-            holder.mode.setOnItemSelectedListener(this);[m
[31m-[m
[31m-            holder.title.setText(entry.label);[m
[31m-            holder.title.setOnClickListener(v -> holder.mode.performClick());[m
[31m-[m
[31m-            mApplicationsState.ensureIcon(entry);[m
[31m-            holder.icon.setImageDrawable(entry.icon);[m
[31m-[m
[31m-            int packageState = mThermalUtils.getStateForPackage(entry.info.packageName);[m
[31m-            holder.mode.setSelection(packageState, false);[m
[31m-            holder.mode.setTag(entry);[m
[31m-            holder.stateIcon.setImageResource(getStateDrawable(packageState));[m
[31m-        }[m
[31m-[m
[31m-        private void setEntries(List<ApplicationsState.AppEntry> entries,[m
[31m-                List<String> sections, List<Integer> positions) {[m
[31m-            mEntries = entries;[m
[31m-            mSections = sections.toArray(new String[sections.size()]);[m
[31m-            mPositions = new int[positions.size()];[m
[31m-            for (int i = 0; i < positions.size(); i++) {[m
[31m-                mPositions[i] = positions.get(i);[m
[31m-            }[m
[31m-            notifyDataSetChanged();[m
[31m-        }[m
[31m-[m
[31m-[m
[31m-        @Override[m
[31m-        public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {[m
[31m-            final ApplicationsState.AppEntry entry = (ApplicationsState.AppEntry) parent.getTag();[m
[31m-            int currentState = mThermalUtils.getStateForPackage(entry.info.packageName);[m
[31m-            if (currentState != position) {[m
[31m-                mThermalUtils.writePackage(entry.info.packageName, position);[m
[31m-                notifyDataSetChanged();[m
[31m-            }[m
[31m-        }[m
[31m-[m
[31m-        @Override[m
[31m-        public void onNothingSelected(AdapterView<?> parent) {[m
[31m-        }[m
[31m-[m
[31m-        @Override[m
[31m-        public int getPositionForSection(int section) {[m
[31m-            if (section < 0 || section >= mSections.length) {[m
[31m-                return -1;[m
[31m-            }[m
[31m-[m
[31m-            return mPositions[section];[m
[31m-        }[m
[31m-[m
[31m-        @Override[m
[31m-        public int getSectionForPosition(int position) {[m
[31m-            if (position < 0 || position >= getItemCount()) {[m
[31m-                return -1;[m
[31m-            }[m
[31m-[m
[31m-            final int index = Arrays.binarySearch(mPositions, position);[m
[31m-[m
[31m-            /*[m
[31m-             * Consider this example: section positions are 0, 3, 5; the supplied[m
[31m-             * position is 4. The section corresponding to position 4 starts at[m
[31m-             * position 3, so the expected return value is 1. Binary search will not[m
[31m-             * find 4 in the array and thus will return -insertPosition-1, i.e. -3.[m
[31m-             * To get from that number to the expected value of 1 we need to negate[m
[31m-             * and subtract 2.[m
[31m-             */[m
[31m-            return index >= 0 ? index : -index - 2;[m
[31m-        }[m
[31m-[m
[31m-        @Override[m
[31m-        public Object[] getSections() {[m
[31m-            return mSections;[m
[31m-        }[m
[31m-    }[m
[31m-[m
[31m-    private class ActivityFilter implements ApplicationsState.AppFilter {[m
[31m-[m
[31m-        private final PackageManager mPackageManager;[m
[31m-        private final List<String> mLauncherResolveInfoList = new ArrayList<String>();[m
[31m-[m
[31m-        private ActivityFilter(PackageManager packageManager) {[m
[31m-            this.mPackageManager = packageManager;[m
[31m-[m
[31m-            updateLauncherInfoList();[m
[31m-        }[m
[31m-[m
[31m-        public void updateLauncherInfoList() {[m
[31m-            Intent i = new Intent(Intent.ACTION_MAIN);[m
[31m-            i.addCategory(Intent.CATEGORY_LAUNCHER);[m
[31m-            List<ResolveInfo> resolveInfoList = mPackageManager.queryIntentActivities(i, 0);[m
[31m-[m
[31m-            synchronized (mLauncherResolveInfoList) {[m
[31m-                mLauncherResolveInfoList.clear();[m
[31m-                for (ResolveInfo ri : resolveInfoList) {[m
[31m-                    mLauncherResolveInfoList.add(ri.activityInfo.packageName);[m
[31m-                }[m
[31m-            }[m
[31m-        }[m
[31m-[m
[31m-        @Override[m
[31m-        public void init() {[m
[31m-        }[m
[31m-[m
[31m-        @Override[m
[31m-        public boolean filterApp(ApplicationsState.AppEntry entry) {[m
[31m-            boolean show = !mAllPackagesAdapter.mEntries.contains(entry.info.packageName);[m
[31m-            if (show) {[m
[31m-                synchronized (mLauncherResolveInfoList) {[m
[31m-                    show = mLauncherResolveInfoList.contains(entry.info.packageName);[m
[31m-                }[m
[31m-            }[m
[31m-            return show;[m
[31m-        }[m
[31m-    }[m
[31m-}[m
[1mdiff --git a/parts/src/org/lineageos/settings/thermal/ThermalUtils.java b/parts/src/org/lineageos/settings/thermal/ThermalUtils.java[m
[1mdeleted file mode 100644[m
[1mindex 08c021e..0000000[m
[1m--- a/parts/src/org/lineageos/settings/thermal/ThermalUtils.java[m
[1m+++ /dev/null[m
[36m@@ -1,176 +0,0 @@[m
[31m-/*[m
[31m- * Copyright (C) 2020 The LineageOS Project[m
[31m- *[m
[31m- * Licensed under the Apache License, Version 2.0 (the "License");[m
[31m- * you may not use this file except in compliance with the License.[m
[31m- * You may obtain a copy of the License at[m
[31m- *[m
[31m- *      http://www.apache.org/licenses/LICENSE-2.0[m
[31m- *[m
[31m- * Unless required by applicable law or agreed to in writing, software[m
[31m- * distributed under the License is distributed on an "AS IS" BASIS,[m
[31m- * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.[m
[31m- * See the License for the specific language governing permissions and[m
[31m- * limitations under the License.[m
[31m- */[m
[31m-[m
[31m-package org.lineageos.settings.thermal;[m
[31m-[m
[31m-import android.content.Context;[m
[31m-import android.content.Intent;[m
[31m-import android.content.SharedPreferences;[m
[31m-import android.os.RemoteException;[m
[31m-import android.os.SystemProperties;[m
[31m-import android.os.UserHandle;[m
[31m-import android.view.Display;[m
[31m-import android.view.Surface;[m
[31m-import android.view.WindowManager;[m
[31m-[m
[31m-import androidx.preference.PreferenceManager;[m
[31m-[m
[31m-import org.lineageos.settings.utils.FileUtils;[m
[31m-[m
[31m-public final class ThermalUtils {[m
[31m-[m
[31m-    private static final String THERMAL_CONTROL = "thermal_control";[m
[31m-[m
[31m-    protected static final int STATE_DEFAULT = 0;[m
[31m-    protected static final int STATE_BENCHMARK = 1;[m
[31m-    protected static final int STATE_BROWSER = 2;[m
[31m-    protected static final int STATE_CAMERA = 3;[m
[31m-    protected static final int STATE_DIALER = 4;[m
[31m-    protected static final int STATE_GAMING = 5;[m
[31m-    protected static final int STATE_STREAMING = 6;[m
[31m-[m
[31m-    private static final String THERMAL_STATE_DEFAULT = "0";[m
[31m-    private static final String THERMAL_STATE_BENCHMARK = "10";[m
[31m-    private static final String THERMAL_STATE_BROWSER = "11";[m
[31m-    private static final String THERMAL_STATE_CAMERA = "12";[m
[31m-    private static final String THERMAL_STATE_DIALER = "8";[m
[31m-    private static final String THERMAL_STATE_GAMING = "9";[m
[31m-    private static final String THERMAL_STATE_STREAMING = "14";[m
[31m-[m
[31m-    private static final String THERMAL_BENCHMARK = "thermal.benchmark=";[m
[31m-    private static final String THERMAL_BROWSER = "thermal.browser=";[m
[31m-    private static final String THERMAL_CAMERA = "thermal.camera=";[m
[31m-    private static final String THERMAL_DIALER = "thermal.dialer=";[m
[31m-    private static final String THERMAL_GAMING = "thermal.gaming=";[m
[31m-    private static final String THERMAL_STREAMING = "thermal.streaming=";[m
[31m-[m
[31m-    private static final String THERMAL_SCONFIG = "/sys/class/thermal/thermal_message/sconfig";[m
[31m-[m
[31m-    private Display mDisplay;[m
[31m-    private SharedPreferences mSharedPrefs;[m
[31m-[m
[31m-    protected ThermalUtils(Context context) {[m
[31m-        mSharedPrefs = PreferenceManager.getDefaultSharedPreferences(context);[m
[31m-[m
[31m-        WindowManager mWindowManager = context.getSystemService(WindowManager.class);[m
[31m-        mDisplay = mWindowManager.getDefaultDisplay();[m
[31m-    }[m
[31m-[m
[31m-    public static void startService(Context context) {[m
[31m-        context.startServiceAsUser(new Intent(context, ThermalService.class),[m
[31m-                UserHandle.CURRENT);[m
[31m-    }[m
[31m-[m
[31m-    private void writeValue(String profiles) {[m
[31m-        mSharedPrefs.edit().putString(THERMAL_CONTROL, profiles).apply();[m
[31m-    }[m
[31m-[m
[31m-    private String getValue() {[m
[31m-        String value = mSharedPrefs.getString(THERMAL_CONTROL, null);[m
[31m-[m
[31m-        if (value == null || value.isEmpty()) {[m
[31m-            value = THERMAL_BENCHMARK + ":" + THERMAL_BROWSER + ":" + THERMAL_CAMERA + ":" +[m
[31m-                    THERMAL_DIALER + ":" + THERMAL_GAMING + ":" + THERMAL_STREAMING;[m
[31m-            writeValue(value);[m
[31m-        }[m
[31m-        return value;[m
[31m-    }[m
[31m-[m
[31m-    protected void writePackage(String packageName, int mode) {[m
[31m-        String value = getValue();[m
[31m-        value = value.replace(packageName + ",", "");[m
[31m-        String[] modes = value.split(":");[m
[31m-        String finalString;[m
[31m-[m
[31m-        switch (mode) {[m
[31m-            case STATE_BENCHMARK:[m
[31m-                modes[0] = modes[0] + packageName + ",";[m
[31m-                break;[m
[31m-            case STATE_BROWSER:[m
[31m-                modes[1] = modes[1] + packageName + ",";[m
[31m-                break;[m
[31m-            case STATE_CAMERA:[m
[31m-                modes[2] = modes[2] + packageName + ",";[m
[31m-                break;[m
[31m-            case STATE_DIALER:[m
[31m-                modes[3] = modes[3] + packageName + ",";[m
[31m-                break;[m
[31m-            case STATE_GAMING:[m
[31m-                modes[4] = modes[4] + packageName + ",";[m
[31m-                break;[m
[31m-            case STATE_STREAMING:[m
[31m-                modes[5] = modes[5] + packageName + ",";[m
[31m-                break;[m
[31m-        }[m
[31m-[m
[31m-        finalString = modes[0] + ":" + modes[1] + ":" + modes[2] + ":" + modes[3] + ":" +[m
[31m-                modes[4] + ":" + modes[5];[m
[31m-[m
[31m-        writeValue(finalString);[m
[31m-    }[m
[31m-[m
[31m-    protected int getStateForPackage(String packageName) {[m
[31m-        String value = getValue();[m
[31m-        String[] modes = value.split(":");[m
[31m-        int state = STATE_DEFAULT;[m
[31m-[m
[31m-        if (modes[0].contains(packageName + ",")) {[m
[31m-            state = STATE_BENCHMARK;[m
[31m-        } else if (modes[1].contains(packageName + ",")) {[m
[31m-            state = STATE_BROWSER;[m
[31m-        } else if (modes[2].contains(packageName + ",")) {[m
[31m-            state = STATE_CAMERA;[m
[31m-        } else if (modes[3].contains(packageName + ",")) {[m
[31m-            state = STATE_DIALER;[m
[31m-        } else if (modes[4].contains(packageName + ",")) {[m
[31m-            state = STATE_GAMING;[m
[31m-        } else if (modes[5].contains(packageName + ",")) {[m
[31m-            state = STATE_STREAMING;[m
[31m-        }[m
[31m-[m
[31m-        return state;[m
[31m-    }[m
[31m-[m
[31m-    protected void setDefaultThermalProfile() {[m
[31m-        FileUtils.writeLine(THERMAL_SCONFIG, THERMAL_STATE_DEFAULT);[m
[31m-    }[m
[31m-[m
[31m-    protected void setThermalProfile(String packageName) {[m
[31m-        String value = getValue();[m
[31m-        String modes[];[m
[31m-        String state = THERMAL_STATE_DEFAULT;[m
[31m-[m
[31m-        if (value != null) {[m
[31m-            modes = value.split(":");[m
[31m-[m
[31m-            if (modes[0].contains(packageName + ",")) {[m
[31m-                state = THERMAL_STATE_BENCHMARK;[m
[31m-            } else if (modes[1].contains(packageName + ",")) {[m
[31m-                state = THERMAL_STATE_BROWSER;[m
[31m-            } else if (modes[2].contains(packageName + ",")) {[m
[31m-                state = THERMAL_STATE_CAMERA;[m
[31m-            } else if (modes[3].contains(packageName + ",")) {[m
[31m-                state = THERMAL_STATE_DIALER;[m
[31m-            } else if (modes[4].contains(packageName + ",")) {[m
[31m-                state = THERMAL_STATE_GAMING;[m
[31m-            } else if (modes[5].contains(packageName + ",")) {[m
[31m-                state = THERMAL_STATE_STREAMING;[m
[31m-            }[m
[31m-        }[m
[31m-[m
[31m-        FileUtils.writeLine(THERMAL_SCONFIG, state);[m
[31m-    }[m
[31m-}[m
