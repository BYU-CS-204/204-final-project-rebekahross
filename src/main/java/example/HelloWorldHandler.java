package example;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;

public class HelloWorldHandler implements RequestHandler<Request, Response> {

  public Response handleRequest(Request request, Context context) {
    String greetings = "Rebekah’s first Terraform project";;
    System.out.println(greetings);
    return new Response(greetings);
  }
}

