// Import the Cloud Functions for Firebase and the Firebase Admin modules here.
// import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'
// admin.initializeApp()

// https://www.youtube.com/watch?v=DglTSNEdl0U&list=PLl-K7zZEsYLkPZHe41m4jfAxUi0JjLgSM&index=7
exports.onCommentChange = functions
    .region('europe-west1')
    .firestore
    .document('/comments/{lookId}')
    .onWrite(async (change, context) => {
        console.log(change.before, change.after, context);
    });