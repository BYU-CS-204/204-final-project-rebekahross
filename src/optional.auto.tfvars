lambda = {
  partOne = {handler = "example.HelloWorldHandler::handleRequest"}
  partTwo = {handler = "example.ParameterHandler::handleRequest"}
}

api_resource = {
  partOne = {pathPart = "First"}
  partTwo = {pathPart = "Second"}
}