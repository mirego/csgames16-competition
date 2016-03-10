package com.mirego.csgames16.activities;

import android.app.Activity;
import android.app.ActivityOptions;
import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.transition.Explode;
import android.transition.Transition;
import android.transition.TransitionSet;
import android.view.View;
import android.view.animation.AccelerateInterpolator;
import android.view.animation.DecelerateInterpolator;
import android.widget.EditText;

import com.mirego.csgames16.R;
import com.mirego.csgames16.controller.LoginController;
import com.mirego.csgames16.controller.LoginControllerImpl;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class HomeActivity extends AppCompatActivity {

    @Bind(R.id.root)
    View root;

    @Bind(R.id.username)
    EditText etUsername;

    @Bind(R.id.password)
    EditText etPassword;

    private LoginController loginController;

    public static Intent newIntent(Activity fromActivity){
        Intent intent = new Intent(fromActivity, HomeActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK);
        return intent;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home);
        ButterKnife.bind(this);

        getWindow().setExitTransition(createExitTransition(false));
        getWindow().setEnterTransition(createExitTransition(false));
        getWindow().setReturnTransition(createExitTransition(false));
        getWindow().setReenterTransition(createExitTransition(true));
    }


    private Transition createExitTransition(boolean reentering) {
        TransitionSet transition = new TransitionSet();
        Transition explodeTransition = new Explode();
        explodeTransition.setDuration(500);

        if (reentering) {
            explodeTransition.setInterpolator(new DecelerateInterpolator());
            getWindow().setAllowReturnTransitionOverlap(false);
        } else {
            explodeTransition.setInterpolator(new AccelerateInterpolator());
            getWindow().setAllowReturnTransitionOverlap(true);
        }


        explodeTransition.setMatchOrder(Transition.MATCH_ID);
        explodeTransition.addTarget(R.id.card_login_form);
        explodeTransition.addTarget(R.id.iv_logo);

        transition.addTransition(explodeTransition);
        transition.setOrdering(TransitionSet.ORDERING_TOGETHER);

        return transition;
    }

    @OnClick(R.id.btn_login)
    void onLoginClicked(){
        loginController = new LoginControllerImpl();
        loginController.login(etUsername.getText().toString(), etPassword.getText().toString(), new LoginController.LoginCallback() {
            @Override
            public void onLogin() {
                startActivity(MessageActivity.newIntent(HomeActivity.this, etUsername.getText().toString()));
            }

            @Override
            public void onLoginFail() {
                Snackbar.make(root, R.string.login_fail, Snackbar.LENGTH_SHORT).show();
            }
        });
    }

    @OnClick(R.id.btn_sign_up)
    void onSignUpClicked() {
        startActivity(new Intent(this, SignUpActivity.class), ActivityOptions.makeSceneTransitionAnimation(this).toBundle());
    }

}
