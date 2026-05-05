"""Variables shared between modules.

Secret keys should be set as environment variables.
"""

import os

DISCORD_TOKEN = os.getenv("DISCORD_TOKEN")
DISCORD_APP_ID = os.getenv("DISCORD_APP_ID")

default_deckname = "anki-helper"
default_modelname = "HSK"

ankiconnect_url = "http://localhost:8765"

# ankiconnect_url = "http://host.docker.internal:8765"