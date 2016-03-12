package com.mirego.rebelchat.views;

import android.content.Context;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.animation.Animation;
import android.view.animation.BounceInterpolator;
import android.view.animation.ScaleAnimation;
import android.widget.ImageButton;

public class ToolButton extends ImageButton {

    private static final float SCALE_DOWN = 1.00f;
    private static final float SCALE_UP = 1.15f;

    private static final long DURATION = 300;

    private Animation currentAnimation;

    public ToolButton(Context context)  {
        super(context);
    }

    public ToolButton(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public ToolButton(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        if (event.getAction() == MotionEvent.ACTION_DOWN) {
            addAnimation(true);
        } else if (event.getAction() == MotionEvent.ACTION_CANCEL || event.getAction() == MotionEvent.ACTION_UP) {
            addAnimation(false);
        }

        return super.onTouchEvent(event);
    }

    private void addAnimation(boolean up) {
        float oldScale = up ? SCALE_DOWN : SCALE_UP;
        float newScale = up ? SCALE_UP : SCALE_DOWN;
        ScaleAnimation scaleAnimation = new ScaleAnimation(oldScale, newScale, oldScale, newScale, getWidth() / 2, getHeight() / 2);
        scaleAnimation.setFillAfter(true);
        scaleAnimation.setDuration(DURATION);
        scaleAnimation.setInterpolator(new BounceInterpolator());
        scaleAnimation.setAnimationListener(new ScaleAnimation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) { }

            @Override
            public void onAnimationRepeat(Animation animation) { }

            @Override
            public void onAnimationEnd(Animation animation) {
                currentAnimation = null;
            }
        });

        if (currentAnimation != null) {
            currentAnimation.cancel();
        }

        currentAnimation = scaleAnimation;
        startAnimation(currentAnimation);
    }
}
