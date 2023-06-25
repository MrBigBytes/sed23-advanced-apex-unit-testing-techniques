@isTest
private class OrderServiceTest 
{
    @TestSetup
    private static void makeData()
    {
        // Typical data that needs to be setup 
        //  in order to test OrderService

        // insert Accounts
        // insert Contracts
        // insert Pricebooks
        // insert Products
        // insert Pricebook Entries
        // insert Orders
        // insert Merchandise
    }

    @isTest 
    private static void addToOrder_WithNonExistentProduct_ShouldReturnNoSuchProductMessage()
    {
        // Exit this method if the current date is not Christmas Day
        // because the method call can only be tested one day of the year
        if ( Date.today().month() != 12 && Date.today().day() != 25 )
        {
            return;
        }

        // Given
        Order o = new Order();
        OrderService os = new OrderService();

        // When
        String message = os.addToOrder(o, 'ProductNameThatDoesNotExist', 23);

        // Then
        Assert.areEqual('There are no products called ProductNameThatDoesNotExist'
                        , message
                        , 'Assertion of message failed.  Actual message was \'' + message + '\'');
    }
}