package com.mirego.rebelchat.utilities;

public class Easing {

    public static float easeIn(float x) {
        return Math.max(0, Math.min(1, x * x));
    }

    public static float easeOut(float x) {
        return Math.max(0, Math.min(1, 1 - (1 - x) * (1 - x)));
    }

    public static float easeInOut(float x) {
        return Math.max(0, Math.min(1, x < 0.5 ? (2 * x * x) : -1 + (4 - 2 * x) * x));
    }
}
