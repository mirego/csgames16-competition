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

public class LoginControllerImpl implements LoginController {
    private final String SERVER_URL = "http://192.168.0.38:3000";
    private final String USERS = "/users";
    private final String LOGIN_METHOD = USERS + "?name=";

    private OkHttpClient client = new OkHttpClient();




    @Override
    public void login(String username, String password, final LoginCallback loginCallback) {
        Request request = new Request.Builder()
                .url(SERVER_URL + LOGIN_METHOD + username)
                .build();


        client.newCall(request).enqueue(new Callback() {
            @Override
            public void onFailure(Call call, IOException e) {
                if (loginCallback != null) {
                    loginCallback.onLoginFail();
                }
            }

            @Override
            public void onResponse(Call call, Response response) throws IOException {
                if (loginCallback != null) {
                    loginCallback.onLogin();
                }
            }
        });

    }

    @Override
    public void createUser(String username, String password, String email, final CreateUserCallback createUserCallback) {
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.put("name", username);
            jsonObject.put("email", email);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        Request request = new Request.Builder()
                .url(SERVER_URL + USERS)
                .post(RequestBody.create(MediaType.parse("application/json"), jsonObject.toString()))
                .build();

        client.newCall(request).enqueue(new Callback() {
            @Override
            public void onFailure(Call call, IOException e) {
                if(createUserCallback != null){
                    createUserCallback.onCreateUserFail();
                }
            }

            @Override
            public void onResponse(Call call, Response response) throws IOException {
                if(createUserCallback != null){
                    createUserCallback.onCreateUser();
                }
            }
        });

    }
}
