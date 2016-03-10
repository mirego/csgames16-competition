package com.mirego.csgames16.controller;

public interface MessageController {

    interface CreateMessageCallback {
        void onMessageCreated();
        void onMessageCreateFail();
    }

    void createMessage(String username, String image, CreateMessageCallback createMessageCallback);

}
