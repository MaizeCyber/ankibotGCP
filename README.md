# ankibotGCP
A deployable instance of anki desktop and the anki-helper bot to automatically create anki flashcards via discord.

## Description

This is an expansion of two projects: 

First, ryanlin's anki-helper program to automatically create flashcards for anki via ChatGPT requests and Discord commands https://github.com/ryanlin/anki-helper

Second, pnorcross and mlcivilengineer's containerized anki desktop applications to make ankiconnect automation easier: https://github.com/pnorcross/anki-desktop-docker, https://github.com/mlcivilengineer/anki-desktop-docker/tree/main

I want to be able to deploy my modified anki-helper application and anki desktop to GCP via terraform code to improve the availability of my application. https://github.com/MaizeCyber/anki-helper/tree/DockerVersion

## Requirements

Register Discord App and Bot Token

## Setup - Terraform Desktop (Recommended)

Work in progress...

## To do

Increase timeout to catch instance going from suspended to active without timeout (added possible new code)
Use alerts based on last ankibot execution to keep instance alive for longer (lots of threshold values)