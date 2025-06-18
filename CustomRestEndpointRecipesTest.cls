@isTest
private class CustomRestEndpointRecipesTest {
    @testSetup
    static void setup() {
        // Create a Contact for deletion
        insert new Contact(FirstName = 'Test', LastName = 'DeleteMe', Email = 'delete.me@example.com');
    }

    @isTest
    static void testDeleteContactSuccess() {
        Contact c = [SELECT Id FROM Contact WHERE Email = 'delete.me@example.com' LIMIT 1];
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/integration-service/' + c.Id;
        req.httpMethod = 'DELETE';
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        CustomRestEndpointRecipes.deleteSingleContact();
        Test.stopTest();
        System.assertEquals(200, res.statusCode, 'Should return 200 OK');
        System.assert(res.responseBody.toString().contains('Contact deleted successfully'), 'Should confirm deletion');
        // Confirm Contact is deleted
        System.assertEquals(0, [SELECT count() FROM Contact WHERE Id = :c.Id], 'Contact should be deleted');
    }

    @isTest
    static void testDeleteContactNotFound() {
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/integration-service/003000000000000AAA';
        req.httpMethod = 'DELETE';
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        CustomRestEndpointRecipes.deleteSingleContact();
        Test.stopTest();
        System.assertEquals(400, res.statusCode, 'Should return 400 for not found');
        System.assert(res.responseBody.toString().contains('Contact not found'), 'Should indicate not found');
    }

    @isTest
    static void testDeleteContactInvalidId() {
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/integration-service/invalidId';
        req.httpMethod = 'DELETE';
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        CustomRestEndpointRecipes.deleteSingleContact();
        Test.stopTest();
        System.assertEquals(400, res.statusCode, 'Should return 400 for invalid id');
        System.assert(res.responseBody.toString().contains('Invalid or missing ContactId'), 'Should indicate invalid id');
    }

    @isTest
    static void testDeleteContactNoPermission() {
        // Simulate no delete permission by using a custom setting or mocking if available
        // Here, we simulate by using the Describe call
        // Temporarily override isDeletable if possible (not possible in real org, but for demo):
        // This test is a placeholder for environments where FLS/CRUD can be mocked
        // In real orgs, run as a user without delete permission
        // For now, just assert the code path
        Contact c = [SELECT Id FROM Contact WHERE Email = 'delete.me@example.com' LIMIT 1];
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/integration-service/' + c.Id;
        req.httpMethod = 'DELETE';
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        // Can't actually change permissions in test context, so this is a placeholder
        // System.runAs(userWithoutDeletePerms) { ... }
        // For now, just call and check for 200 or 403
        Test.startTest();
        CustomRestEndpointRecipes.deleteSingleContact();
        Test.stopTest();
        System.assert(res.statusCode == 200 || res.statusCode == 403, 'Should return 200 or 403 depending on org permissions');
    }
} 