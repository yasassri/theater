package event.handler.utils;

import ballerina.test;
import ballerina.io;

@test:config {}
public function testEmptyMessageGeneration ()  {

    json expectedMsg = { "There was a Error" : "" };
    error err = {message: ""};
    json a = generateJsonFromError(err);
    test:assertEquals(a, expectedMsg, "Generated message is incorrect!");
}


@test:config {}
public function testMessageGeneration ()  {

    json expectedMsg = { "There was a Error" : "Error Occured" };
    error err = {message: "Error Occured"};
    json a = generateJsonFromError(err);
    test:assertEquals(a, expectedMsg, "Generated message is incorrect!");
}