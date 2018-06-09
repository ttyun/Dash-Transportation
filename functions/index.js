const functions = require('firebase-functions');
const Stripe = require('stripe');
const Express = require('express');
const stripe = Stripe("pk_test_7OcC0FO293KkuiwKKy1MuAkL");

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions

// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
const app = Express();

// Get Customer Epheremeral Keys
app.post('/eKeys', (req, res) => {
   const stripe_version = req.query.api_version;
   if (!stripe_version) {
      res.status(400).end();
      return;
   }
   // This function assumes that some previous middleware has determined the
   // correct customerId for the session and saved it on the request object.
   stripe.ephemeralKeys.create(
      {customer: req.customerId},
      {stripe_version: stripe_version}
   ).then((key) => {
      res.status(200).json(key);
   }).catch((err) => {
      res.status(500).end();
   });
});