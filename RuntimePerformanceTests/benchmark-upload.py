import influxdb_client
import csv
import os
import sys

def eprint(*args, **kwargs):
    """
    https://stackoverflow.com/a/14981125/13389627
    """
    print(*args, file=sys.stderr, **kwargs)

def einfo(message):
    eprint(f"INFO: {message}")

"""
    influx-url:
      description: >
        URL for the influxDB instance that benchmark data should be uploaded to
      type: string
      default: "influx.services.passivelogic.com"
"""
influx_url = "influx.services.passivelogic.com"  # default URL from https://gitlab.com/PassiveLogic/ci/-/blob/main/templates/swift-benchmarks.yml?ref_type=heads#L39
bucket_name = "oss_differentiable_benchmarks_trash"
dry_run = False

token = os.environ.get('INFLUX_BENCHMARK_TOKEN')
einfo(token)
error_count = 0
influx_client = influxdb_client.InfluxDBClient(
    url=influx_url,
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
            # {'measurement': 0, 'hostName': 1, 'processoryType': 2, 'processors': 3, 'memory': 4, 'kernelVersion': 5, 'metric': 6, 'unit': 7, 'test': 8, 'value': 9, 'test_average': 10, 'iterations': 11, 'warmup_iterations': 12, 'time': 13}
            point = influxdb_client.Point('benchmark-metrics')
            # what all do we need?
            # measurement, ISA (processorType), core_count (processors), memory, kernelVersion, metric, unit, benchmark_name (test), percentile, value, iterations, warmup_iterations, timestamp (time)
            # basically everything other than host name I reckon
            # What else would we like
            # Commit info is also nice as the Cloud guys have already gotten covered.
            # there's the issue of percentiles as well. My understanding is that they're filtering for relevant percentiles at the Grafana UI itself using Flux or whatever query language.
            point = influxdb_client.Point('performancebenchmark')
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
            try:
                write_api.write(bucket=bucket_name, record=point)
            except Exception as err: 
                eprint(f"ERROR: {err=}")
                error_count += 1

eprint(f"ERROR COUNT: {error_count}")
