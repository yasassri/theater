package event.handler.model;

import ballerina.test;

@Description {value: "Test creating and retriving values from a struct"}
@test:config {}
public function testEventModel () {

   Event event =  {
    name : "Event Name",
    start_time : "15.25",
    venue : "WSO2",
    organizer_name : "YCR"
    };

   test:assertEquals(event.name, "Event Name", "The name didn't match.");
   test:assertEquals(event.start_time, "15.25", "The time didn't match.");
   test:assertEquals(event.venue, "WSO2", "The venue didn't match.");
   test:assertEquals(event.organizer_name, "YCR", "The time didn't match.");
}
