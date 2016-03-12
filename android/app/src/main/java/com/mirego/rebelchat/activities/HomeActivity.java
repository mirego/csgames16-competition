package com.mirego.rebelchat.activities;

import android.app.Activity;
import android.app.ActivityOptions;
import android.content.Intent;
import android.os.Bundle;
import android.transition.Slide;
import android.transition.Transition;
import android.transition.TransitionSet;
import android.view.Gravity;
import android.view.animation.AccelerateInterpolator;
import android.view.animation.DecelerateInterpolator;

import com.mirego.rebelchat.R;

import butterknife.ButterKnife;
import butterknife.OnClick;

public class HomeActivity extends BaseActivity {

    public static Intent newIntent(Activity fromActivity) {
        Intent intent = new Intent(fromActivity, HomeActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK | Intent.FLAG_ACTIVITY_NEW_TASK);
        return intent;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home);
        ButterKnife.bind(this);

        getWindow().setAllowEnterTransitionOverlap(true);
        getWindow().setAllowReturnTransitionOverlap(false);

        getWindow().setExitTransition(createTransition(true));
        getWindow().setEnterTransition(createTransition(false));
        getWindow().setReturnTransition(createTransition(false));
        getWindow().setReenterTransition(createTransition(false));
    }

    private Transition createTransition(boolean goingOut) {
        TransitionSet transitionSet = new TransitionSet();

        Slide infoTransition = new Slide(Gravity.TOP);
        infoTransition.setDuration(500);
        infoTransition.setInterpolator(goingOut ? new AccelerateInterpolator() : new DecelerateInterpolator());
        infoTransition.addTarget(R.id.section_info);

        Slide controlsTransition = new Slide(Gravity.BOTTOM);
        controlsTransition.setDuration(goingOut ? 600 : 400);

        controlsTransition.setInterpolator(goingOut ? new AccelerateInterpolator() : new DecelerateInterpolator());
        controlsTransition.addTarget(R.id.btn_login);
        controlsTransition.addTarget(R.id.btn_register);

        transitionSet.addTransition(infoTransition);
        transitionSet.addTransition(controlsTransition);

        transitionSet.setOrdering(TransitionSet.ORDERING_SEQUENTIAL);

        return transitionSet;
    }

    @OnClick(R.id.btn_login)
    void onLoginPressed() {
        ActivityOptions activityOptions = ActivityOptions.makeSceneTransitionAnimation(this, findViewById(R.id.section_info), "section_info");
        startActivity(LoginActivity.newIntent(this, false), activityOptions.toBundle());
    }

    @OnClick(R.id.btn_register)
    void onRegisterPressed() {
        ActivityOptions activityOptions = ActivityOptions.makeSceneTransitionAnimation(this, findViewById(R.id.section_info), "section_info");
        startActivity(LoginActivity.newIntent(this, true), activityOptions.toBundle());
    }
}
