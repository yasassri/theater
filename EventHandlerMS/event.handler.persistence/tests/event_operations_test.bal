package event.handler.persistence;

import ballerina.data.sql;
import ballerina.io;
import ballerina.test;

// These tests cover the following functionality of testerina
// BeforeEach tests, AfterEach tests

@Description {value:"Before and After functions used to setup prerequisites"}
@test:beforeEach
function truncateTable () {

    io:println("Before Each Function");
    // Truncate the table to make sure data doesn't exist.
    var a = dbEP -> update("TRUNCATE TABLE " + tableName, null);
}

@test:afterEach
function truncateTableAfter () {
    // Calling the same before function since We just need to truncate the table
    truncateTable();
}


@Description {value:"Tests adding events to the EVENTS table"}
@Description {value:"This test used a before and a after function to cleanup the DB"}
@test:config
public function testAddEventToDB () {

    mod:Event event = {
                          name:"Ballerina",
                          start_time:"12.55",
                          venue:"WSO2",
                          organizer_name:"tyler"
                      };

    var pl, err = addNewEvent(event);
    test:assertEquals(err, null, "There was a error when adding Event to the DB.");

    // Asserting the DB
    table dt = dbEP -> select("SELECT * FROM " + tableName + " WHERE NAME = 'Ballerina'", null, null);
    var jsonResult, err2 = <json>dt;

    test:assertEquals(err2, null, "There was a error when Querying the DB.");
    json result = jsonResult[0];

    // Asserting results
    test:assertNotEquals(result.ID, null, "");
    test:assertEquals(result.NAME.toString(), event.name, "Element didn't match");
    test:assertEquals(result.START_TIME.toString(), event.start_time, "Element didn't match");
    test:assertEquals(result.VENUE.toString(), event.venue, "Element didn't match");
    test:assertEquals(result.ORGANIZER_NAME.toString(), event.organizer_name, "Element didn't match");

    // Assert the json response return from the persist function
    json actualReturn = {"Success":"Ballerina event is Created", "id":result.ID.toString()};
    test:assertEquals(pl, actualReturn, "Response didn't match");
}


@Description {value:"Tests adding duplicate events to the EVENTS table"}
@test:config
public function testAddDuplicateEventToDB () {
    // Sql connector to check whether the data is present in the database
    mod:Event event = {
                          name:"Ballerina",
                          start_time:"12.55",
                          venue:"WSO2",
                          organizer_name:"tyler"
                      };

    var pl, err = addNewEvent(event);
    test:assertEquals(err, null, "There was a error when adding Event to the DB.");
    var pl2, err2 = addNewEvent(event);
    test:assertNotEquals(err2, null, "Error was expected");
}

@Description {value:"Tests adding a invalid events to the EVENTS table"}
@test:config
public function testAddInvalidEventToDB () {
    // Sql connector to check whether the data is present in the database
    mod:Event event = {
                          name:"Ballerina",
                          start_time:"12.55",
                          venue:"WSO2"

                      };
    // Negative test which expects a error
    try {
        var pl, err = addNewEvent(event);
        test:assertFail("No Error occured while adding a invalid entry");
    } catch (error e) {}
}

@Description {value:"Tests adding a invalid events to the EVENTS table"}
@test:config
public function testAddInvalidVenueToDB () {
    // Sql connector to check whether the data is present in the database
    mod:Event event = {
                          name:"Ballerina",
                          start_time:"12.55",
                          venue:"WSO2123456789", // Feild only can have 10 characters
                          organizer_name:"tyler"
                      };
    // Negative test which expects a error
    try {
        var pl, err = addNewEvent(event);
        test:assertFail("No Error occured while adding a invalid entry");
    } catch (error e) {
        io:println(e);
    }
}