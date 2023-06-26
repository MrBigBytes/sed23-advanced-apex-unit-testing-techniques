public with sharing class WarehouseServiceImpl 
    implements IWarehouseService
{
    public List<Product2> getProducts(String productName, Integer requestedQuantity) 
    {
        if (this.warehouseIsClosed())
        {
            throw new WarehouseServiceExceptions.IsClosedException();
        }

        // Query the products
        List<Product2> productsAvailable = [SELECT CreatedById, CreatedDate, Description, DisplayUrl, ExternalDataSourceId
                                                 , ExternalId, Family, Id, IsActive, IsArchived, IsDeleted, LastModifiedById
                                                 , LastModifiedDate, LastReferencedDate, LastViewedDate, Name, ProductCode
                                                 , QuantityUnitOfMeasure, StockKeepingUnit, SystemModstamp
                                              FROM Product2
                                             WHERE Name = :productName
                                               AND IsActive = true
                                              ];

        if (productsAvailable.isEmpty())
        {
            throw new WarehouseServiceExceptions.NoSuchProductException();
        }

        return new List<Product2>();
    }

    private Boolean warehouseIsClosed()
    {
        return this.todayIsHolidayObserved() || this.todayIsWeekend();
    }

    private Boolean todayIsWeekend()
    {
        Date myDate = Date.today().addDays(0);
        Date weekStart = myDate.toStartofWeek();
        Integer daysBetween = weekStart.daysBetween(myDate);
        System.debug(myDate);
        System.debug(weekStart);
        System.debug(daysBetween);
        
        // if daysBetween is 0 then today is Sunday 
        // and if daysBetween is 6 then today is Saturday
        return daysBetween == 0 || daysBetween == 6;
    }

    private Boolean todayIsHolidayObserved()
    {
        // Holiday Observed is Christmas Day
        return Date.today().month() == 12 && Date.today().day() == 25;
    }
}