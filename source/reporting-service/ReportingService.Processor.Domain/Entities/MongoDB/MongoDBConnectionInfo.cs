namespace ReportingService.Processor.Domain.Entities.MongoDB
{
    public class MongoDBConnectionInfo
    {
        public string ConnectionString { get; set; }
        public string DatabaseId { get; set; }
        public string UserCollection { get; set; }
    }
}