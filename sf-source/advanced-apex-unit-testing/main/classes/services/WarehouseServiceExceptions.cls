public class WarehouseServiceExceptions 
{
    private WarehouseServiceExceptions() {    }

    public class NoSuchProductException extends Exception { }

    public class IsClosedException extends Exception { }
}