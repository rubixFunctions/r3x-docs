## r3x-haskell-showcase
[![License](https://img.shields.io/badge/-Apache%202.0-blue.svg)](https://opensource.org/s/Apache-2.0)

## About
This showcase is bootstrapped using the `stack` tool, which can be downloaded [here](https://docs.haskellstack.org/en/stable/README/)
To build the showcase run:
```
$ stack build
```
To run the showcase locally run the following:
```
$ stack exec r3x-haskell-showcase-exe
$ curl localhost:8080
    {"message":"Hello RubiX!!!"}%
```
Alternatively, you can run the pre build image
```
$ docker run -p 8080:8080 quay.io/rubixfunctions/r3x-haskell-showcase
$ curl localhost:8080
    {"message":"Hello RubiX!!!"}%
```

## Usage
To use the r3x haskell sdk, you must define a handler such as the one shown below, where we define a response to incoming requests. With the handler defined we simply pass the handler to the RubiX `execute` method.
```
-- Define a response handler
rubixHandler :: Handler NW.Response
rubixHandler = do
  let res = toResponse $ Json rubixMessage
  return res

-- Start the server
main :: IO ()
main = execute rubixHandler
```

## Documentation
For full details on how deploy this function to Knative, please refer to our [Documentation here.](https://github.com/rubixFunctions/r3x-docs/blob/master/install/README.md)

## License
This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details