# ankibotGCP
A deployable instance of anki desktop and the anki-helper bot to automatically create anki flashcards via discord slash commands

## Description

This is an expansion of ryanlin's anki-helper program to automatically create flashcards for anki via ChatGPT requests and Discord commands https://github.com/ryanlin/anki-helper

I wanted to be able to deploy my modified anki-helper application and anki desktop to GCP via terraform code to improve the availability of my application. https://github.com/MaizeCyber/anki-helper/tree/DockerVersion

Due to the lack of a consistent way to programmatically interact with the anki client, the setup for this bot is more involved than I would have liked. However, once setup, ankibot runs with little need for maintenance.

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

Edit line 9 of provider.tf with the full name of your newly created bucket. 
> bucket  = "testminecraft-483804-tfstate"

Finally run these terraform commands in order:
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

If you encounter an error during apply similar to "googleapi: Error 403:", just wait a few minutes then run plan and apply again. Sometimes it takes a few minutes for the APIs to enable in the project.

Once apply is complete, terraform will output out three values:
```
cloud_run_url = "https://<sevice_string>.a.run.app"
server_ipv4_address = "<your ipv4 here>"
server_ipv6_address = "<your ipv6 here>"
```
