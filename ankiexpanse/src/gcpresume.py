from __future__ import annotations

import json
import os
import proto
import sys
import time

import threading

from google.cloud import compute_v1

from flask import request
from flask import Flask

project_id = os.environ['GOOGLE_CLOUD_PROJECT']
zone = os.environ['GOOGLE_CLOUD_ZONE']
instance_name = os.environ['INSTANCE_NAME']
server_address = None

def get_instance(project_id: str = project_id, zone: str = zone, instance_name: str = instance_name) -> None:
    """
    Starts a stopped Google Compute Engine instance (with unencrypted disks).
    Args:
        project_id: project ID or project number of the Cloud project your instance belongs to.
        zone: name of the zone your instance belongs to.
        instance_name: name of the instance your want to start.
    """
    instance_client = compute_v1.InstancesClient()
    try:

        operation = instance_client.get(
            project=project_id, zone=zone, instance=instance_name
        )
        print("Client get request sent")

    except Exception as e:
        print(f"Error getting instance state: {str(e)}", file=sys.stderr)
        return {'status': 'UNKNOWN'}

    status_dict = json.loads(proto.Message.to_json(operation))
    return (status_dict)

def send_instance_start():
    instance_client = compute_v1.InstancesClient()
    try:
        instance_client.start(project=project_id, zone=zone, instance=instance_name)
        print("Instance start sent")
    except Exception as e:
        print(f"Could not send instance start: {str(e)}", file=sys.stderr)
    return None

def send_instance_resume():
    instance_client = compute_v1.InstancesClient()
    try:
        instance_client.resume(project=project_id, zone=zone, instance=instance_name)
        print("Instance resume sent")
    except Exception as e:
        print(f"Could not send instance resume: {str(e)}", file=sys.stderr)
    return 0

def start_instance():
    """
    Starts a stopped Google Compute Engine instance (with unencrypted disks).
    """

    try:
        status = get_instance()
        if status.get('status') == "TERMINATED":
            try:
                thread = threading.Thread(target=send_instance_start)
                thread.start()
                print("Server successfully started")
                return "Server Starting!"
            except Exception as e:
                print(f"Could not start server: {str(e)}", file=sys.stderr)
                return "Error: Server could not be started"
        elif status.get('status') == "SUSPENDED":
            try:
                thread = threading.Thread(target=send_instance_resume)
                thread.start()
                print("Server successfully resumed")
                return "Server Resuming!"
            except Exception as e:
                print(f"Could not start server: {str(e)}", file=sys.stderr)
                return "Error: Server could not be started"
        else:
            return f"Current server status: {status.get('status')}"
    except Exception as e:
        print(f"Could not determine server state: {str(e)}", file=sys.stderr)
        return "Error: Server status could not be found"

def suspend_instance() -> None:
    instance_client = compute_v1.InstancesClient()
    time.sleep(60)
    try:
        instance_client.suspend(project=project_id, zone=zone, instance=instance_name)
        print("Instance suspend sent")
    except Exception as e:
        print(f"Could not suspend instance start: {str(e)}", file=sys.stderr)
    return None