import csv
import os
import sys

from os import environ as env
from numbers import Number
from math import modf

import influxdb_client

def percentile_to_tag(percentile: Number) -> str:
    if not (0 <= percentile <= 100):
        raise ValueError(f"Domain error: `percentile` ∈ [0,100], found {percentile}")
    if modf(float(percentile))[0]:
        raise ValueError(f'Expected percentile to not have a fractional part.')
    return f"p{percentile}"

def get_env(variable: str, description: str) -> str:
    result = os.environ.get(variable)
    if not result:
        raise EnvironmentError(f"Expected {description} to be in {variable}.")
    return result


url = get_env('INFLUX_URL')
token = get_env('INFLUX_UPLOAD_TOKEN')
org = get_env('INFLUX_ORG_NAME')
influx_client = influxdb_client.InfluxDBClient(
    url=url,
    token = token,
    org=org
)
write_api = influx_client.write_api(write_options=influxdb_client.client.write_api.SYNCHRONOUS)

github_ref = env.get('GITHUB_REF')
github_ref_name = env.get('GITHUB_REF_NAME')
commit_sha = env.get('GITHUB_SHA')
bucket_name = env.get('INFLUX_BUCKET_NAME')

benchmark_dir = "benchmark-raw-output"
for benchmark in os.listdir(benchmark_dir):
    with open(f"{benchmark_dir}/{benchmark}") as csvfile:
        reader = csv.reader(csvfile)
        meta_header = next(reader)
        name_header = next(reader)
        label_indices = { name:i for i,name in enumerate(name_header) }
        for row in reader:
            point = influxdb_client.Point('benchmark-metrics')
            point.tag('testclass', 'benchmark')
            point.tag('testtarget', row[label_indices['measurement']])
            point.tag('host', row[label_indices['hostName']])
            point.tag('processorType', row[label_indices['processoryType']])
            point.tag('processors', row[label_indices['processors']])
            point.tag('memory', row[label_indices['memory']])
            point.tag('kernelVersion', row[label_indices['kernelVersion']])
            point.tag('metric', row[label_indices['metric']])
            point.tag('unit', row[label_indices['unit']])
            point.tag('test', row[label_indices['test']])
            # https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/store-information-in-variables#default-environment-variables
            point.tag('ref', github_ref)
            point.tag('refName', github_ref_name)
            point.tag('commit', commit_sha)
            point.tag('percentile', percentile_to_tag(float(row[label_indices['percentile']])))
            point.field('metricValue', int(row[label_indices['value']]))
            point.field('timeStamp', row[label_indices['time']])
            write_api.write(bucket=bucket_name, record=point)
