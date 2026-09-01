#!/usr/bin/env python
# coding: utf-8
from subprocess import run
import argparse
from tqdm import tqdm
import os
import time
from huggingface_hub import InferenceClient
from requests.exceptions import HTTPError
import httpx
import google.auth
from google.auth.transport.requests import Request
import os

seeds = [189271799411766586,  579729583778658724, 4407744037879285641,
       8021311860947070438, 7557720774441400805, 4124569089816967031,
       8757234180484079538, 1345049685486228594, 3821323336904154111,
       2492352975129872737, 7470132436406929096, 2441731038925894953,
       4719718939765082820, 8622773066609684882, 5030489311749250763,
       8040594987758984676, 5413428285522033193, 3067875930346561440,
       2984698675093870278, 7312774518454251471, 2277718890984811940,
       5818560952446651979, 4362716921474856504, 5205918905315798326,
       6739161535676138184, 6999308173410519729, 7998258729702781711,
       4902617436489687031,  833220238725680088, 5790690189728659936,
       2053095914672488139, 6908243898541882208, 3141413740616159916,
       1557109415258862488, 3429040376117987226, 2524019012724380105,
       8475727415309015897, 5243969345009680332, 3554831383785292309,
       8073312835269666424, 5396437185194471877, 8630472620538856418,
       4986905583812169959, 4524666373596233391, 1878713085119630486,
       9179697465932691424, 7038355713358225074, 1282988543739042880,
       7805585921734427999, 5277365148624939345, 3046559002331902269,
       1732950986321174668, 5091728510739053569, 5262856703557398205,
       7546963898947868094, 2121124248817762446, 2926170119684309687,
       8478488015473792299, 5093115218518812743, 6529762435582119432,
       3634701182571102277, 7740008206496288979, 8859454036187581949,
       9154209028951711326, 1103950959448466208, 2451438145833013011,
       7727508819923929776, 4039259406726410233, 8454460613765363257,
       8291382756423123223, 4633518585290656559, 3372889863031808299,
       8653722466400004360, 2650908761213240683, 6465998643187630932,
        645420903339582592, 8613447637548838856, 9098110638036807472,
       7972093997057189099, 3747204823671749496, 6295121864447487883,
       7704150338456558097, 3025084949728306128,  936617991157407191,
       8139610776457219642, 5767022169194840157, 4947984004171777986,
       6260495815271959811, 6746630437118683007, 3279065170474123962,
        996226117375311478, 7343643630761149597, 5004909336620033961,
       5658360204326053430, 8514161916497184388, 1387915072393767650,
        228737746954593237,  813447976228324755, 7925272924972354676,
       5113457824153284787] 

system_text = """You provide only Verilog code as output without any description.
IMPORTANT: You provide only plain text without Markdown formatting.
IMPORTANT: You do not include markdown formatting such as ```.
If there is a lack of details, you provide the most logical solution.
You are not allowed to ask for more details.
You ignore any potential risk of errors or confusion."""

def get_credentials():
    credentials, project_id = google.auth.default(
        scopes=["https://www.googleapis.com/auth/cloud-platform"]
    )
    credentials.refresh(Request())
    return credentials.token


def build_endpoint_url(
    region: str,
    project_id: str,
    model_name: str,
    model_version: str,
    streaming: bool = False,
):
    base_url = f"https://{region}-aiplatform.googleapis.com/v1/"
    project_fragment = f"projects/{project_id}"
    location_fragment = f"locations/{region}"
    specifier = "streamRawPredict" if streaming else "rawPredict"
    model_fragment = f"publishers/anthropic/models/{model_name}@{model_version}"
    url = f"{base_url}{'/'.join([project_fragment, location_fragment, model_fragment])}:{specifier}"
    return url

project_id = 'ancient-house-437310-g3'
region = 'europe-west1'

model = "claude-3-5-sonnet"
model_version = "20240620"
is_streamed = False # Change to True to stream token responses

def fresh_headers():
    return {
        "Authorization": f"Bearer {get_credentials()}",
        "Accept": "application/json",
    }

url = build_endpoint_url(
    project_id=project_id,
    region=region,
    model_name=model,
    model_version=model_version,
    streaming=is_streamed
)

def get_completion(headers, system_text, prompt, seed, t):
    back_off = 15
    while True:
        try:
            # Define POST payload
            data = {
                "system": system_text,
                "messages": [
                    {
                        "role": "user",
                        "content": prompt + "\nGive the full implementation of this module",
                    }
                ],
                "stream": is_streamed,
                "temperature": t,
                "anthropic_version": "vertex-2023-10-16",
                "max_tokens": 1024,
            }

            with httpx.Client() as client:
                resp = client.post(url, json=data, headers=headers, timeout=None)

            if resp.status_code == 401:
                # bad token - refresh headers
                headers["Authorization"] = fresh_headers()["Authorization"]
            elif resp.status_code == 429:
                # too many requests, timeout
                time.sleep(back_off)
            elif resp.status_code >= 500:
                # server error
                time.sleep(2)
            else:
                return resp.json()['content'][0]['text']
        
        except Exception as e:
            print(e)
            print(type(e))
            print(resp)
            print(resp.status_code)
            print(resp.json())
            raise Exception("halt")

# Define query headers
headers = fresh_headers()
problem_ids = [i for i in range(1, 25)]

for problem_id in problem_ids:
    completions_dir = f"problem{problem_id}/completions_claude/"
    os.makedirs(completions_dir, exist_ok=True)
    for prompt_detail in ['L', 'M', 'H']:
        with open(f"problem{problem_id}/prompt_{prompt_detail}.txt", "r") as prompt_fh:
            prompt = prompt_fh.read()
            
        for t in [0.1, 0.3, 0.5, 0.7, 1.0]:
            for i in tqdm(range(0,100), desc=f"generating completions for problem={problem_id}, prompt detail={prompt_detail}, t={t}", leave=False):
                if not os.path.exists(completions_dir + f"completion_{prompt_detail}_t{t}_{i}.v"):
                    chat_completion = get_completion(headers, system_text, prompt, seeds[i], t)
                    with open(completions_dir + f"completion_{prompt_detail}_t{t}_{i}.v", "w") as f:
                        f.write(chat_completion)

