# ankibotGCP
A deployable instance of anki desktop and the anki-helper bot to automatically create anki flashcards via discord.

## Description

This is an expansion of two projects: 

First, ryanlin's anki-helper program to automatically create flashcards for anki via ChatGPT requests and Discord commands https://github.com/ryanlin/anki-helper

Second, pnorcross and mlcivilengineer's containerized anki desktop applications to make ankiconnect automation easier: https://github.com/pnorcross/anki-desktop-docker, https://github.com/mlcivilengineer/anki-desktop-docker/tree/main

I want to be able to deploy my modified anki-helper application and anki desktop to GCP via terraform code to improve the availability of my application. https://github.com/MaizeCyber/anki-helper/tree/DockerVersion

## Requirements

Register OpenAI API Account and Key

Register Discord App and Bot Token

## Setup - Terraform Desktop (Recommended)

Work in progress...

## To do

Change from prefix "!add" to slash commands to trigger webhook interaction
```
@tree.command(name="add", description="Add two numbers")
async def add(interaction: discord.Interaction, a: int, b: int):
    await interaction.response.send_message(f"Result: {a + b}")
```
> Once your code is updated to handle HTTP POST requests 
> Go to the Discord Developer Portal. 
> Select your App -> General Information. 
> Find Interactions Endpoint URL. 
> Paste your Cloud Run service URL here.

Suspend VM when requests have not been received for period