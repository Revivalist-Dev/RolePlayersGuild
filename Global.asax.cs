using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using System.Web.UI;

namespace RolePlayersGuild
{
    public class Global : System.Web.HttpApplication
    {

        protected void Application_Start(object sender, EventArgs e)
        {
            //TODO: Figure out this stuff. Even though I implemented this, it still forces postbacks. Related to ValidationSettings:UnobtrusiveValidationMode in AppSettings.
            //Todo: This is in regards to Update Panels, btw.
            //string JQueryVer = "2.2.1";
            //ScriptManager.ScriptResourceMapping.AddDefinition("jquery", new ScriptResourceDefinition
            //{
            //    Path = "~/Scripts/jquery-" + JQueryVer + ".min.js",
            //    DebugPath = "~/Scripts/jquery-" + JQueryVer + ".js",
            //    CdnPath = "http://ajax.aspnetcdn.com/ajax/jQuery/jquery-" + JQueryVer + ".min.js",
            //    CdnDebugPath = "http://ajax.aspnetcdn.com/ajax/jQuery/jquery-" + JQueryVer + ".js",
            //    CdnSupportsSecureConnection = true,
            //    LoadSuccessExpression = "window.jQuery"
            //});
        }

        protected void Session_Start(object sender, EventArgs e)
        {

        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {

        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {

            Exception ex = HttpContext.Current.Server.GetLastError().InnerException;
            StringBuilder EmailBody = new StringBuilder();
            string DoubleLineBreak = Environment.NewLine + Environment.NewLine;

            EmailBody.Append("Error from RPG" + DoubleLineBreak + ex + DoubleLineBreak);

            if (HttpContext.Current.Session.Count > 0)
            {
                EmailBody.Append("==Session Variables==" + DoubleLineBreak);
                foreach (string SessionItem in HttpContext.Current.Session.Contents)
                {
                    try
                    {
                        EmailBody.Append(SessionItem + " = " + HttpContext.Current.Session[SessionItem].ToString() + Environment.NewLine);
                    }
                    catch
                    {
                    }
                }
                EmailBody.Append(Environment.NewLine);
            }

            if (HttpContext.Current.Request.QueryString.Count > 0)
            {
                EmailBody.Append("==Query String Variables==" + DoubleLineBreak);
                foreach (string QueryItem in HttpContext.Current.Request.QueryString)
                {
                    EmailBody.Append(QueryItem + " = " + HttpContext.Current.Request.QueryString[QueryItem].ToString() + Environment.NewLine);
                }
                EmailBody.Append(Environment.NewLine);
            }

            if (HttpContext.Current.Request.Form.Count > 0)
            {
                EmailBody.Append("==Form Variables==" + DoubleLineBreak);
                foreach (string FormItem in HttpContext.Current.Request.Form)
                {
                    EmailBody.Append(FormItem + " = " + HttpContext.Current.Request.Form[FormItem].ToString() + Environment.NewLine);
                }
                EmailBody.Append(Environment.NewLine);
            }
            if (HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"] != null)
            {
                EmailBody.Append("IP / HTTP_X_FORWARDED_FOR: " + HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"].ToString() + DoubleLineBreak);
            }
            if (HttpContext.Current.Request.UserHostAddress.Length != 0)
            {
                EmailBody.Append("IP / User Host Address: " + HttpContext.Current.Request.UserHostAddress + DoubleLineBreak);
            }
            if (HttpContext.Current.Request.Url != null)
            {
                EmailBody.Append("Current URL: " + HttpContext.Current.Request.Url.ToString() + DoubleLineBreak);
            }
            if (HttpContext.Current.Request.UrlReferrer != null)
            {
                EmailBody.Append("Referrer URL: " + HttpContext.Current.Request.UrlReferrer.ToString() + DoubleLineBreak);
            }

            //Dim ErrorMailService As New MailService.MailServiceSoapClient

            EmailBody.Append("==Server Variables==" + DoubleLineBreak);
            string strText = "";
            System.Collections.Specialized.NameValueCollection nvcSV = HttpContext.Current.Request.ServerVariables;
            string[] arrKeys = nvcSV.AllKeys;
            int iCnt = 0;
            // loop through the collection and write the results
            for (iCnt = 0; iCnt <= arrKeys.Length - 1; iCnt++)
            {
                EmailBody.Append(arrKeys[iCnt] + ": " + nvcSV.Get(iCnt).ToString() + Environment.NewLine);
            }

            NotificationFunctions.SendErrorEmail(EmailBody);
            try
            {
                DataFunctions.RunStatement("INSERT INTO Error_Log (ErrorDetails) VALUES (@ParamOne)", EmailBody);
            }
            catch { }

        }

        protected void Session_End(object sender, EventArgs e)
        {

        }

        protected void Application_End(object sender, EventArgs e)
        {

        }
    }
}