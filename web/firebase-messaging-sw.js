importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyDav4jRvrUvjaMRm93omeuIIRAKnOsKCCY",
  projectId: "messaging-app-25",
  messagingSenderId: "497587890108",
  appId: "1:497587890108:android:acfb5d2393e92cabf4adb9",
  storageBucket: "messaging-app-25.firebasestorage.app"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  // Customize notification here
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/icons/Icon-192.png'
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
