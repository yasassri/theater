package src.utils;

public function generateJsonFromError (error err) (json jErr) {
    jErr = {"There was a Error":err.message};
    return;
}