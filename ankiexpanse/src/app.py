"""Discord app for AnkiHelper

1. LLM Interaction
    Prompt + Parsing response into JSON 
2. Sending JSON object to Anki Connect
    Figure out how to do a shared deck

Usage (with `anki-helper` as active directory):
    python3 src/app.py
"""

import json
import os
import threading
import requests
from flask import Flask, jsonify, request
from nacl.signing import VerifyKey
from nacl.exceptions import BadSignatureError

from ankiexpanse.src.gcpresume import start_instance, suspend_instance
from ankiexpanse.src import config
from ankiexpanse.src import create

app = Flask(__name__)

PUBLIC_KEY = config.DISCORD_PUBLIC_KEY
APP_ID = config.DISCORD_APP_ID  # You'll need your Application ID now


def verify_signature(request):
    signature = request.headers.get('X-Signature-Ed25519')
    timestamp = request.headers.get('X-Signature-Timestamp')
    body = request.data.decode("utf-8")
    if not signature or not timestamp:
        return False
    verify_key = VerifyKey(bytes.fromhex(PUBLIC_KEY))
    try:
        verify_key.verify(f'{timestamp}{body}'.encode(), bytes.fromhex(signature))
        return True
    except BadSignatureError:
        return False


def background_task(interaction_token, query, deckname):
    """This function runs in the background to handle the heavy lifting."""
    # The URL to edit the 'Thinking...' message
    url = f"https://discord.com/api/v10/webhooks/{APP_ID}/{interaction_token}/messages/@original"

    try:
        # Your original logic
        note_json, note_id = create.generate_and_add_card(query, deckname)

        confirmation = f"Done! Added **{note_json['fields']['Key']}** to deck **{note_json['deckName']}**."
        formatted_json = json.dumps(note_json, indent=2, ensure_ascii=False)
        content = f"{confirmation}\n```json\n{formatted_json}```"

        thread_suspend = threading.Thread(
            target=suspend_instance
        )
        thread_suspend.start()

    except Exception as e:
        content = f"Uh oh, something went wrong: `{str(e)}`"

    # Send the follow-up message to Discord
    requests.patch(url, json={"content": content})


@app.route('/interactions', methods=['POST'])
def interactions():
    if not verify_signature(request):
        return "Unauthorized", 401

    data = request.json

    if data.get("type") == 1:
        return jsonify({"type": 1})

    if data.get("type") == 2:
        command_name = data['data']['name']
        interaction_token = data['token']

        if command_name == "add":
            options = {opt['name']: opt['value'] for opt in data['data'].get('options', [])}
            query = options.get('query')
            deckname = options.get('deckname')

            # Start the instance if its paused or stopped
            thread_start_instance = threading.Thread(
                target=start_instance,
            )
            thread_start_instance.start()

            # 1. Start the background thread
            thread = threading.Thread(
                target=background_task,
                args=(interaction_token, query, deckname)
            )
            thread.start()

            # Type 5 = DEFERRED_CHANNEL_MESSAGE_WITH_SOURCE
            return jsonify({
                "type": 5
            })

    return jsonify({"type": 4, "data": {"content": "Unknown command"}})


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8080))
    app.run(host='0.0.0.0', port=port)