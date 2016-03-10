package com.mirego.csgames16.activities;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.transition.Slide;
import android.transition.Transition;
import android.transition.TransitionSet;
import android.view.Gravity;
import android.view.View;
import android.view.animation.DecelerateInterpolator;
import android.widget.EditText;

import com.mirego.csgames16.R;
import com.mirego.csgames16.controller.LoginController;
import com.mirego.csgames16.controller.LoginControllerImpl;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class SignUpActivity extends AppCompatActivity {

    private LoginController loginController;

    @Bind(R.id.username)
    EditText etUsername;
    @Bind(R.id.password)
    EditText etPassword;
    @Bind(R.id.email)
    EditText etEmail;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        getWindow().getDecorView().setSystemUiVisibility(
                View.SYSTEM_UI_FLAG_LAYOUT_STABLE |
                        View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
        );
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_signup);
        ButterKnife.bind(this);
        getWindow().setEnterTransition(createTransition(false, false));
        getWindow().setExitTransition(createTransition(false, true));
        getWindow().setReenterTransition(createTransition(true, false));
        getWindow().setReturnTransition(createTransition(false, true));

    }


    private Transition createTransition(boolean reentering, boolean together) {
        TransitionSet transitionSet = new TransitionSet();

        if (reentering) {
            getWindow().setAllowReturnTransitionOverlap(false);
        } else {
            getWindow().setAllowReturnTransitionOverlap(true);
        }

        Slide slideDownTransition = new Slide(Gravity.TOP);
        slideDownTransition.setDuration(500);
        slideDownTransition.addTarget(R.id.toolbar);
        slideDownTransition.setInterpolator(new DecelerateInterpolator());
        transitionSet.addTransition(slideDownTransition);


        Slide slideUpTransition = new Slide(Gravity.BOTTOM);
        slideUpTransition.setDuration(400);
        slideUpTransition.setInterpolator(new DecelerateInterpolator());
        slideUpTransition.excludeTarget(R.id.toolbar, true);
        slideUpTransition.excludeTarget(android.R.id.statusBarBackground, true);
        slideUpTransition.excludeTarget(android.R.id.navigationBarBackground, true);
        slideUpTransition.excludeTarget(R.id.bottom_bar_buttons, true);

        Slide slideUpBar = new Slide(Gravity.BOTTOM);
        slideUpBar.setDuration(400);
        slideUpBar.setInterpolator(new DecelerateInterpolator());
        slideUpBar.addTarget(R.id.bottom_bar_buttons);

        transitionSet.addTransition(slideUpTransition);
        transitionSet.addTransition(slideUpBar);

        if (!together) {
            transitionSet.setOrdering(TransitionSet.ORDERING_SEQUENTIAL);
        }

        return transitionSet;
    }

    @OnClick(R.id.cancel_button)
    void onCancelClicked() {
        onBackPressed();
    }

    @OnClick(R.id.create_button)
    void onCreateClicked() {
        loginController = new LoginControllerImpl();
        loginController.createUser(etUsername.getText().toString(), etPassword.getText().toString(), etEmail.getText().toString(), new LoginController.CreateUserCallback() {
            @Override
            public void onCreateUser() {
                startActivity(MessageActivity.newIntent(SignUpActivity.this, etUsername.getText().toString()));
            }

            @Override
            public void onCreateUserFail() {
                // No validation so nothing happens.
            }
        });

    }
}
