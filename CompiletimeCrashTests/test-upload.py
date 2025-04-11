import csv
import json
import subprocess

from os import environ as env

import influxdb_client

def run_cmd(cmd: [str]) -> str:
    result = subprocess.run(cmd, capture_output=True)
    err = result.returncode
    if err:
        raise EnvironmentError(f'Command {' '.join(cmd)} failed with error code {retcode}')
    return result.stdout.decode()

def get_env(variable: str, description: str) -> str:
    result = env.get(variable)
    if not result:
        raise EnvironmentError(f"Expected {description} to be in {variable}.")
    return result

swift_version_info = run_cmd(['swift', '--version'])
swift_version = swift_version_info.split("\n")[0]
processor_type = run_cmd(['uname', '-m'])
kernel_name = run_cmd(['uname', '-s'])
kernel_version = run_cmd(['uname', '-r'])

results = None
with open('compiletime-crash-test-results.json') as file:
    results = json.loads(file.read())

if not results:
    raise ValueError('No results found!')

url = get_env('INFLUX_URL', "Influx URL")
token = get_env('INFLUX_UPLOAD_TOKEN', "Influx upload token")
org = get_env('INFLUX_ORG_NAME', "org name")
influx_client = influxdb_client.InfluxDBClient(
    url=url,
    token = token,
    org=org
)
write_api = influx_client.write_api(write_options=influxdb_client.client.write_api.SYNCHRONOUS)

github_ref = env.get('GITHUB_REF')
commit_sha = env.get('GITHUB_SHA')
bucket_name = env.get('INFLUX_BUCKET_NAME')

for test, result in results.items():
    point = influxdb_client.Point('compiletime-crash-tests')
    point.tag('processorType', processor_type)
    point.tag('kernelVersion', f"{kernel_name}-{kernel_version}")
    point.tag('test', test)
    point.field('status', result)
    point.tag('ref', github_ref)
    point.tag('commit', commit_sha)
    point.tag('swiftVersion', swift_version)
    print(point)
    continue
    write_api.write(bucket=bucket_name, record=point)
