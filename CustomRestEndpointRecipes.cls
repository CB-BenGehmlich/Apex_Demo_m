// Apex REST endpoint for Contact record deletion
@RestResource(urlMapping='/integration-service/*')
global with sharing class CustomRestEndpointRecipes {
    /**
     * Deletes a single Contact record by Id via HTTP DELETE.
     * Endpoint: /services/apexrest/integration-service/{ContactId}
     *
     * Returns:
     *   200 OK on success
     *   400 Bad Request if ContactId is missing or invalid
     *   403 Forbidden if user lacks permission
     *   500 Internal Server Error for unhandled exceptions
     */
    @HttpDelete
    global static void deleteSingleContact() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String contactId;
        try {
            // Extract ContactId from the URL
            String[] uriParts = req.requestURI.split('/');
            contactId = uriParts.size() > 0 ? uriParts[uriParts.size() - 1] : null;
            if (String.isBlank(contactId) || !contactId.startsWith('003')) {
                res.statusCode = 400;
                res.responseBody = Blob.valueOf('Invalid or missing ContactId.');
                return;
            }
            // Query the Contact
            Contact c = [SELECT Id FROM Contact WHERE Id = :contactId LIMIT 1];
            // Permission check (FLS/CRUD)
            if (!Schema.sObjectType.Contact.isDeletable()) {
                res.statusCode = 403;
                res.responseBody = Blob.valueOf('Insufficient permissions to delete Contact.');
                return;
            }
            // Attempt to delete
            try {
                delete c;
                res.statusCode = 200;
                res.responseBody = Blob.valueOf('Contact deleted successfully.');
            } catch (DmlException dmlEx) {
                res.statusCode = 500;
                res.responseBody = Blob.valueOf('Failed to delete Contact: ' + dmlEx.getMessage());
            }
        } catch (QueryException qe) {
            res.statusCode = 400;
            res.responseBody = Blob.valueOf('Contact not found: ' + qe.getMessage());
        } catch (Exception ex) {
            res.statusCode = 500;
            res.responseBody = Blob.valueOf('Internal server error: ' + ex.getMessage());
        }
    }
} 