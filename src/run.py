#!/usr/bin/python3

import boto3
import botocore
from dotenv import load_dotenv
import os

load_dotenv()

root_path = '../assets'
lang_dir_names = ('en', 'es', 'sound')
BUCKET = 'dialplan-assets'

s3 = boto3.resource('s3')

def files_keys():
    """Yield (path, key) tuples for all files in root_path."""
    # Root has two levels of subdirectories, root/lang/directory/file.
    # Keys are lang/directory/file.
    for lang_dir_name in lang_dir_names:
        lang_dir_path = '/'.join((root_path, lang_dir_name))
        statement_dir_names = os.listdir(lang_dir_path)
        for statement_dir_name in statement_dir_names:
            statement_dir_path = '/'.join(
                (lang_dir_path, statement_dir_name))
            file_names = os.listdir(statement_dir_path)
            for file_name in file_names:
                partial_path = (
                    lang_dir_name + "/" +
                    statement_dir_name + '/' +
                    file_name)
                full_path = (
                    root_path + '/' + partial_path)
                yield (full_path, partial_path)

def obsolete_keys():
    local_keys = list(key for (_file_path, key) in files_keys())
    remote_keys = (obj.key for obj in s3.Bucket(BUCKET).objects.all())
    return (key for key in remote_keys if key not in local_keys)

def upload_files():
    for (file_path, key) in files_keys():
        s3.Bucket(BUCKET).upload_file(
            file_path,
            key,
            ExtraArgs={
                'ContentType': "audio/ulaw",
                'CacheControl': "max-age=28800"})
        print("uploaded", file_path, key)

def delete_obsolete_files():
    client = boto3.client('s3')
    for key in obsolete_keys():
        client.delete_object(Bucket=BUCKET, Key=key)
        print("deleted", key)

if __name__ == '__main__':
    upload_files()
    delete_obsolete_files()
