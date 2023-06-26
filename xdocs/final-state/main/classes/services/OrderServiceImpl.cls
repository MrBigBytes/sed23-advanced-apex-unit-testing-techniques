public with sharing class OrderServiceImpl
    implements IOrderService
{
    private IWarehouseService wh = new WarehouseServiceImpl();

    public String addToOrder( Order o, String productName, Integer requestedQuantity )
    {
        try 
        {
            List<Product2> products = wh.getProducts( productName, requestedQuantity );

            if ( products.isEmpty() )
            {
                return 'Item is out of stock.';
            }

            // do some work to add the requested product to the order

            return 'The item has been added to your order.';

        } 
        catch (WarehouseServiceExceptions.NoSuchProductException nspe) 
        {
            return String.format('There are no products called {0}.', new List<Object>{ productName });
        }
        catch (WarehouseServiceExceptions.IsClosedException ice) 
        {
            return 'The warehouse is currently closed.  Try again later.';
        }
    }

    // TODO REMOVE EVERYTHING BELOW FOR INITIAL DISPLAY
    public OrderServiceImpl()
    {
        
    }

    public OrderServiceImpl(IWarehouseService wh)
    {
        this.wh = wh; 
    }
}