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
7. Now, open your command line and execute the bot_startup.py script with
```
python3 bot_startup.py
```
When prompted, enter the App ID of your discord bot that you copied earlier, then enter your bot token (not your public key).
This step ensures your bot will know how to handle the "add" command.

### Terraform Setup

Next define the following as environment variables in your terminal:
```
export TF_VAR_discord_public_key=<your public key> # The public key you copied earlier
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

Once apply is complete, terraform will output a URL, please note this down:
```
cloud_run_url = "https://<sevice_string>.a.run.app"
```

Back in the Discord Developer website, go to "General Information", scroll down to the "Interactions Endpoint URL", and paste in the link output from Terraform. Hit save.

Next, go to 
https://remotedesktop.google.com/headless

Click Begin > Next > Authorize and copy the command under Debian Linux

Go to https://console.cloud.google.com/compute/instances where you should see your instance "anki-desktop-1" listed. Click "SSH" and paste the command copied for Debian Linux and press enter. You will need to create a pin, feel free to keep it simple, you will only need to remember it for the next step.

Under https://remotedesktop.google.com/access, remote into the instance with the pin you created.

Open anki by searching for it in the bottom left corner. Open it up and log into your Anki account like normal.

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
    "webCorsOriginList": [
        "http://localhost"
    ]
}
```

Close anki and restart it. Go to "tools" in the top menu bar again and click "Auto Sync Options". Set both values to 1 minute.

Close out of Chrome Remote Desktop.

## Use

To install the bot on a discord channel, go to the OAuth2 section in the Discord developer website. Under OAuth2 URL Generator tick the box next to "Bot". Under "Bot Permissions" tick "Manage Webhooks", "Send Messages", "Create public threads", "Create private threads", "Send Messages in Threads", "Send TTS Messages", "Manage Messages", "Manage Threads", "Attach Files", "Use Slash Commands".

Copy the Generated URL, paste it in your browser, and add it to the channel of your choice.

Once the app is installed, you use the bot by typing the slash command "/add" followed by the word or phrase you want to add to your deck, followed by the language/deckname (currently supports Spanish, Mandarin, and Japanese).

## To Do and Improvements

I realize this setup is quite involved. Ideally I would like to programmatically install, login, and add plugins to Anki on the instance. Please reach out if you know of any consistent ways to do this, or have heard of a project that has accomplished this.

If you have suggestions for improving the setup process overall for this project, please let me know.