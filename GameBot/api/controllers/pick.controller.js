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


    const strategyOption = process.env.PICK_STRATEGY || "RANDOM";
    const result = pickFromStrategy(strategyOption);
    
    // implement arcade intelligence here
    // if (Player1Name == "Dud") {
    //    result.text = "rock";
    //    result.bet = 1;
    // }
    
    console.log('Against '+Player1Name+', strategy ' + strategyOption + '  played ' + result.text);
    
    const applicationInsightsIK = process.env.APPINSIGHTS_INSTRUMENTATIONKEY;
    if (applicationInsightsIK) {
        if (appInsights && appInsights.defaultClient)
        {
            var client = appInsights.defaultClient;
            client.commonProperties = {
                strategy: strategyOption
            };
            client.trackEvent({name: "pick", properties: {matchId: matchId, strategy: strategyOption, move: result.text, player: Player1Name, bet: result.bet}});
        }
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
