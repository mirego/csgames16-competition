# CS Games 2016 - Mobile - Android App

This project serves as a starting base for the CS Games 2016 Mobile Competition.

You may edit it as much as you like (or start completely from scratch if you prefer) – as long as you make something awesome!

## Prerequisites

Make sure you have the following software installed before beginning:

- Latest version of Android Studio (1.5.1)
- Recent version of the Android SDK (at least API 21)

You can download these from the [Android Developer website](http://developer.android.com/sdk/index.html).

> **NOTE:** If you have a Mac computer running OS X 10.10 or later, you may also be interested in our [Android app](https://github.com/mirego/csgames16-competition/tree/master/ios), which uses Xcode and the latest iOS SDK.

## Getting started

First, make sure you have cloned the project from Github:

```
git clone http://github.com/mirego/csgames16-competition.git
```

Then, in Android Studio: 

- Select **Import project (Eclipse, ADT, Gradle, etc.)** in the Welcome Screen, go find the `android` folder in the repository you just cloned, and click **OK**.
- Once the project is open, click on **Sync Project with Gradle Files** in the main toolbar (or navigate to `Tools -> Android` in the application menu and select the same option).

<p align="center"><img src="https://cloud.githubusercontent.com/assets/4378424/13450169/9f925920-e000-11e5-999a-464b9949ee9a.png" width="199"></p>

Once you see a `BUILD SUCCESSFUL` notice in the Gradle Console, your environment should be ready to build and run the project.

### Web server

For the app to communicate with the local web server, you must set your local IP address in the project configuration file.

In `res/vales/config.xml`:

- Change the value of `service_host` to the IP address of your computer on the local network (you cannot set `localhost` or `127.0.0.1` because it will use the loopback of the Android device).

## Building the project

The project should have already been configured as an Android project in Android Studio, therefore you should see a target named `app` in the main toolbar, with **Play** and **Debug** buttons on its right.

Press on the **Debug** icon, and if you don't already have one, [create a new Android Virtual Device](http://developer.android.com/tools/devices/managing-avds.html), then select it to run the project.

Once the app appears running in your Virtual Device, your environment is ready for the competition.

## How it works

**Rebel Chat** is a small application that imitates the popular messaging application [Snapchat](https://www.snapchat.com/). It is very basic however, as it can only send random message strings and a fixed image.

It should be fairly straightforward to use and customize, but if you want to know more about it, you can read on.

> **NOTE:** Before you begin, make sure the web server is up and running (see the [server page](https://github.com/mirego/csgames16-competition/tree/master/server)).

### Activities

The app contains three main activities:

- `HomeActivity`: The **home screen**, with *login* and *registration* buttons
- `LoginActivity`: The **login screen**, with is used for both *sign up* and *sign in*
- `MessageActivity`: The **messaging screen**, with random text strings and a fixed image

You will customize mostly the latter, where you can add real messaging functionalities. You are free to change the project structure and add as many activities as you want, but keep in mind that 3 hours go very fast.

### Dependencies

As you will see from the `build.gradle`, this project uses a couple of public libraries:

- **[Butterknife](http://jakewharton.github.io/butterknife/)**: View injection library, for easier usage of views inside activities
- **[Calligraphy](https://github.com/chrisjenx/Calligraphy)**: Small utility to load custom fonts easily, for the _Rebellion_ style of the app
- **[OkHttp](https://github.com/square/okhttp)**: Simple HTTP client for Android, to easily send requests to the web server

These make up the project as it is, but you may add or remove dependencies as much as you like.

### Controllers

The app contains two data sources:

- `LoginController`: For user login and registration
- `MessageController`: For messages sent through the app

They offer very basic support for two routes available in the [server](https://github.com/mirego/csgames16-competition/tree/master/server). The data is not validated, except for the user login, where only existing users are authorized.

### Next steps

So, what's the room for improvement?

Here are some features you could add to this app:

- Customization of the text message (various fonts, colors or layouts)
- Customization of the background image (from the library or from other apps)
- Drawing tools (various brushes sizes or colors)
- Message encryption
- Real-time chat messaging
- Video messaging (simple camera stream, video effects)

The list is non-exhaustive, feel free to do anything you can think of!

## License

This competition is © 2016 [Mirego](http://www.mirego.com) and may be freely
distributed under the [New BSD license](http://opensource.org/licenses/BSD-3-Clause).
See the [`LICENSE.md`](https://github.com/mirego/csgames16-competition/blob/master/LICENSE.md) file.

## About Mirego

[Mirego](http://mirego.com) is a team of passionate people who believe that work is a place where you can innovate and have fun. We're a team of [talented people](http://life.mirego.com) who imagine and build beautiful Web and mobile applications. We come together to share ideas and [change the world](http://mirego.org).

We also [love open-source software](http://open.mirego.com) and we try to give back to the community as much as we can.
