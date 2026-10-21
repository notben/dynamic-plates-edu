import urllib.request
import json

def check_all_runs():
    url = 'https://api.github.com/repos/notben/dynamic-plates-edu/actions/runs'
    req = urllib.request.Request(url, headers={'User-Agent': 'Antigravity-Agent'})
    try:
        with urllib.request.urlopen(req) as resp:
            data = json.loads(resp.read().decode('utf-8'))
    except Exception as e:
        print(f"Error fetching runs: {e}")
        return

    runs = data.get('workflow_runs', [])
    for r in runs:
        print(f"Workflow: {r['name']} | Run ID: {r['id']} | status: {r['status']} | conclusion: {r['conclusion']}")

    # Find the release workflow
    release_runs = [r for r in runs if 'Release' in r['name'] or 'Android' in r['name']]
    if release_runs:
        target = release_runs[0]
        print(f"\n--- Detailed Job info for: {target['name']} (ID {target['id']}) ---")
        jobs_url = target['jobs_url']
        req_jobs = urllib.request.Request(jobs_url, headers={'User-Agent': 'Antigravity-Agent'})
        with urllib.request.urlopen(req_jobs) as jresp:
            jdata = json.loads(jresp.read().decode('utf-8'))
        for job in jdata.get('jobs', []):
            print(f"Job: {job['name']} (status={job['status']}, conclusion={job['conclusion']})")
            for step in job.get('steps', []):
                print(f"  Step: {step['name']} -> conclusion={step['conclusion']}")

if __name__ == '__main__':
    check_all_runs()
