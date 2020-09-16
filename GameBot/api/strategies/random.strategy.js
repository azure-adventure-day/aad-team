const os = require("os");
const { RPSLSChoices } = require('../settings/rpslsOptions');

class RandomStrategy {

    pick() {
        const choiceIndex = Math.floor((Math.random() * RPSLSChoices.length - 1) + 1);

        var bet = null;
        if (process.env.FF_BETS) {
            // The bet of Humans that they will win
            // value of 1 means if Humans win, they will get 2x of the score - if they loose they loose 2x of the score
            // If null the Humans player does not support bets, value needs to be between 0 and 1
            bet = Math.random();
        }

        return {
            "player":  os.hostname(),
            "playerType": "node",
            "text": RPSLSChoices[choiceIndex],
            "bet": bet,
            "value": choiceIndex
        };
    }
}

module.exports = RandomStrategy;