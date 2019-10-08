using MongoDB.Driver;
using ReportingService.Processor.Domain.Entities.MongoDB;
using System.Security.Authentication;

namespace ReportingService.Processor.Helpers.Base
{
    public class DBBaseHelper : BaseHelper
    {
        private MongoDBConnectionInfo mongoDBConnectionInfo = null;

        public DBBaseHelper(MongoDBConnectionInfo mongoDBConnectionInfo)
        {
            this.mongoDBConnectionInfo = mongoDBConnectionInfo;
        }

        public MongoDBConnectionInfo GetMongoDBConnectionInfo()
        {
            return mongoDBConnectionInfo;
        }

        public IMongoDatabase GetMongoDatabase()
        {
            IMongoDatabase database;
            string connectionString = GetMongoDBConnectionInfo().ConnectionString;
            MongoClientSettings settings = MongoClientSettings.FromUrl(new MongoUrl(connectionString));
            settings.SslSettings = new SslSettings() { EnabledSslProtocols = SslProtocols.Tls12 };
            MongoClient mongoClient = new MongoClient(settings);
            database = mongoClient.GetDatabase(GetMongoDBConnectionInfo().DatabaseId);

            return database;
        }
    }
}