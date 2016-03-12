package com.mirego.rebelchat.activities;

import android.app.Activity;
import android.app.ActivityOptions;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.os.Bundle;
import android.support.design.widget.Snackbar;
import android.transition.Explode;
import android.transition.Transition;
import android.transition.TransitionSet;
import android.view.View;
import android.view.animation.AccelerateInterpolator;
import android.view.animation.DecelerateInterpolator;
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

    @Bind(R.id.root)
    View root;

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

        getWindow().setAllowEnterTransitionOverlap(false);
        getWindow().setAllowReturnTransitionOverlap(true);

        getWindow().setExitTransition(createTransition(true));
        getWindow().setEnterTransition(createTransition(false));
        getWindow().setReturnTransition(createTransition(true));
        getWindow().setReenterTransition(createTransition(false));
    }

    private Transition createTransition(boolean goingOut) {
        TransitionSet transitionSet = new TransitionSet();

        Explode explodeTransition = new Explode();
        explodeTransition.setDuration(4000);
        explodeTransition.setInterpolator(goingOut ? new AccelerateInterpolator() : new DecelerateInterpolator());
        explodeTransition.addTarget(R.id.canvas);

        transitionSet.addTransition(explodeTransition);
        transitionSet.setOrdering(TransitionSet.ORDERING_SEQUENTIAL);

        return transitionSet;
    }

    @Override
    public void onBackPressed() {
        onLogoutPressed();
    }

    @OnClick(R.id.btn_logout)
    public void onLogoutPressed() {
        startActivity(HomeActivity.newIntent(this), ActivityOptions.makeSceneTransitionAnimation(this).toBundle());
    }

    @OnClick(R.id.btn_shuffle)
    public void onShufflePressed() {
        setRandomString();
    }

    @OnClick(R.id.btn_snap)
    public void onSnapPressed() {
        takeAndSendScreenshot();
    }

    private void setRandomString() {
        String randomString = RandomString.generate(16);
        messageText.setText(randomString);
    }

    private void takeAndSendScreenshot() {
        showLoadingIndicator(getString(R.string.message_send_progress));

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
                        dismissLoadingIndicator(new Runnable() {
                            @Override
                            public void run() {
                                Snackbar.make(root, R.string.message_send_success, Snackbar.LENGTH_SHORT).show();
                            }
                        });
                    }

                    @Override
                    public void onSendMessageFail() {
                        dismissLoadingIndicator(new Runnable() {
                            @Override
                            public void run() {
                                Snackbar.make(root, R.string.message_send_error, Snackbar.LENGTH_SHORT).show();
                            }
                        });
                    }
                });
            }
        });

        screenshotOperation.start();
    }
}
