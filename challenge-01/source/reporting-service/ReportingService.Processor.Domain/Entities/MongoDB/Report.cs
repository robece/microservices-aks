using MongoDB.Bson;
using System;

namespace ReportingService.Processor.Domain.Entities.MongoDB
{
    public class Report
    {
        public ObjectId _id { get; set; }
        public string fullname { get; set; }
        public string email { get; set; }
        public DateTime created_date { get; set; }
        public DateTime updated_date { get; set; }
    }
}