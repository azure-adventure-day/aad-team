# Infrastructure Setup (READ CAREFULLY)
First you have to create the required Azure resources for your team.<br/>
To make things easy we created a **deploy-team.sh** script for you - it is using [Terraform](https://www.terraform.io/intro/index.html) underneath.

> **Attention: You only need to do the following once as a team - not every team member need to do it!**

Find below instructions how to...
1. provision all needed **Azure services**
2. deploy the **GameBot**
3. deploy and configure the **GameEngine**
4. **Test** it manually
5. Register your **game endpoint**

Sincerely, your *World Game Federation*!

> Hint: The resources created may be edited by the hackteams according to requirements throughout the day. 

## Azure CloudShell vs. GitHub Repository
If you like, you can [import this repository](https://docs.github.com/en/github/importing-your-projects-to-github/importing-a-repository-with-github-importer) into your own GitHub repository and work with it.

> Hint: Please import it and *not* clone/fork it - otherwise others teams can peek at you.

**But** this requires advanced knowledge at all team members regarding GitHub, Azure CLI and kubectl and have already installed these tools locally.

> **Attention: If you are not working already day-to-day with GitHub, Azure CLI and kubectl - please use Azure CloudShell!**

### Azure CloudShell
Azure CloudShell (http://shell.azure.com) enables you to clone this repository directly inside the shell and it gives you benefit that already all tools are preinstalled.

> **Attention: To leverage this way, every team member needs to use the same Azure account!**

## 1. Provision all needed Azure services
1. Open CloudShell on http://shell.azure.com, if required create a storage account (only for cloud shell sessions) in your subscription and open Bash.

2. Clone this repo in CloudShell. This command downloads the git repository to your machine.
```
git clone https://github.com/azure-adventure-day/aad-team.git
```

3. [Infrastructure as Code](https://devblogs.microsoft.com/devops/what-is-infrastructure-as-code/) with Terraform is used for deploying all Azure resources, which is defined in the [./terraform](./terraform) folder.<br/>
Deploy them using the following command.

Make the file executable first. Make sure you run this in the right directory.
```
chmod +x ./deploy-team.sh
```

Pick a name for your team. The name will be reflected in your Azure resources, no other team sees it.<br/>
Avoid special characters and keep it short (6 chars max).
``` 
./deploy-team.sh <team_name> westeurope <subscription_id>
```

> Hint: This will take some minutes - take the time to look into the Terraform scripts, Kubernetes YAML files and provided source code from World Game Federation.

After the script has been executed you will see three resource groups:
* one holding the Terraform state,
* one holding all Azure resources
* and the last one is used by the AKS cluster for all the infrastructure components behind

> **Attention: Please see the Terraform output, it includes the SQL Server password and the SQL connection string**


## 2. Deploy the GameBot
Deploy it using the following command.

Make sure you run this in the right directory.
```
kubectl apply -f gamebot_deployment.yaml
```


## 3. Deploy and configure the GameEngine

1. An instance of Azure SQL and a SQL DB should have been deployed to your RG
2. Adjust the firewall in the Azure Portal for Azure SQL Server so you can work with the DB
3. Also allow other Azure Services to access SQL Server so your cluster can talk to the DB
4. In the Azure Portal open your SQL Database,  go to the Query editor and execute all the scripts in the [./DatabaseScripts](./DatabaseScripts) folder
5. Take a note of the SQL database connection string
6. Switch to the GameEngine folder and modify the `blackbox_gameengine_deployment.yaml` file to reference your connection strings. Make sure you set the DB connection string correctly. You can do this directly in the CloudShell using VIM in the right folder. (vim blackbox_gameengine_deployment.yaml) Or you can choose the fancy way and run ***code .*** to get a more graphical user experience of an editor within CloudShell. (this will open a Visual Studio Code like experience in the browser.)

7. Deploy the game engine using kubectl. 
```
kubectl apply -f blackbox_gameengine_deployment.yaml
```
8. Figure out the public endpoint which can be used to call your game engine. Use the command below and get the public IP of the gameengine service. 
```
kubectl get services --field-selector metadata.name=blackboxgameengine --output=jsonpath={.items..status.loadBalancer.ingress..ip}
```
9. If you found your endpoint, you can call it on `http://<YOUR_ENDPOINT_IP>/Match` in the browser.

**You have to provide this URL in the team portal**, so gambling can start.

> **Attention: Test it first (next paragraph) to ensure everything is fine - otherwise the Smorghs will be very angry!**


## 4. Test it manually
1. Test your GameBot

You can get the IP of your bot by running 
```
kubectl get services --field-selector metadata.name=gamebot --output=jsonpath={.items..status.loadBalancer.ingress..ip}
```

You can test your bot by posting a request to your bot's public IP http://A.B.C.D/pick. The result should look like this: ***{"Move":"snap","Bet":null}***. Here's a sample request for the commandline.

```
GAME_BOT_IP=$(kubectl get services --field-selector metadata.name=gamebot --output=jsonpath={.items..status.loadBalancer.ingress..ip})
curl --location --request POST "http://$GAME_BOT_IP/pick" --header 'Content-Type: application/json' --data-raw '{"Player1Name":"daniel","MatchId":"42"}'
```

2. Test your GameEngine

You can test your engine by posting a request to your engine's public IP.<br/>
The result contains all the info for the current match. Here's a sample request.
```
GAME_ENGINE_IP=$(kubectl get services --field-selector metadata.name=blackboxgameengine --output=jsonpath={.items..status.loadBalancer.ingress..ip})
curl --location --request POST "http://$GAME_ENGINE_IP/Match" --header 'Content-Type: application/json' --data-raw '{"ChallengerId":"daniel","Move": "Rock"}'
```

For subsequent requests, make sure you put the gameid from the response into the request.


## 5. Register your game endpoint

Register your game endpoint in your team portal.

**Attention: As soon as you have registered it customers will start gambling and your performance is being measured. So make sure everything works as expected up front!**


## Optional: Enable monitoring your live applications with Application Insights
Azure Application Insights (AppInsights) was already provisioned with the Terraform scripts above.

To enable it, you need to 
1. get the AppInsights Instrumentation key from the Azure portal
2. provide it via the environment variable ```APPINSIGHTS_INSTRUMENTATIONKEY``` for the GameBot and GameEngine


## Optional: Build and push a new GameBot
You can deploy directly from ghcr.io/azure-adventure-day/azure-adventure-day-coach/gamebot:latest without an additional build.

But if you change the source code, you can build and push the container manually or use a prepared github action (check the [./.github/workflows](./.github/workflows) folder). 

To modify, build and push the bot before deploying it, follow these steps:

1. Build the image you want to use, eg like this.
```
// or use Azure Container Registry (was already deployed above)
az acr build --image gamebot:latest --registry myveryownregistry --file Dockerfile .
```

2. Ensure your AKS has access to the Container Registry. If using your own Azure Container Registry a pull-secret needs to be configured
```
kubectl create secret docker-registry teamregistry --docker-server 'myveryownregistry.azurecr.io' --docker-username 'username' --docker-password 'password' --docker-email 'example@example.com'
```

3. Ensure that gamebot_deployment.yaml uses this pull-secret

4. Change the file gamebot_deployment.yaml to reference your bot image
