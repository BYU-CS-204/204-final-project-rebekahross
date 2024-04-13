package example;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;

public class ParameterHandler implements RequestHandler<Request, Response> {

  public Response handleRequest(Request request, Context context) {
    String greetings = "This was created via parameters";
    System.out.println(greetings);
    return new Response(greetings);
  }
}

