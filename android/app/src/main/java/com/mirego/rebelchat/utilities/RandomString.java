package com.mirego.rebelchat.utilities;

import java.util.Random;

public class RandomString {
    private static final char[] symbols = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".toCharArray();
    private static final Random random = new Random();

    public static String generate(int length) {
        char[] buffer = new char[length];

        for (int index = 0; index < buffer.length; ++index)
            buffer[index] = symbols[random.nextInt(symbols.length)];

        return new String(buffer);
    }
}
