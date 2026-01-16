"""Generates JSON usable with AnkiConnect from natural language queries.

New version for other languages. Tested on Chinese, spanish, and Japanese

Example Usage:
    note_json: dict = ankigpt.generate_note("苹果")

"""

from . import llm
from . import prompts

def generate_note(query: str, deckname: str) -> dict:
    print("Generating note...")
    print(f"Query:{query}")
    print(f"Deck name:{deckname}")
    if deckname == "chinese":
        promptInstruction = prompts.EXAMPLES_HSK
        json_schema = prompts.HSK_SCHEMA
    elif deckname == "spanish":
        promptInstruction = prompts.EXAMPLES_ROMANTIC
        json_schema = prompts.ROMANTIC_SCHEMA
    elif deckname == "japanese":
        promptInstruction = prompts.EXAMPLES_JAPONIC
        json_schema = prompts.JAPONIC_SCHEMA

    system_prompt = "".join(
        [
            prompts.ANKIHELPER_INSTRUCTION,
            prompts.DECKNAME_INSTRUCTION
        ]
    )
    print(system_prompt)
    print("Starting generate...")
    note_json = llm.generate_json(
        system_prompt, 
        query,
        json_schema,
        promptInstruction
    )

    with_speech_note_json = add_audio_to_note_json(note_json, llm.generate_sound(query, deckname))
    print("with_speech_note_json: ", with_speech_note_json)
    return with_speech_note_json

# function to add string of mp3 filename to "Audio" field of note_json in the format     "SentenceAudio": "[sound:audiofile.mp3]"
def add_audio_to_note_json(note_json: dict, audio_filename: str) -> dict:
    note_json["fields"]["Audio"] = f"[sound:{audio_filename}]"
    return note_json