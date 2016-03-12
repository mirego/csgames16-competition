package com.mirego.rebelchat.activities;

import android.app.Activity;
import android.app.ActivityOptions;
import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.Snackbar;
import android.support.design.widget.TextInputLayout;
import android.transition.Slide;
import android.transition.Transition;
import android.transition.TransitionSet;
import android.view.Gravity;
import android.view.View;
import android.view.animation.AccelerateInterpolator;
import android.view.animation.DecelerateInterpolator;
import android.widget.EditText;
import android.widget.TextView;

import com.mirego.rebelchat.R;
import com.mirego.rebelchat.controllers.LoginController;
import com.mirego.rebelchat.controllers.LoginControllerImpl;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class LoginActivity extends BaseActivity {

    private static String EXTRA_REGISTER = "EXTRA_REGISTER";

    @Bind(R.id.root)
    View root;

    @Bind(R.id.et_username)
    EditText textUsername;

    @Bind(R.id.et_password)
    EditText textPassword;

    @Bind(R.id.et_email)
    EditText textEmail;

    @Bind(R.id.ti_email)
    TextInputLayout textInputEmail;

    @Bind(R.id.btn_submit)
    TextView submitButton;

    private LoginController loginController;

    private boolean isRegister;

    public static Intent newIntent(Activity fromActivity, Boolean register) {
        Intent intent = new Intent(fromActivity, LoginActivity.class);
        intent.putExtra(EXTRA_REGISTER, register);
        return intent;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        ButterKnife.bind(this);

        loginController = new LoginControllerImpl();

        isRegister = getIntent().getBooleanExtra(EXTRA_REGISTER, true);

        if (isRegister) {
            textInputEmail.setVisibility(View.VISIBLE);
            submitButton.setText(getString(R.string.btn_do_register_title));
        } else {
            textInputEmail.setVisibility(View.GONE);
            submitButton.setText(getString(R.string.btn_do_login_title));
        }

        getWindow().setAllowEnterTransitionOverlap(false);
        getWindow().setAllowReturnTransitionOverlap(false);

        getWindow().setEnterTransition(createTransition(false, false));
        getWindow().setExitTransition(createTransition(true, true));
        getWindow().setReenterTransition(createTransition(false, false));
        getWindow().setReturnTransition(createTransition(true, true));
    }

    private Transition createTransition(boolean goingOut, boolean together) {
        TransitionSet transitionSet = new TransitionSet();

        Slide infoTransition = new Slide(Gravity.TOP);
        infoTransition.setDuration(500);
        infoTransition.setInterpolator(goingOut ? new AccelerateInterpolator() : new DecelerateInterpolator());
        infoTransition.addTarget(R.id.section_info);

        Slide controlsTransition = new Slide(Gravity.BOTTOM);
        controlsTransition.setDuration(400);
        controlsTransition.setInterpolator(goingOut ? new AccelerateInterpolator() : new DecelerateInterpolator());
        controlsTransition.addTarget(R.id.section_controls);

        transitionSet.addTransition(infoTransition);
        transitionSet.addTransition(controlsTransition);

        if (!together) {
            transitionSet.setOrdering(TransitionSet.ORDERING_SEQUENTIAL);
        }

        return transitionSet;
    }

    @OnClick(R.id.btn_back)
    public void onBackPressed() {
        finishAfterTransition();
    }

    @OnClick(R.id.btn_submit)
    void onSubmitPressed() {
        if (isRegister) {
            onRegisterPressed();
        } else {
            onLoginPressed();
        }
    }

    public void onLoginPressed() {
        showLoadingIndicator(getString(R.string.message_login_progress));
        final LoginActivity self = this;

        loginController.login(getApplicationContext(), textUsername.getText().toString(), new LoginController.LoginCallback() {
            @Override
            public void onLoginSuccess(final String userId) {
                dismissLoadingIndicator(new Runnable() {
                    @Override
                    public void run() {
                        startActivity(MessageActivity.newIntent(self, userId), ActivityOptions.makeSceneTransitionAnimation(self).toBundle());
                    }
                });
            }

            @Override
            public void onLoginFail() {
                dismissLoadingIndicator(new Runnable() {
                    @Override
                    public void run() {
                        Snackbar.make(root, R.string.message_login_error, Snackbar.LENGTH_SHORT).show();
                    }
                });
            }
        });
    }

    public void onRegisterPressed() {
        showLoadingIndicator(getString(R.string.message_register_progress));
        final LoginActivity self = this;

        loginController.register(getApplicationContext(), textUsername.getText().toString(), textEmail.getText().toString(), new LoginController.RegisterCallback() {
            @Override
            public void onRegisterSuccess(final String userId) {
                dismissLoadingIndicator(new Runnable() {
                    @Override
                    public void run() {
                        startActivity(MessageActivity.newIntent(self, userId), ActivityOptions.makeSceneTransitionAnimation(self).toBundle());
                    }
                });
            }

            @Override
            public void onRegisterFail() {
                dismissLoadingIndicator(new Runnable() {
                    @Override
                    public void run() {
                        Snackbar.make(root, R.string.message_register_error, Snackbar.LENGTH_SHORT).show();
                    }
                });
            }
        });
    }
}
