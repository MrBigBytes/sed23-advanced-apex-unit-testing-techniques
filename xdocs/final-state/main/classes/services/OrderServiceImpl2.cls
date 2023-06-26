public with sharing class OrderServiceImpl2
{
    // private IWarehouseService wh = new WarehouseServiceImpl();
    private IWarehouseService wh = (IWarehouseService)Application.Service.newInstance(IWarehouseService.class);

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

    // NOTE: Overriding class constructor is no longer required when using Factory injection
    // public OrderServiceImpl2()
    // {    
    // }

    // public OrderServiceImpl2(IWarehouseService wh)
    // {
    //     this.wh = wh; 
    // }
}