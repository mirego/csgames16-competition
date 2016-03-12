package com.mirego.rebelchat.activities;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.pm.ActivityInfo;
import android.os.Bundle;
import android.os.Handler;
import android.support.v7.app.AppCompatActivity;

import uk.co.chrisjenx.calligraphy.CalligraphyContextWrapper;

public class BaseActivity extends AppCompatActivity {

    private static final long MINIMUM_DURATION = 1000;

    private ProgressDialog progressDialog;
    private Long progressShowTime;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Lock landscape orientation
        setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
    }

    @Override
    protected void attachBaseContext(Context newBase) {
        // Add support for custom fonts
        super.attachBaseContext(CalligraphyContextWrapper.wrap(newBase));
    }

    public void showLoadingIndicator(final String message) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                progressDialog = ProgressDialog.show(BaseActivity.this, null, message, true);
                progressShowTime = System.currentTimeMillis();
            }
        });
    }

    public void dismissLoadingIndicator(final Runnable onCompletion) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                long delay = (progressShowTime != null ? Math.max(0, MINIMUM_DURATION - (System.currentTimeMillis() - progressShowTime)) : 0);
                final Handler handler = new Handler();
                handler.postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        if (progressDialog != null) {
                            progressDialog.dismiss();
                        }
                        if (onCompletion != null) {
                            onCompletion.run();
                        }
                    }
                }, delay);
            }
        });
    }
}
