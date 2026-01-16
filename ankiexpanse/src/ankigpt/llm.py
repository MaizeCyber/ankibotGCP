import os
import json
from pathlib import Path
from gtts import gTTS
import hashlib
import random
import string
from google import genai
from google.genai import types

JSON_INSTRUCTION = "You are a system that only outputs JSON."

def generate(system_prompt: str, user_prompt: str, json_schema: dict) -> str:
    print("Starting generate function...")
    client = genai.Client(
    vertexai=True,
    project=os.getenv("GOOGLE_CLOUD_PROJECT"),
    location=os.getenv("GOOGLE_CLOUD_REGION"))

    response = client.models.generate_content(
        model='gemini-2.5-flash',
        contents=user_prompt,
        config=types.GenerateContentConfig(
            system_instruction=system_prompt,
            response_mime_type='application/json',
            response_schema=json_schema
        )
    )
    print(f"Generated response:{response.text}")
    return response.text

def generate_sound(text: str, deckname: str) -> str:
    unique_filename = add_hash_suffix_to_file_stem("speech.mp3")
    print(f"Generating sound file: {unique_filename}")
    speech_file_path = Path(__file__).parent / unique_filename
    print(f"speech_file_path: {speech_file_path}")
    if deckname == "chinese":
        language = "zh-CN"
    elif deckname == "spanish":
        language = "es"
    elif deckname == "japanese":
        language = "ja"
    response = gTTS(text=text, lang=language)
    response.save(speech_file_path)
    return unique_filename

def generate_json(
        system_prompt: str,
        user_prompt: str,
        json_schema: dict,
        examples: str = "",) -> dict:

    json_prompt = JSON_INSTRUCTION + system_prompt + examples
    generated_json: str = generate(json_prompt, user_prompt, json_schema)
    return json.loads(generated_json)

#randon file name generator for sound file
def add_hash_suffix_to_file_stem(fname: str) -> str:
    # Generate a random 20-byte hash
    hash_value = hashlib.sha1(''.join(random.choices(string.ascii_letters + string.digits, k=20)).encode()).hexdigest()
    max_len = 255 - len(hash_value) - 1  # Adjust for filename max length

    # Separate filename stem and extension
    stem, ext = Path(fname).stem[:max_len], Path(fname).suffix
    return f"{stem}-{hash_value}{ext}"