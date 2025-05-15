import csv
import json
import subprocess

from os import environ as env
from sys import stderr

import influxdb_client

def errprint(*args, **kwargs):
    print(*args, **kwargs, file=stderr)

def run_cmd(cmd: [str]) -> str:
    result = subprocess.run(cmd, capture_output=True)
    err = result.returncode
    if err:
        raise EnvironmentError(f'Command {' '.join(cmd)} failed with error code {retcode}')
    return result.stdout.decode().rstrip()

def get_env(variable: str, description: str) -> str:
    result = env.get(variable)
    if not result:
        raise EnvironmentError(f"Expected {description} to be in {variable}.")
    return result

swift_version = get_env('SWIFT_VERSION', "Swift version")
processor_type = run_cmd(['uname', '-m'])
kernel_name = run_cmd(['uname', '-s'])
kernel_version = run_cmd(['uname', '-r'])

results = None
with open('compiletime-crash-test-results.json') as file:
    results = json.loads(file.read())

if not results:
    raise ValueError('No results found!')

errprint(f"INFO: {results}")

url = get_env('INFLUX_URL', "Influx URL")
token = get_env('INFLUX_UPLOAD_TOKEN', "Influx upload token")
org = get_env('INFLUX_ORG_NAME', "org name")
influx_client = influxdb_client.InfluxDBClient(
    url=url,
    token = token,
    org=org
)

in_ci = 'CI' in env
if not in_ci:
    print("DRY RUN: script not being run in CI. Nothing will be uploaded")

write_api = influx_client.write_api(write_options=influxdb_client.client.write_api.SYNCHRONOUS) if in_ci else None

github_ref = env.get('GITHUB_REF')
commit_sha = env.get('GITHUB_SHA')
bucket_name = env.get('INFLUX_BUCKET_NAME')


for test, result in results.items():
    point = influxdb_client.Point('compiletime-crash-tests')
    point.tag('processorType', processor_type)
    point.tag('kernelVersion', f"{kernel_version}")
    point.tag('kernelName', f"{kernel_name}")
    point.tag('testclass', "crasher")
    point.tag('test', test)
    point.field('status', result)
    point.tag('ref', github_ref)
    point.tag('commit', commit_sha)
    point.tag('swiftVersion', swift_version)
    if not in_ci:
        print(f"DRY RUN: {point}")
        continue
    errprint(f"INFO: storing point {point} in {bucket_name}")
    write_api.write(bucket=bucket_name, record=point)

summary = { "CRASH": 0, "ERROR": 0, "XERROR": 0, "OK": 0 }
for result in results.values():
    summary[result] += 1

point = influxdb_client.Point('compiletime-crash-tests-summary')
point.tag('processorType', processor_type)
point.tag('kernelVersion', f"{kernel_version}")
point.tag('kernelName', f"{kernel_name}")
point.tag('testclass', "crash_tests_summary")
point.tag('ref', github_ref)
point.tag('commit', commit_sha)
point.tag('swiftVersion', swift_version)

for status, count in summary.items():
    point.field(f"{status}_count", count)

if not in_ci:
    print(f"DRY RUN: {point}")
else:
    errprint(f"INFO: storing point {point} in {bucket_name}")
    write_api.write(bucket=bucket_name, record=point)

