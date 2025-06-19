using System;
using System.IO;
using System.Net;
using System.Text;
using System.Configuration;
using Newtonsoft.Json.Linq;

namespace RolePlayersGuild
{
    public class ReCaptcha
    {
        public bool Success { get; private set; }
        public string Error { get; private set; }

        public static ReCaptcha Validate(string response)
        {
            var result = new ReCaptcha();
            try
            {
                // 1. Get secret key from Web.config
                string secretKey = ConfigurationManager.AppSettings["RecaptchaSecretKey"];

                // 2. Create the request to the verification URL.
                var request = (HttpWebRequest)WebRequest.Create("https://www.google.com/recaptcha/api/siteverify");
                request.Method = "POST";
                request.ContentType = "application/x-www-form-urlencoded";

                // 3. Build the data to post to the API.
                string postData = $"secret={secretKey}&response={response}";
                byte[] dataBytes = Encoding.UTF8.GetBytes(postData);
                request.ContentLength = dataBytes.Length;

                // 4. Write the data to the request stream.
                using (var stream = request.GetRequestStream())
                {
                    stream.Write(dataBytes, 0, dataBytes.Length);
                }

                // 5. Get the response from Google's server.
                using (WebResponse webResponse = request.GetResponse())
                {
                    using (StreamReader streamReader = new StreamReader(webResponse.GetResponseStream()))
                    {
                        var jsonResponse = JObject.Parse(streamReader.ReadToEnd());
                        result.Success = jsonResponse.Value<bool>("success");

                        if (!result.Success)
                        {
                            var errorCodes = jsonResponse["error-codes"];
                            result.Error = errorCodes != null ? string.Join(", ", errorCodes.Values<string>()) : "The validation request was processed, but no error code was returned.";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                result.Success = false;
                result.Error = "A .NET exception occurred: " + ex.Message;
            }
            return result;
        }
    }
}