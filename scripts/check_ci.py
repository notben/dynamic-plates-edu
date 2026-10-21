import subprocess
import urllib.request
import json
import os

def get_token():
    # 1. Check environment variable
    if os.environ.get('GITHUB_TOKEN'):
        return os.environ['GITHUB_TOKEN']
    # 2. Query Git Credential Manager
    try:
        proc = subprocess.Popen(
            [r'C:\Program Files\Git\mingw64\bin\git-credential-manager.exe', 'get'],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        out, _ = proc.communicate(input="protocol=https\nhost=github.com\n", timeout=5)
        for line in out.splitlines():
            if line.startswith('password='):
                return line.split('=', 1)[1].strip()
    except Exception:
        pass
    return None

def get_latest_run():
    token = get_token()
    headers = {'User-Agent': 'Antigravity-Agent'}
    if token:
        headers['Authorization'] = f'Bearer {token}'

    url = 'https://api.github.com/repos/notben/dynamic-plates-edu/actions/runs'
    req = urllib.request.Request(url, headers=headers)
    try:
        with urllib.request.urlopen(req) as resp:
            data = json.loads(resp.read().decode('utf-8'))
        runs = data.get('workflow_runs', [])
        release_runs = [r for r in runs if 'Release' in r['name'] or 'Android' in r['name']]
        if not release_runs:
            return None, []
        target = release_runs[0]
        jobs_url = target['jobs_url']
        req_jobs = urllib.request.Request(jobs_url, headers=headers)
        with urllib.request.urlopen(req_jobs) as jresp:
            jdata = json.loads(jresp.read().decode('utf-8'))
        jobs = jdata.get('jobs', [])
        return target, jobs
    except Exception as e:
        print(f"Error checking run: {e}")
        return None, []

def print_status():
    target, jobs = get_latest_run()
    if not target:
        print("No run found.")
        return None
    print(f"Workflow: {target['name']} | Run ID: {target['id']} | status: {target['status']} | conclusion: {target['conclusion']}")
    for job in jobs:
        print(f"  Job: {job['name']} ({job['status']}, {job['conclusion']})")
        for step in job.get('steps', []):
            if step['conclusion'] or step['status'] == 'in_progress':
                print(f"    Step: {step['name']} -> status={step['status']}, conclusion={step['conclusion']}")
    return target

if __name__ == '__main__':
    print_status()
