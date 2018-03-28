package event.handler.persistence;

import ballerina/data.sql;
import ballerina/io;
import ballerina/test;

// These tests cover the following functionality of testerina
// BeforeEach tests, AfterEach tests

@Description {value:"BeforeEach function used to setup prerequisites, here we are clearing the DB table"}
@test:BeforeEach
function truncateTable () {

    io:println("Before Each Function");
    // Truncate the table to make sure data doesn't exist.
    var a =? dbEP -> update("TRUNCATE TABLE " + tableName, null);
}

@test:AfterEach
function truncateTableAfter () {
    // Calling the same before function since We just need to truncate the table
    truncateTable();
}


@Description {value:"Tests adding events to the EVENTS table"}
@Description {value:"This test used a before and a after function to cleanup the DB"}
@test:Config
public function testAddEventToDB () {

    mod:Event event = {
                          name:"Ballerina",
                          start_time:"12.55",
                          venue:"WSO2",
                          organizer_name:"tyler"
                      };

    var pl = addNewEvent(event);
    match pl {
        json j => {
            io:println("No Error occured");
            test:assertTrue(j.Success.toString() == "Ballerina event is Created");
        }
        error err => {
            test:assertFail(msg = "Error occured while adding a Event");
        }
    }

    // Asserting the DB Entry
    table dt =? dbEP -> select("SELECT * FROM " + tableName + " WHERE NAME = 'Ballerina'", null, null);
    var jsonResult =? <json>dt;

    //test:assertEquals(err2, null, msg = "There was a error when Querying the DB.");
    json result = jsonResult[0];

    // Asserting results
    test:assertNotEquals(result.ID, null);
    test:assertEquals(result.NAME.toString(), event.name, msg = "Element didn't match");
    test:assertEquals(result.START_TIME.toString(), event.start_time, msg = "Element didn't match");
    test:assertEquals(result.VENUE.toString(), event.venue, msg = "Element didn't match");
    test:assertEquals(result.ORGANIZER_NAME.toString(), event.organizer_name, msg = "Element didn't match");

    // Assert the json response return from the persist function
    json actualReturn = {"Success":"Ballerina event is Created", "id":result.ID.toString()};
    test:assertEquals(pl, actualReturn, msg = "Response didn't match");
}


@Description {value:"Tests adding duplicate events to the EVENTS table"}
@test:Config
public function testAddDuplicateEventToDB () {
    // Sql connector to check whether the data is present in the database
    mod:Event event = {
                          name:"Ballerina",
                          start_time:"12.55",
                          venue:"WSO2",
                          organizer_name:"tyler"
                      };

    var pl = addNewEvent(event);
    match pl {
    error err => {
        test:assertFail(msg = "Error occured while adding a new event");
    }
    json j => {
        io:println(j);
    }
}

    var pl2 = addNewEvent(event);
    match pl2 {
        error err => {
            io:println(err.message);
            // Asserting the error message
            test:assertEquals(err.message , "Event Already Exists");
        }
        json j => {
            io:println(j);
            test:assertFail(msg = "Error Didn't occur when adding a duplicate event.");
        }
    }
}

@Description {value:"Tests adding a invalid events to the EVENTS table"}
@test:Config
public function testAddInvalidEventToDB () {
    // Sql connector to check whether the data is present in the database
    mod:Event event = {
                          name:"Ballerina",
                          start_time:"12.55",
                          venue:"WSO2"

                      };
    // Negative test which expects a error
    try {
        var pl =? addNewEvent(event);
        test:assertFail(msg = "No Error occured while adding a invalid entry");
    } catch (error e) {}
}

@Description {value:"Tests adding a invalid events to the EVENTS table"}
@test:Config
public function testAddInvalidVenueToDB () {

    mod:Event event = {
                          name:"Ballerina",
                          start_time:"12.55",
                          venue:"WSO2123456789", // Fail only can have 10 characters
                          organizer_name:"tyler"
                      };
    // Negative test which expects a error
    try {
        var pl =? addNewEvent(event); // This line will throw an error and it wil be caught
        test:assertFail(msg = "No Error occured while adding a invalid entry");
    } catch (error e) {
        io:println(e);
    }
}
