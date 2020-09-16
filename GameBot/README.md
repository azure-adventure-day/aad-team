# Game Bot
Here's how you build the bot manually. 
Feel free to adjust the code - after all it's your bot!
You can also use the GitHub action in the .github/workflows folder to build and push the bot.    

### Build
```
docker build -t yourContainerRegistry/gamebot .
```

### Run in docker
```
docker run -p 8080:8080 -e PICK_STRATEGY=RANDOM -e PORT=8080 yourContainerRegistry/gamebot
```

### Sample Requests

#### First Request, Turn 1
```
POST http://localhost:8080/pick HTTP/1.1
content-type: application/json

{
    "MatchId": "ac066e38-9904-4eba-8d7f-9a301a838717",
    "Player1Name": "daniel",
    "Player2Name": "bot",
    "Turn": 0,
    "TurnsPlayer1Values": [],
    "TurnsPlayer2Values": [],
    "MatchOutcome": null,
    "WhenUtc": "2020-07-27T14:32:22Z"
}
```

#### Second Request, Turn 2
Make sure you add MatchId from first request until game is over.
```
POST http://localhost:8080/pick HTTP/1.1
content-type: application/json

{
    "MatchId": "ac066e38-9904-4eba-8d7f-9a301a838717",
    "Player1Name": "daniel",
    "Player2Name": "bot",
    "Turn": 1,
    "TurnsPlayer1Values": ["Rock"],
    "TurnsPlayer2Values": ["Paper"],
    "LastRoundOutcome": "OverlordWins",
    "MatchOutcome": null,
    "WhenUtc": "2020-07-27T14:32:22Z"
}
```