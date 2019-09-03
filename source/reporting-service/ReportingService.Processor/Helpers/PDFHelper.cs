using DinkToPdf;
using ReportingService.Processor.Domain.Entities.Queue;
using ReportingService.Processor.Helpers.Base;
using ReportingService.Processor.Templates;
using System;

namespace ReportingService.Processor.Helpers
{
    public class PDFHelper : BaseHelper
    {
        public string Create(string guid, SynchronizedConverter converter, DispatchMessage dispatchMessage)
        {
            string result = string.Empty;

            converter.PhaseChanged += Converter_PhaseChanged;
            converter.ProgressChanged += Converter_ProgressChanged;
            converter.Finished += Converter_Finished;
            converter.Warning += Converter_Warning;
            converter.Error += Converter_Error;

            var globalSettings = new GlobalSettings
            {
                ColorMode = ColorMode.Color,
                Orientation = Orientation.Portrait,
                PaperSize = PaperKind.A4,
                Margins = new MarginSettings { Top = 10 },
                //Out = $"{guid}.pdf",
                DocumentTitle = "PDF Report"
            };

            var objectSettings = new ObjectSettings
            {
                PagesCount = true,
                HtmlContent = TemplateGenerator.GetHTMLString(dispatchMessage),
                WebSettings = { DefaultEncoding = "utf-8", UserStyleSheet = "styles.css" },
                HeaderSettings = { FontName = "Arial", FontSize = 9, Right = "Page [page] of [toPage]", Line = true },
                FooterSettings = { FontName = "Arial", FontSize = 9, Line = true, Center = "Report Footer" }
            };

            var document = new HtmlToPdfDocument()
            {
                GlobalSettings = globalSettings,
                Objects = { objectSettings }
            };

            byte[] pdf = converter.Convert(document);
            result = Convert.ToBase64String(pdf);

            return result;
        }

        private static void Converter_Error(object sender, DinkToPdf.EventDefinitions.ErrorArgs e)
        {
            Console.WriteLine("[ERROR] {0}", e.Message);
        }

        private static void Converter_Warning(object sender, DinkToPdf.EventDefinitions.WarningArgs e)
        {
            Console.WriteLine("[WARN] {0}", e.Message);
        }

        private static void Converter_Finished(object sender, DinkToPdf.EventDefinitions.FinishedArgs e)
        {
            Console.WriteLine("Conversion {0} ", e.Success ? "successful" : "unsucessful");
        }

        private static void Converter_ProgressChanged(object sender, DinkToPdf.EventDefinitions.ProgressChangedArgs e)
        {
            Console.WriteLine("Progress changed {0}", e.Description);
        }

        private static void Converter_PhaseChanged(object sender, DinkToPdf.EventDefinitions.PhaseChangedArgs e)
        {
            Console.WriteLine("Phase changed {0} - {1}", e.CurrentPhase, e.Description);
        }
    }
}