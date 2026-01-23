"""Variables shared between modules.

Secret keys should be set as environment variables.
"""

import os

DISCORD_PUBLIC_KEY = os.getenv("DISCORD_PUBLIC_KEY")
DISCORD_APP_ID = os.getenv("DISCORD_APP_ID")

default_deckname = "anki-helper"
default_modelname = "HSK"
"""
Comment this out if you do not use Docker.
ankiconnect_url = "http://localhost:8765"
"""
ankiconnect_url = "http://host.docker.internal:8765"