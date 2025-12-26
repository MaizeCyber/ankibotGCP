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

## Specs

Two GCP Cloud Run containers, one for anki desktop, one for anki-helper

These containers must communicate over the same VPC network

Ankidesktop must be available over port 3000 internally to login and install the ankiconnect installation

Ankidesktop must be able to communicate with the Discord API

## To do

Verify anki desktop container functionality

Verify anki help container functionality

Configure VPC Network

Configure external access to protect port 3000 access

Configure firewall to allow connection with Discord

Setup CI/CD via github actions

