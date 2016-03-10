package com.mirego.csgames16.controller;

public interface LoginController {

    interface LoginCallback {
        void onLogin();
        void onLoginFail();
    }

    interface CreateUserCallback {
        void onCreateUser();
        void onCreateUserFail();
    }

    void login(String username, String password, LoginCallback loginCallback);

    void createUser(String username, String password, String email, CreateUserCallback createUserCallback);

}
