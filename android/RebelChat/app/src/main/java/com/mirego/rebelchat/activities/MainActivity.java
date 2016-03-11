package com.mirego.rebelchat.activities;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

import com.mirego.rebelchat.R;
import com.mirego.rebelchat.controllers.LoginController;
import com.mirego.rebelchat.controllers.LoginControllerImpl;

import butterknife.ButterKnife;
import butterknife.OnClick;

public class MainActivity extends BaseActivity {

    private LoginController loginController;

    public static Intent newIntent(Activity fromActivity){
        Intent intent = new Intent(fromActivity, MainActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK);
        return intent;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        ButterKnife.bind(this);

        loginController = new LoginControllerImpl();
    }

    @OnClick(R.id.btn_login)
    void onLoginClicked() {
        loginController.login(getApplicationContext(), /*etUsername.getText().toString()*/ "user1", new LoginController.LoginCallback() {
            @Override
            public void onLoginSuccess(String userId) {
                startActivity(MessageActivity.newIntent(MainActivity.this, userId));
            }

            @Override
            public void onLoginFail() {
                //Snackbar.make(root, R.string.login_fail, Snackbar.LENGTH_SHORT).show();
                // TODO (HUD)
            }
        });
    }
}
