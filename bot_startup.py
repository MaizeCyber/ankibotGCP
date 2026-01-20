import requests

print('Please enter the app ID of the discord bot:')
discord_app_id = input()
print('Enter the key for your discord bot:')
discord_key = input()

url = f"https://discord.com/api/v10/applications/{discord_app_id}/commands"
headers = {"Authorization": f"Bot {discord_key}"}

json_data = {
    "name": "add",
    "description": "Add a new card to a deck",
    "options": [
        {"name": "query", "description": "The search query", "type": 3, "required": True},
        {"name": "deckname", "description": "Target deck", "type": 3, "required": True}
    ]
}

r = requests.post(url, headers=headers, json=json_data)
print(r.json())