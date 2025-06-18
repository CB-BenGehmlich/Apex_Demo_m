# Apex_Demo_m

The Apex REST API for Contact record deletion has been implemented as CustomRestEndpointRecipes with a deleteSingleContact method. This class:
Exposes a DELETE endpoint at /services/apexrest/integration-service/{ContactId}
Validates the ContactId and checks for permissions
Handles all required error cases (400, 403, 500, 200)
Returns clear messages for each outcome
A comprehensive test class CustomRestEndpointRecipesTest is also provided, covering:
Successful deletion
Not found
Invalid ID
Permission error (with a placeholder for orgs where FLS/CRUD can be mocked)
