package com.mirego.rebelchat.controllers;

import android.content.Context;

import com.mirego.rebelchat.R;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.HttpUrl;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

public class MessageControllerImpl implements MessageController {

    private final String MESSAGES = "messages";

    private final String PARAMETER_USER_ID = "userId";
    private final String PARAMETER_TEXT = "text";
    private final String PARAMETER_IMAGE = "image";

    private OkHttpClient client = new OkHttpClient();

    @Override
    public void sendMessage(Context context, String userId, String text, String image, final SendMessageCallback sendMessageCallback) {
        HttpUrl url = new HttpUrl.Builder()
                .scheme("http")
                .host(context.getString(R.string.service_host))
                .port(context.getResources().getInteger(R.integer.service_port))
                .addPathSegment(MESSAGES)
                .build();

        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.put(PARAMETER_USER_ID, userId);
            jsonObject.put(PARAMETER_TEXT, text);
            jsonObject.put(PARAMETER_IMAGE, image);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        Request request = new Request.Builder()
                .url(url)
                .post(RequestBody.create(MediaType.parse("application/json"), jsonObject.toString()))
                .build();

        client.newCall(request).enqueue(new Callback() {
            @Override
            public void onResponse(Call call, Response response) throws IOException {
                if (sendMessageCallback != null) {
                    sendMessageCallback.onSendMessageSuccess();
                }
            }

            @Override
            public void onFailure(Call call, IOException e) {
                if (sendMessageCallback != null) {
                    sendMessageCallback.onSendMessageFail();
                }
            }
        });
    }
}
