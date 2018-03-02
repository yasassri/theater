package src.utils;
import src.model as mod;

// Generates a Json error message from a provided error
public function generateJsonFromError(error err) (json jErr) {
    jErr = {"There was a Error":err.message};
    return ;
}

// Generaates the Event Add reqest with the provided struct
public function generateEventRequest(mod:AddEvent event) (json js) {
    js = {"name":event.name,"start_time":event.start_time,"venue":event.venue,"organizer_name":event.organizer_name,"event_type":event.event_type};
    return ;
}