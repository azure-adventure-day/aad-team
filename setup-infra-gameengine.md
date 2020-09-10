

# Setup of Game Infrastructure on Azure

First create requried resources (AKS clusters, AppInsights, KeyVaults etc) on Azure for your team. These resources will be edited by the hackteams.
It also creates a storage account for TF state, found in RG state<teamname><location>.
1. Open Cloudshell on shell.azure.com, if required create a storage account in your subscription and open Bash


4. You'll find resource definitions as code (infrastructure as code) in a bunch of *.tf files in the terrafrom folder. Deploy them using the following command but replace <teamname> with your actual team's name.
```
./deploy-team.sh <teamname> . westeurope subscriptionid
```

After the script has been executed you will see two resource groups for every team, one holding TF storage, the other one holding e.g. the AKS cluster etc.


## Setup of Gameengine in Kubernetes

1. An instance of Azure SQL DB should be deployed to your RG already. Change the password to be able to access it, find the connection string and adjust the firewall so you can work with the DB.
2. Create tables "matchresults" and "turns" based on provided scripts.
3. Redis should be deployed into your RG already. Get the connection string.
4. Modify the blackbox_gameengine_deployment.yaml file to reference your connection strings.
4. You can deploy directly from Cloud Shell. Run the following command to get the credentials for your cluster.
```
az aks-get credentials -n clustername -g resourcegroupname
```
5. Deploy the game engine using kubectl.
```
kubectl apply -f https://github.com/RicardoNiepel/azure-game-day/blob/master/RPSLSGameHub/GameEngine/blackbox_gameengine_deployment.yaml
```
6. Figure out the public endpoint which can be used to call your game engine.
```
kubectl get services
```
7. If you found your endpoint, give this information to the workshop admins, so that they can start gambling.


## Deploy your gamebot
The code for the gamebot can be found in this repo. You can edit the code in any way you want if you want. 

1. Build the image you want to use, eg like this.
```
docker build -t yourContainerRegistry/Gamebot .
```
2. Change the file gamebot_deployment.yaml to reference your bot image.
Then publish your bot image:
```
docker push yourContainerRegistry/Gamebot
```

3. Deploy your bot.
```
kubectl deploy -f gamebot_deployment.yaml
```

6. Test your Bot
You can test your bot by posting something like this to your bot's public IP http://A.B.C.D/pick
```
{
    "Player1Name":"daniel",
    "MatchId":"42"    
}
```

7. You can test your engine by posting something like this to your engine's public IP.
```
{
    "ChallengerId": "daniel",    
    "Move": "Paper"
}
```
For subsequent requests, make sure you put the gameid from the response into the request.
