using MongoDB.Driver;
using ReportingService.Processor.Domain.Entities.MongoDB;
using ReportingService.Processor.Helpers.Base;
using System;
using System.Threading.Tasks;

namespace ReportingService.Processor.Helpers
{
    public class MongoDBHelper : DBBaseHelper
    {
        public MongoDBHelper(MongoDBConnectionInfo mongoDBConnectionInfo) : base(mongoDBConnectionInfo)
        {
        }

        public async Task RegisterReportAsync(Report entity)
        {
            DateTime datetimestamp = DateTime.UtcNow;
            IMongoCollection<Report> userCollection = GetMongoDatabase().GetCollection<Report>(GetMongoDBConnectionInfo().UserCollection);
            entity.created_date = datetimestamp;
            entity.updated_date = datetimestamp;
            await userCollection.InsertOneAsync(entity);
        }
    }
}