# ankibotGCP
A deployable instance of anki desktop and the anki-helper bot to automatically create anki flashcards via discord slash commands.

## Description

This is an expansion of ryanlin's anki-helper program to automatically create flashcards for anki via ChatGPT requests and Discord commands https://github.com/ryanlin/anki-helper

I wanted to be able to deploy my modified anki-helper application and anki desktop to GCP via terraform code to improve the availability of my application. https://github.com/MaizeCyber/anki-helper/tree/DockerVersion

Due to the lack of a consistent way to programmatically interact with the anki client, the setup for this bot is more involved than I would have liked. However, once setup, ankibot runs with little need for maintenance.

Please note, this bot currently only works for Spanish, Chinese, and Japanese.

## SETUP

### Prerequisites

1. Create a GCP account and claim your $300 in credits: https://docs.cloud.google.com/docs/get-started
2. In GCP, create a project, then note the project ID: https://developers.google.com/workspace/guides/create-project
3. On your local machine, install the Google Cloud CLI: https://docs.cloud.google.com/sdk/docs/install-sdk
4. Login to the Google Cloud CLI with ```gcloud auth login```
5. On your machine, install terraform on your local machine: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
6. Make a discord account: https://discord.com/
7. Install Python 3: https://www.python.org/downloads/

### Discord Setup

1. To create your bot, head to https://discord.com/developers/applications while signed in to your account.
2. Click "New Application" and give it a descriptive name
3. Under "General Information" note your Application ID and the Public Key.
4. Under "Installation", find "Install Link" and change this to None
5. Under "Bot", scroll down to "token", click reset, then note down your bot key.
6. Still under bot, switch off the toggle for "Public Bot"

### Terraform Setup

Next define the following as environment variables in your terminal:
```
export TF_VAR_discord_token=<your token> # The public key you copied earlier
export TF_VAR_discord_app_id=<your app ID> # The App ID you coped earlier
export TF_VAR_project_name=<your project id> # The full project id, i.e. server-123456
export TF_VAR_project_region=<your selected region> # The region of the project. Choose one near you that also supports e2-medium Instances: https://cloud.google.com/about/locations
export TF_VAR_project_zone=<your selected region> # The zone of the project. The format is the region followed by a, b, c, or d, ie us-east4-a. Choose any available zone.
```

Next, you are going to create a bucket in your project to store the terraform state:
```
gcloud config set project $TF_VAR_project_name
gcloud storage buckets create --location $TF_VAR_project_region gs://${TF_VAR_project_name}-tfstate
gcloud storage buckets update gs://${TF_VAR_project_name}-tfstate --versioning
```

Edit line 3 of terraform/provider.tf with the full name of your newly created bucket. 
> bucket  = "testankibot-483804-tfstate"

Finally run these terraform commands in order:
```
cd terraform
```
```
terraform init
```
```
terraform validate
```
```
terraform plan
```
```
terraform apply
```

If you encounter an error during apply similar to "googleapi: Error 403:", just wait a few minutes then run apply again. Sometimes it takes a few minutes for the APIs to enable in the project.

Go to https://console.cloud.google.com/compute/instances where you should see your instance "anki-desktop-1" listed. Click "SSH" and start a session to transfer your SSH keys to the instance.

In your Google Cloud console, enter the following forwarding command.
```
gcloud compute ssh anki-desktop-1 -- -L 3000:localhost:3000
```

In the top right corner, of the Cloud Shell Terminal, click "Web Preview" and preview on Port 3000.

In the new tab, configure anki as normal and log into your Anki account like normal.

In the top menu bar of Anki, click on "Tools" and then Add-ons. 

In the top right, click "Get Add-ons". Enter two numbers to install the two required add-ons:

2055492159 for anki connect

501542723 for anki auto-sync

Click on "AnkiConnect", then click on "Config" in the bottom left corner. Make sure the config looks like this:

```
{
    "apiKey": null,
    "apiLogPath": null,
    "ignoreOriginList": [],
    "webBindAddress": "0.0.0.0",
    "webBindPort": 8765,
    "webCorsOrigin": "http://localhost",
    "webCorsOriginList": ["*"]
}
```

Close anki and restart it by restarting the docker container:

```
docker restart <pid>
```

Go to "tools" in the top menu bar again and click "Auto Sync Options". Set both values to 1 minute.

Close out of the anki tab.

## Use

The easiest way to install is via the install link under "Installation" in the Discord developer portal. Just be sure to set it back to "None" after finishing the installation.

Once the app is installed, you use the bot by typing the slash command "!add" followed by the word or phrase you want to add to your deck, followed by the language/deckname (currently supports Spanish, Mandarin, and Japanese).

## To Do and Improvements

I realize this setup is quite involved. Ideally I would like to programmatically install, login, and add plugins to Anki on the instance. Please reach out if you know of any consistent ways to do this, or have heard of a project that has accomplished this.

If you have suggestions for improving the setup process overall for this project, please let me know.