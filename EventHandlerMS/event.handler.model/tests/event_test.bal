package event.handler.model;

import ballerina/test;

@Description {value: "Test creating and retriving values from a struct"}
@test:Config
public function testEventModel () {

   Event event =  {
    name : "Event Name",
    start_time : "15.25",
    venue : "WSO2",
    organizer_name : "YCR"
    };

   test:assertEquals(event.name, "Event Name", msg = "The name didn't match.");
   test:assertEquals(event.start_time, "15.25", msg = "The time didn't match.");
   test:assertEquals(event.venue, "WSO2", msg = "The venue didn't match.");
   test:assertEquals(event.organizer_name, "YCR", msg = "The time didn't match.");
}
