# ankibotGCP
A deployable instance of anki desktop and the anki-helper bot to automatically create anki flashcards via discord.

## Description

This is an expansion of ryanlin's anki-helper program to automatically create flashcards for anki via ChatGPT requests and Discord commands https://github.com/ryanlin/anki-helper

I wanted to be able to deploy my modified anki-helper application and anki desktop to GCP via terraform code to improve the availability of my application. https://github.com/MaizeCyber/anki-helper/tree/DockerVersion

## SETUP

### Prerequisites

1. Create a GCP account and claim your $300 in credits: https://docs.cloud.google.com/docs/get-started
2. In GCP, create a project, then note the project ID: https://developers.google.com/workspace/guides/create-project
3. On your local machine, install the Google Cloud CLI: https://docs.cloud.google.com/sdk/docs/install-sdk
4. Login to the Google Cloud CLI with ```gcloud auth login```
5. On your machine, install terraform on your local machine: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

### Discord Setup



### Terraform Setup

First, define the following as environment variables in your terminal:
```
export TF_VAR_discord_bot_token: ${{ secrets.DISCORD_TOKEN }}
export TF_VAR_discord_app_id: ${{ secrets.APP_ID }}
export TF_VAR_project_name=<your project id> # The full project id, i.e. server-123456
export TF_VAR_project_region=<your selected region> # The region of the project. Choose one near you that also supports e2-medium Instances: https://cloud.google.com/about/locations
export TF_VAR_project_zone=<your selected region> # The zone of the project. The format is the region followed by a, b, c, or d, ie us-east4-a. Choose any available zone.
```
