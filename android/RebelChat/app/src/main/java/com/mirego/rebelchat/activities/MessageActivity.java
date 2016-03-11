package com.mirego.rebelchat.activities;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.os.*;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.mirego.rebelchat.R;
import com.mirego.rebelchat.controllers.MessageController;
import com.mirego.rebelchat.controllers.MessageControllerImpl;
import com.mirego.rebelchat.utilities.Encoding;
import com.mirego.rebelchat.utilities.RandomString;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class MessageActivity extends BaseActivity {

    private static String EXTRA_USER_ID = "extra_user_id";

    private MessageController messageController;
    private String currentUserId;

    @Bind(R.id.canvas)
    View canvas;

    @Bind(R.id.message_image)
    ImageView messageImage;

    @Bind(R.id.message_text)
    TextView messageText;

    public static Intent newIntent(Activity fromActivity, String userId) {
        Intent intent = new Intent(fromActivity, MessageActivity.class);
        intent.putExtra(EXTRA_USER_ID, userId);
        return intent;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_message);
        ButterKnife.bind(this);

        messageController = new MessageControllerImpl();
        currentUserId = getIntent().getStringExtra(EXTRA_USER_ID);

        setRandomString();
    }

    @OnClick(R.id.btn_logout)
    void onLogoutClicked() {
        startActivity(MainActivity.newIntent(this));
    }

    @OnClick(R.id.btn_shuffle)
    void onShuffleClicked() {
        setRandomString();
    }

    @OnClick(R.id.btn_snap)
    void onSnapClicked() {
        takeAndSendScreenshot();
    }

    private void setRandomString() {
        String randomString = RandomString.generate(16);
        messageText.setText(randomString);
    }

    private void takeAndSendScreenshot() {
        showLoadingIndicator();

        Thread screenshotOperation = new Thread(new Runnable() {
            @Override
            public void run() {
                android.os.Process.setThreadPriority(android.os.Process.THREAD_PRIORITY_DEFAULT);

                Bitmap screenshot = Bitmap.createBitmap(canvas.getWidth(), canvas.getHeight(), Bitmap.Config.ARGB_8888);
                Canvas c = new Canvas(screenshot);
                canvas.layout(0, 0, canvas.getWidth(), canvas.getHeight());
                canvas.draw(c);
                String base64Image = Encoding.encodeImageToBase64(screenshot);

                String text = messageText.getText().toString();

                messageController.sendMessage(getApplicationContext(), currentUserId, text, base64Image, new MessageController.SendMessageCallback() {
                    @Override
                    public void onSendMessageSuccess() {
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                dismissLoadingIndicator();
                                //Toast.makeText(MessageActivity.this, R.string.message_sent_successfully, Toast.LENGTH_SHORT).show();
                            }
                        });
                    }

                    @Override
                    public void onSendMessageFail() {
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                dismissLoadingIndicator();
                                //Toast.makeText(MessageActivity.this, R.string.send_message_error, Toast.LENGTH_SHORT).show();
                            }
                        });
                    }
                });
            }
        });

        screenshotOperation.start();
    }
}
