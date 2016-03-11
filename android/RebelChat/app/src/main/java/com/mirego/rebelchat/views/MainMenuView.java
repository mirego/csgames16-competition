package com.mirego.rebelchat.views;

import android.content.Context;
import android.widget.LinearLayout;

import com.mirego.rebelchat.R;

import butterknife.ButterKnife;

public class MainMenuView extends LinearLayout {
    public MainMenuView(Context context) {
        super(context);
        init();
    }

    protected void init() {
        inflate(getContext(), getLayoutId(), this);
        ButterKnife.bind(this);
    }

    protected int getLayoutId() {
        return R.layout.main_menu;
    }
}
