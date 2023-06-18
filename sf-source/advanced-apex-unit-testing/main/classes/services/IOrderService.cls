public interface IOrderService 
{
    String addToOrder( Order o, String productName, Integer requestedQuantity );
}

// TODO: This class is for when we start to refactor the code to make it ready for mocking