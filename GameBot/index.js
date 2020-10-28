const express = require('express');
const cors = require('cors');
const appInsights = require("applicationinsights");
const bodyParser = require("body-parser");
const routes = require('./api/routes/index.route');
const OS = require('os');

require('dotenv').config();

// Start application insights
const applicationInsightsIK = process.env.APPINSIGHTS_INSTRUMENTATIONKEY;
if (applicationInsightsIK) {
  appInsights.setup(applicationInsightsIK)
  .setDistributedTracingMode(appInsights.DistributedTracingModes.AI_AND_W3C)
  .setSendLiveMetrics(true);
  appInsights.defaultClient.context.tags[appInsights.defaultClient.context.keys.cloudRole] = "arcadebackend";
  appInsights.defaultClient.context.tags[appInsights.defaultClient.context.keys.cloudRoleInstance] = OS.hostname();
  appInsights.start();
}

const app = express();
app.use(bodyParser.urlencoded({
  extended: true
}));
app.use(bodyParser.json());

// Application-Level Middleware
app.use(cors());

// Routes
app.use(routes);

// Start
console.log(`Found process.env.PORT set as ${process.env.PORT}`);
console.log(`Found process.env.PICK_STRATEGY set as ${process.env.PICK_STRATEGY}`);
app.listen(process.env.PORT, () =>
  console.log(`App listening on port ${process.env.PORT}!
Configured pick strategy with '${process.env.PICK_STRATEGY}'`)
);