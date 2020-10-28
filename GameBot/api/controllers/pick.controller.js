const PickStrategyFactory = require('../services/pickStrategyFactory.service');
const appInsights = require("applicationinsights");

const pick = async (req, res) => {
    var Player1Name = req.body.Player1Name;
    var matchId = req.body.MatchId;
    if (Player1Name == undefined || matchId == undefined) {
        res.status(400);
        res.send("Player1NamerId or MatchId undefined");
        return;
    }

    // implement arcade intelligence here
    const strategyOption = process.env.PICK_STRATEGY || "RANDOM";
    const result = pickFromStrategy(strategyOption);
    console.log('Against '+Player1Name+', strategy ' + strategyOption + '  played ' + result.text);
    
    const applicationInsightsIK = process.env.APPLICATION_INSIGHTS_IKEY;
    if (applicationInsightsIK) {
        var client = appInsights.defaultClient;
        client.commonProperties = {
            strategy: strategyOption
        };
        client.trackEvent({name: "pick", properties: {strategy: strategyOption, move: result.text, player: Player1Name, bet: result.bet}});
    }
    res.send({ "Move": result.text, "Bet": result.bet });
};

const pickFromStrategy = (strategyOption) => {
    const strategyFactory = new PickStrategyFactory();

    strategyFactory.setDefaultStrategy(strategyOption);
    const strategy = strategyFactory.getStrategy();
    return strategy.pick();
}

module.exports = {
    pick,
}