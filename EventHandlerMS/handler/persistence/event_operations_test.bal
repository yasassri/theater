package src.persistance;

import ballerina.data.sql;
import ballerina.io;
import ballerina.test;
import src.model as mod;

// These tests cover the following functionality of testerina
// BeforeEach tests, AfterEach tests

@Description {value:"Before and After functions used to setup prerequisites"}
@test:beforeEach {}
function truncateTable () {
    endpoint<sql:ClientConnector> ep {
        create sql:ClientConnector(sql:DB.H2_FILE, h2DbLocation, h2Port, h2Database, h2UserName, h2Password, null);
    }
    io:println("Before Each Function");
    // Truncate the table to make sure data doesn't exist.
    var a = ep.update("TRUNCATE TABLE " + tableName, null);
}

@test:afterEach {}
function truncateTableAfter () {
    // Calling the same before function since We just need to truncate the table
    truncateTable();
}


@Description {value:"Tests adding events to the EVENTS table"}
@Description {value:"This test used a before and a after function to cleanup the DB"}
@test:config {}
public function testAddEventToDB () {
    // Sql connector to check whether the data is present in the database
    endpoint<sql:ClientConnector> testDbEp { create sql:ClientConnector(sql:DB.H2_FILE, h2DbLocation, 0,
                                                                        h2Database, "root", "root", {maximumPoolSize:5});
    }
    mod:Event event = {
                          name:"Ballerina",
                          start_time:"12.55",
                          venue:"WSO2",
                          organizer_name:"tyler"
                      };

    var pl, err = addNewEvent(event);
    test:assertEquals(err, null, "There was a error when adding Event to the DB.");

    // Asserting the DB
    table dt = testDbEp.select("SELECT * FROM " + tableName + " WHERE NAME = 'Ballerina'", null, null);
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
@test:config {}
public function testAddSuplicateEventToDB () {
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