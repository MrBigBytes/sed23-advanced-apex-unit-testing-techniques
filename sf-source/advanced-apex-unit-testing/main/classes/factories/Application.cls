public class Application 
{
    private Application() { }

    // Configure and create the ServiceFactory for this Application
	public static final SimpleServiceFactory Service = 
                                            new Application.SimpleServiceFactory( 
                                                new Map<Type, Type> {
                                                    IWarehouseService.class => WarehouseServiceImpl.class
                                                });

    public class SimpleServiceFactory
    {
        protected Map<Type, Type> m_serviceInterfaceTypeByServiceImplType;
    
        protected Map<Type, Object> m_serviceInterfaceTypeByMockService;
    
        /**
		 * Constructs a simple Service Factory
		 **/
		public SimpleServiceFactory() { }

		/**
		 * Constructs a simple Service Factory, 
		 *   using a Map of Apex Interfaces to Apex Classes implementing the interface
		 *   Note that this will not check the Apex Classes given actually implement the interfaces
		 *     as this information is not presently available via the Apex runtime
		 *
		 * @param serviceInterfaceTypeByServiceImplType Map ofi interfaces to classes
		 **/
		public SimpleServiceFactory(Map<Type, Type> serviceInterfaceTypeByServiceImplType)
		{
			m_serviceInterfaceTypeByServiceImplType = serviceInterfaceTypeByServiceImplType;
			m_serviceInterfaceTypeByMockService = new Map<Type, Object>();
		}
    
        /**
         * Returns a new instance of the Apex class associated with the given Apex interface
         *   Will return any mock implementation of the interface provided via setMock
         *   Note that this method will not check the configured Apex class actually implements the interface
         *
         * @param serviceInterfaceType Apex interface type
         * @exception Is thrown if there is no registered Apex class for the interface type
         **/
        public Object newInstance(Type serviceInterfaceType)
        {
            // Mock implementation?
            if(m_serviceInterfaceTypeByMockService.containsKey(serviceInterfaceType))
                return m_serviceInterfaceTypeByMockService.get(serviceInterfaceType);
    
            // Create an instance of the type implementing the given interface
            Type serviceImpl = m_serviceInterfaceTypeByServiceImplType.get(serviceInterfaceType);
            if(serviceImpl==null)
                throw new Application.DeveloperException('No implementation registered for service interface ' + serviceInterfaceType.getName());	
            return serviceImpl.newInstance();
        }
    
        @TestVisible
        private void setMock(Type serviceInterfaceType, Object serviceImpl)
        {
            m_serviceInterfaceTypeByMockService.put(serviceInterfaceType, serviceImpl);
        }

    }
    
    private class DeveloperException
        extends Exception 
    {

    }
}