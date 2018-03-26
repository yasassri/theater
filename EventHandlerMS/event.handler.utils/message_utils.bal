package event.handler.utils;

public function generateJsonFromError (error err) returns json {
   json jErr = { "There was a Error" : err.message };
   return jErr;
}