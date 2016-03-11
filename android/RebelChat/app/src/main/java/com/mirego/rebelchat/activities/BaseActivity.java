package com.mirego.rebelchat.activities;

import android.app.ProgressDialog;
import android.content.Context;
import android.support.v7.app.AppCompatActivity;

import uk.co.chrisjenx.calligraphy.CalligraphyContextWrapper;

public class BaseActivity extends AppCompatActivity {

    private ProgressDialog progressDialog;

    @Override
    protected void attachBaseContext(Context newBase) {
        super.attachBaseContext(CalligraphyContextWrapper.wrap(newBase));
    }

    public void showLoadingIndicator() {
        progressDialog = ProgressDialog.show(BaseActivity.this, null, null, true);
        progressDialog.setCancelable(false);
    }

    public void dismissLoadingIndicator() {
        if (progressDialog != null) {
            progressDialog.dismiss();
        }
    }
}
