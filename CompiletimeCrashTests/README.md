# Compiletime Crash Tests pipeline

## Running the pipeline
In order to run the pipeline simply run the run-compiletime-crash-tests.sh script from this folder.

If you run into issues on macOS make sure that your SDKROOT variable is set. You can do this by running the following in terminal: export SDKROOT=$(xcrun --sdk macosx --show-sdk-path)

We still have to identify what range of SDK's we'll try to support or if we only stick to the newest release. So far this was tested by using the macOS 15.2 SDK provided by the Xcode 16.2 beta.
