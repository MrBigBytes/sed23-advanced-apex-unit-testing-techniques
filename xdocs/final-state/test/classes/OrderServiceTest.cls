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
        OrderServiceImpl os = new OrderServiceImpl();

        // When
        String message = os.addToOrder(o, 'ProductNameThatDoesNotExist', 23);

        // Then
        Assert.areEqual('There are no products called ProductNameThatDoesNotExist'
                        , message
                        , 'Assertion of message failed.  Actual message was \'' + message + '\'');
    }

    // DEPENDENCYINJECTION-01
    @isTest 
    private static void addToOrder_WithExistingProduct_ShouldReturnItemAdded_testByMocking()
    {
        // place holder test method to demonstrate implementing test by mocking

        fflib_ApexMocks mocks = new fflib_ApexMocks();

        IWarehouseService mockWarehouse = (IWarehouseService) mocks.mock(IWarehouseService.class);

        List<Product2> testProducts = new List<Product2>{ new Product2() };

        mocks.startStubbing();

        mocks.when( mockWarehouse.getProducts('Apple', 23) )
             .thenReturn( testProducts );

        mocks.stopStubbing();

        // Given 
        Order o = new Order();
        OrderServiceImpl os = new OrderServiceImpl( mockWarehouse );

        // When
        String message = os.addToOrder(o, 'Apple', 23);

        // Then
        Assert.areEqual('The item has been added to your order.'
                        , message
                        , 'Assertion of message failed.  Actual message was \'' + message + '\'');

        // Also verify that the IWarehouseService.getProducts() method was called by OrderService
        ((IWarehouseService)mocks.verify(mockWarehouse)).getProducts('Apple', 23);

    }

    // DEPENDENCYINJECTION-01B
    @isTest 
    private static void addToOrder_WithNonExistentProduct_ShouldReturnNoSuchProductMessage_testByMocking()
    {
        // place holder test method to demonstrate implementing test by mocking

        fflib_ApexMocks mocks = new fflib_ApexMocks();

        IWarehouseService mockWarehouse = (IWarehouseService) mocks.mock(IWarehouseService.class);

        mocks.startStubbing();

        mocks.when( mockWarehouse.getProducts('ProductNameThatDoesNotExist', 23) )
            .thenThrow(new WarehouseServiceExceptions.NoSuchProductException() );

        mocks.stopStubbing();

        // Given 
        Order o = new Order();
        OrderServiceImpl os = new OrderServiceImpl( mockWarehouse );

        // When
        String message = os.addToOrder(o, 'ProductNameThatDoesNotExist', 23);

        // Then
        Assert.areEqual('There are no products called ProductNameThatDoesNotExist.'
                        , message
                        , 'Assertion of message failed.  Actual message was \'' + message + '\'');

        // Also verify that the IWarehouseService.getProducts() method was called by OrderService
        ((IWarehouseService)mocks.verify(mockWarehouse)).getProducts('ProductNameThatDoesNotExist', 23);

    }

    // DEPENDENCYINJECTION-02
    @isTest 
    private static void addToOrder_WithExistingProduct_ShouldReturnItemAdded_testByMockingWithFactory()
    {
        // place holder test method to demonstrate implementing test by mocking
        fflib_ApexMocks mocks = new fflib_ApexMocks();

        IWarehouseService mockWarehouse = (IWarehouseService) mocks.mock(IWarehouseService.class);

        List<Product2> testProducts = new List<Product2>{ new Product2() };

        mocks.startStubbing();

        mocks.when( mockWarehouse.getProducts('Apple', 23) )
             .thenReturn( testProducts );

        mocks.stopStubbing();

        Application.Service.setMock(IWarehouseService.class, mockWarehouse);

        // Given 
        Order o = new Order();
        OrderServiceImpl2 os = new OrderServiceImpl2();

        // When
        String message = os.addToOrder(o, 'Apple', 23);

        // Then
        Assert.areEqual('The item has been added to your order.'
                        , message
                        , 'Assertion of message failed.  Actual message was \'' + message + '\'');

        // Also verify that the IWarehouseService.getProducts() method was called by OrderService
        ((IWarehouseService)mocks.verify(mockWarehouse)).getProducts('Apple', 23);
    }
}