package com.mirego.rebelchat.views;

import android.app.Activity;
import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.RadialGradient;
import android.graphics.Shader;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.widget.Button;

import com.mirego.rebelchat.utilities.Easing;

import java.util.Timer;
import java.util.TimerTask;

public class SnapButton extends Button {

    private static final long ANIMATION_DURATION = 1500;
    private static final long REFRESH_RATE_MS = 10;

    private static final float BORDER_WIDTH = 2;
    private static final float OUTLINE_WIDTH = 10;

    private Paint paint = new Paint();

    private Timer timer;
    private Long startTime;
    private Long stopTime;
    private Long lastValue;

    public SnapButton(Context context) {
        super(context);
    }

    public SnapButton(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public SnapButton(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        if (event.getAction() == MotionEvent.ACTION_DOWN && timer == null) {
            startTime = System.currentTimeMillis();
            timer = new Timer();
            timer.scheduleAtFixedRate(new TimerTask() {
                @Override
                public void run() {
                    askRelayout();
                }
            }, 0, REFRESH_RATE_MS);
        } else if (event.getAction() == MotionEvent.ACTION_CANCEL || event.getAction() == MotionEvent.ACTION_UP) {
            stopTime = System.currentTimeMillis();
        }

        return super.onTouchEvent(event);
    }

    @Override
    public void onDraw(Canvas canvas) {
        float centerX = getWidth() / 2;
        float centerY = getHeight() / 2;
        float radius = (getWidth() - getPaddingLeft() - getPaddingRight()) / 2;

        setBackgroundColor(0x00000000);
        paint.setFlags(Paint.ANTI_ALIAS_FLAG);

        // Check the timer state (forward or backwards animation)
        long duration = 0;
        if (stopTime != null) {
            duration = (long) (lastValue - (System.currentTimeMillis() - stopTime) * (lastValue / ((float) ANIMATION_DURATION / 10)));
            if (duration <= 0) {
                cancelTimer();
            }
        } else if (startTime != null) {
            duration = System.currentTimeMillis() - startTime;
            lastValue = duration;
        } else if (timer != null) {
            cancelTimer();
        }

        // Calculate the gradient
        float progress = Math.min(Math.max(0, duration), ANIMATION_DURATION) / (float) ANIMATION_DURATION;
        float alphaProgress = Easing.easeOut(progress);
        float tintProgress = Easing.easeInOut((float) (Math.max(0, progress - 0.33) * 1.5));

        int innerColor = Color.HSVToColor((int) (255 * (0.5 - 0.5 * alphaProgress)), new float[]{0.0f, 0.65f * tintProgress, 1.0f});
        int outerColor = Color.HSVToColor((int) (255 * (0.5 + 0.15 * alphaProgress)), new float[]{0.0f, 0.65f * tintProgress, 1.0f});
        RadialGradient gradient = new RadialGradient(centerX, centerY, radius * 0.85f, innerColor, outerColor, Shader.TileMode.CLAMP);

        // Draw the gradient
        paint.setColor(0xFF000000);
        paint.setStrokeWidth(0);
        paint.setStyle(Paint.Style.FILL);
        paint.setShader(gradient);
        canvas.drawCircle(centerX, centerY, radius - OUTLINE_WIDTH, paint);

        // Draw the black border
        paint.setColor(0xFF000000);
        paint.setStrokeWidth(BORDER_WIDTH);
        paint.setStyle(Paint.Style.STROKE);
        paint.setShader(null);
        canvas.drawCircle(centerX, centerY, radius - BORDER_WIDTH / 2, paint);

        // Draw the white outline
        paint.setColor(0xFFFFFFFF);
        paint.setStrokeWidth(OUTLINE_WIDTH);
        paint.setStyle(Paint.Style.STROKE);
        paint.setShader(null);
        canvas.drawCircle(centerX, centerY, radius - (BORDER_WIDTH + OUTLINE_WIDTH) / 2, paint);
    }

    private void cancelTimer() {
        startTime = null;
        stopTime = null;
        if (timer != null) {
            timer.cancel();
        }
        timer = null;
        askRelayout();
    }

    private void askRelayout() {
        if (getContext() instanceof Activity) {
            Activity activity = (Activity) getContext();
            activity.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    invalidate();
                }
            });
        }
    }
}
