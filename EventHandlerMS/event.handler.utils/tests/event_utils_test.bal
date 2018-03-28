package event.handler.utils;

import ballerina/test;
import ballerina/io;

@test:Config
public function testEmptyMessageGeneration ()  {

    json expectedMsg = { "There was a Error" : "" };
    error err = {message: ""};
    json a = generateJsonFromError(err);
    test:assertEquals(a, expectedMsg, msg = "Generated message is incorrect!");
}


@test:Config {}
public function testMessageGeneration ()  {

    json expectedMsg = { "There was a Error" : "Error Occured" };
    error err = {message: "Error Occured"};
    json a = generateJsonFromError(err);
    test:assertEquals(a, expectedMsg, msg = "Generated message is incorrect!");
}

// This is datadriven test
@test:Config{
    dataProvider:"jsonDataProvider"
}
function testPayLoads (json pl){
    error|null valError = validateEventRequest(pl);
    match valError {
        error err => {
            io:println("Validation Success");
            }
        null => {
            test:assertFail(msg = "The Payload is not correct");
            }
}
}

function jsonDataProvider() returns (json[][]) {
    return [[{
                 "name": "",
                 "start_time": "7.25",
                 "venue": "WSO2",
                 "organizer_name": "TYLER"
             }],
            [{
                 "name": "Ballerina2",
                 "start_time": "",
                 "venue": "WSO2",
                 "organizer_name": "TYLER"
             }
                            ],
            [{
                 "name": "Ballerina2",
                 "start_time": "7.25",
                 "venue": "",
                 "organizer_name": "TYLER"
             }
            ],
            [{
                 "start_time": "7.25",
                 "venue": "WSO2",
                 "organizer_name": "TYLER"
             }
            ],
            [{
                 "name": "Ballerina2",
                 "venue": "WSO2",
                 "organizer_name": "TYLER"
             }
            ],
            [{
                 "name": "Ballerina2",
                 "start_time": "7.25",
                 "organizer_name": "TYLER"
             }
            ]
           ];
}