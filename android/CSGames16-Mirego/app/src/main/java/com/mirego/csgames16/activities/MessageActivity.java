package com.mirego.csgames16.activities;

import android.app.Activity;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.os.Bundle;
import android.os.Message;
import android.support.v7.app.AppCompatActivity;
import android.util.Base64;
import android.view.View;
import android.widget.ImageButton;
import android.widget.Toast;

import com.mirego.csgames16.R;
import com.mirego.csgames16.controller.MessageController;
import com.mirego.csgames16.controller.MessageControllerImpl;

import java.io.ByteArrayOutputStream;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class MessageActivity extends AppCompatActivity {

    private static String EXTRA_USERNAME = "extra_username";

    private MessageController messageController;

    @Bind(R.id.image_root)
    View imageRoot;

    @Bind(R.id.flash)
    View flash;

    @Bind(R.id.btn_logout)
    ImageButton btnLogout;

    @Bind(R.id.btn_send)
    ImageButton btnSend;

    private Bitmap screenshot;

    private String loggedInUser;

    public static Intent newIntent(Activity fromActivity, String username) {
        Intent intent = new Intent(fromActivity, MessageActivity.class);
        intent.putExtra(EXTRA_USERNAME, username);
        return intent;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_message);
        ButterKnife.bind(this);
        loggedInUser = getIntent().getStringExtra(EXTRA_USERNAME);

    }

    @OnClick(R.id.btn_logout)
    void onLogoutClicked(){
        startActivity(HomeActivity.newIntent(this));
    }

    @OnClick(R.id.btn_send)
    void takeScreenShot() {
        messageController = new MessageControllerImpl();

        fadeOutButtons(new Runnable() {
            @Override
            public void run() {
                screenshot = Bitmap.createBitmap(imageRoot.getWidth(), imageRoot.getHeight(), Bitmap.Config.ARGB_8888);
                Canvas c = new Canvas(screenshot);
                imageRoot.layout(0, 0, imageRoot.getWidth(), imageRoot.getHeight());
                imageRoot.draw(c);
                animateFlash();
            }
        });
    }

    private void fadeOutButtons(Runnable endAction) {
        btnLogout.animate().alpha(0f);
        btnSend.animate().alpha(0f).withEndAction(endAction);
    }

    private void fadeInButtonsAndSendImage() {
        btnLogout.animate().alpha(1f);
        btnSend.animate().alpha(1f);

        messageController.createMessage(loggedInUser, encodeTobase64(screenshot), new MessageController.CreateMessageCallback() {
            @Override
            public void onMessageCreated() {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        Toast.makeText(MessageActivity.this, R.string.message_sent_successfully, Toast.LENGTH_SHORT).show();
                    }
                });

            }

            @Override
            public void onMessageCreateFail() {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        Toast.makeText(MessageActivity.this, R.string.send_message_error, Toast.LENGTH_SHORT).show();
                    }
                });
            }
        });
    }

    private void animateFlash() {
        flash.setAlpha(0f);
        flash.setVisibility(View.VISIBLE);
        flash.animate().alpha(1f).withEndAction(new Runnable() {
            @Override
            public void run() {
                flash.animate().alpha(0f).withEndAction(new Runnable() {
                    @Override
                    public void run() {
                        fadeInButtonsAndSendImage();
                    }
                });
            }
        });
    }

    public static String encodeTobase64(Bitmap image) {
        Bitmap immagex = image;
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        immagex.compress(Bitmap.CompressFormat.PNG, 100, baos);
        byte[] b = baos.toByteArray();
        String imageEncoded = Base64.encodeToString(b, Base64.DEFAULT);

        return imageEncoded;
    }
}
