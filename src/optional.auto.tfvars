lambda = {
  partOne = {handler = "lambda.AuthorSearchHandler::handleRequest"}
  partTwo = {handler = "lambda.TitleSearchHandler::handleRequest"}
  partThree = {handler = "lambda.TopicSearchHandler::handleRequest"}

}

api_resource = {
  partOne = {pathPart = "First"}
  partTwo = {pathPart = "Second"}
  partThree = {pathPart = "Third"}
}