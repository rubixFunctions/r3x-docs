# Welcome to RubiX - Functions as a Container

[![License](https://img.shields.io/badge/-Apache%202.0-blue.svg)](https://opensource.org/s/Apache-2.0)

This work was carried out as a Final Year Project, as part of the Bachelor of Science (Hons) in Applied Computing. The end result of this project will be a Framework which provides a suite of SDK’s and a CLI that will reduce the barrier of entry to serverless development within Knative, by abstracting the boring bits and allowing you to focus on your functions.

## Components
- SDK - Abstracts the configuration away from the user allowing you to focus on the logic behind your function -- [JavaScript](https://github.com/rubixFunctions/r3x-js-sdk), [GoLang](https://github.com/rubixFunctions/r3x-golang-sdk), [Python](https://github.com/rubixFunctions/r3x-python-sdk), [Java](https://github.com/rubixFunctions/r3x-java-sdk)
- [CLI](https://github.com/rubixFunctions/r3x-cli) - A command line tool to bootstrap Functions as a Container.

## SDK


## Sample Apps
Sample apps developed to demonstrate, how to deploy a function to Knative can be found in the [samples](./samples) directory.
- [JavaScript](./samples/r3x-js-showcase) 
- [GoLang](./samples/r3x-golang-showcase)
- [Python](./samples/r3x-python-showcase)


## Getting Started
- [Installing Knative and Deploying a r3x Function](./install/README.md)
- [Using the RubiX CLI](./cli/README.md)