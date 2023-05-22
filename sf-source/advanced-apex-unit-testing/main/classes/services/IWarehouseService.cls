public interface IWarehouseService 
{
    List<Product2> getProducts(String productName, Integer requestedQuantity);
}