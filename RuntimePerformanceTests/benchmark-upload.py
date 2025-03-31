import influxdb_client
import csv
import os
import sys

import requests 

import csv
import os
import influxdb_client

def eprint(*args, **kwargs):
    """
    https://stackoverflow.com/a/14981125/13389627
    """
    print(*args, file=sys.stderr, **kwargs)

def einfo(message):
    eprint(f"INFO: {message}")

bucket_name = "oss_differentiable_benchmarks_trash"
dry_run = False
token = os.environ.get('INFLUX_BENCHMARK_TOKEN')
if not token:
    raise EnvironmentError("Expected influx token to be in INFLUX_BENCHMARK_TOKEN")

einfo(token)
error_count = 0
influx_client = influxdb_client.InfluxDBClient(
    url="https://influx.services.passivelogic.com",
    token = token,
    org='PassiveLogic'
)
write_api = influx_client.write_api(write_options=influxdb_client.client.write_api.SYNCHRONOUS)
benchmark_dir = "benchmark-influx"
for benchmark in os.listdir(benchmark_dir):
    with open(f"{benchmark_dir}/{benchmark}") as csvfile:
        reader = csv.reader(csvfile)
        meta_header = next(reader)
        name_header = next(reader)
        label_indices = { name:i for i,name in enumerate(name_header) }
        einfo(label_indices)
        for row in reader:
            point = influxdb_client.Point('benchmark-metrics')
            point.tag('testtarget', row[label_indices['measurement']])
            point.tag('host', row[label_indices['hostName']])
            point.tag('processorType', row[label_indices['processoryType']])
            point.tag('processors', row[label_indices['processors']])
            point.tag('memory', row[label_indices['memory']])
            point.tag('kernelVersion', row[label_indices['kernelVersion']])
            point.tag('metric', row[label_indices['metric']])
            point.tag('unit', row[label_indices['unit']])
            point.tag('test', row[label_indices['test']])
            point.field('percentile', float(row[label_indices['percentile']]))
            point.field('metricValue', int(row[label_indices['value']]))
            point.field('timeStamp', row[label_indices['time']])
            # eprint(point)
            if dry_run:
                continue
            write_api.write(bucket=bucket_name, record=point)

eprint(f"ERROR COUNT: {error_count}")

