@isTest
public class DMLRecipes_local99_Test {


//Add new class variables here

@testSetup
public static void setup() {

//Add necessary test setup here for the new methods you are adding
    List<Account> accountsToDelete = new List<Account>{
        new Account(Name = 'Test Account'),
        new Account(Name = 'Test Account 2')
    };
    insert accountsToDelete;
    delete accountsToDelete;
}

    
    @isTest
    static void testInsertAccountWithValidName() {
        // Arrange
        String accountName = 'Test Account';
        
        // Act
        Account insertedAccount = DMLRecipes.insertAccountViaInsertKeywordInSystemMode(accountName);
        
        // Assert
        System.assertNotEquals(null, insertedAccount, 'Inserted account should not be null');
        System.assertEquals(accountName, insertedAccount.Name, 'Account name should match the input name');
    }
    
    @isTest
    static void testInsertAccountWithEmptyName() {
        // Arrange
        String emptyName = '';
        
        try {
            // Act
            DMLRecipes.insertAccountViaInsertKeywordInSystemMode(emptyName);
            System.assert(false, 'CustomDMLException was expected but not thrown');
        } catch (DMLRecipes.CustomDMLException ex) {
            // Assert
            System.assertEquals('Failed', ex.getMessage(), 'Expected CustomDMLException with message "Failed"');
        }
    }


//Add any new test methods here

@isTest
static void testUndeleteAccountInUserMode() {
    // Arrange
    List<Account> deletedAccounts = [SELECT Id, Name FROM Account WHERE Name LIKE 'Test Account%' AND IsDeleted = true ALL ROWS];
    
    // Act
    try {
        List<Account> undeletedAccounts = DMLRecipes.undeleteAccountViaDatabaseMethod(deletedAccounts, System.AccessLevel.USER_MODE);
        
        // Assert
        System.assertEquals(2, undeletedAccounts.size(), 'Should undelete 2 accounts');
        System.assertEquals('Test Account', undeletedAccounts[0].Name, 'First account name should match');
    } catch (DMLRecipes.CustomDMLException ex) {
        System.assert(false, 'CustomDMLException was not expected');
    }
}

@isTest
static void testUndeleteAccountInSystemMode() {
    // Arrange
    List<Account> deletedAccounts = [SELECT Id, Name FROM Account WHERE Name LIKE 'Test Account%' AND IsDeleted = true ALL ROWS];
    
    // Act
    try {
        List<Account> undeletedAccounts = DMLRecipes.undeleteAccountViaDatabaseMethod(deletedAccounts, System.AccessLevel.SYSTEM_MODE);
        
        // Assert
        System.assertEquals(2, undeletedAccounts.size(), 'Should undelete 2 accounts');
        System.assertEquals('Test Account 2', undeletedAccounts[1].Name, 'Second account name should match');
    } catch (DMLRecipes.CustomDMLException ex) {
        System.assert(false, 'CustomDMLException was not expected');
    }
}

}