package com.mirego.rebelchat;

import android.app.Application;

import uk.co.chrisjenx.calligraphy.CalligraphyConfig;

public class RebelChatApplication extends Application {

    @Override
    public void onCreate() {
        super.onCreate();

        configureCalligraphy();
    }

    private void configureCalligraphy() {
        CalligraphyConfig.initDefault(new CalligraphyConfig.Builder()
                .setDefaultFontPath(getString(R.string.font_flipbash))
                .setFontAttrId(R.attr.fontPath)
                .build());
    }
}
