const express = require('express');
const pickController = require('../controllers/pick.controller');

const router = express.Router();

const app = express();





router.route('/')
    .post(pickController.pick);

module.exports = router;