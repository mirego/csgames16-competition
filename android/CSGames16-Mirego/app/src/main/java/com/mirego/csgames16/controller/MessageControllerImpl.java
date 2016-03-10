package com.mirego.csgames16.controller;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

public class MessageControllerImpl implements MessageController {

    private final String SERVER_URL = "http://192.168.0.38:3000";
    private final String MESSAGES = "/messages";

    private OkHttpClient client = new OkHttpClient();


    @Override
    public void createMessage(String username, String image, final CreateMessageCallback createMessageCallback) {
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.put("username", username);
            jsonObject.put("image", image);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        Request request = new Request.Builder()
                .url(SERVER_URL + MESSAGES)
                .post(RequestBody.create(MediaType.parse("application/json"), jsonObject.toString()))
                .build();

        client.newCall(request).enqueue(new Callback() {
            @Override
            public void onFailure(Call call, IOException e) {
                if(createMessageCallback != null){
                    createMessageCallback.onMessageCreateFail();
                }
            }

            @Override
            public void onResponse(Call call, Response response) throws IOException {
                if(createMessageCallback != null){
                    createMessageCallback.onMessageCreated();
                }
            }
        });
    }
}
