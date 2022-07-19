importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyCCE6wIOVTZIhKAeURxzzc2mU_4Fe_HQZ8",
  authDomain: "college-gate-dbd50.firebaseapp.com",
  databaseURL: "https://college-gate-dbd50-default-rtdb.asia-southeast1.firebasedatabase.app",
  projectId: "college-gate-dbd50",
  storageBucket: "college-gate-dbd50.appspot.com",
  messagingSenderId: "329096238857",
  appId: "1:329096238857:web:1856793734feb78f56a5d8",
  measurementId: "G-CRF29L1XJ2"
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});