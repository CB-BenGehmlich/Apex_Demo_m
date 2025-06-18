@RestResource(urlMapping='/integration-service/*')
global with sharing class CustomRestEndpointRecipes {
    @HttpDelete
    global static void deleteSingleContact() {
        // Get the Contact Id from the URL (no validation)
        String contactId = RestContext.request.requestURI.substringAfterLast('/');
        // Query for the Contact (no try/catch, no permission checks)
        List<Contact> contacts = [SELECT Id FROM Contact WHERE Id = :contactId];
        // Delete the Contact if found, else do nothing special
        if (contacts.size() > 0) {
            delete contacts[0];
            // Set response (no JSON, no error structure)
            RestContext.response.statusCode = 200;
            RestContext.response.responseBody = Blob.valueOf('Contact deleted');
        } else {
            RestContext.response.statusCode = 404;
            RestContext.response.responseBody = Blob.valueOf('Contact not found');
        }
    }
}

// This code is an example of a poorly designed Apex REST API endpoint for deleting a Contact record.
// It lacks many best practices and security measures that should be followed in production code.
// The code directly manipulates the response body with plain text, does not handle exceptions,
// and does not validate inputs or check permissions.
// This is not a recommended approach for building secure and robust Apex REST APIs.
// This code is intentionally bad and should not be used in production.

// Key "bad" practices included:
// No input validation or sanitization for the Contact Id.
// No try/catch for SOQL or DML exceptions (could throw unhandled errors).
// No CRUD/FLS permission checks.
// No authentication or authorization logic.
// No logging or monitoring.
// No use of custom error objects or JSON responses.
// No bulk support.
// No comments explaining logic or error handling.
// Direct manipulation of the response body with plain text.
// Let me know if you want a version that follows best practices!