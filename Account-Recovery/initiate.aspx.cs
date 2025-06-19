using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.Account_Recovery
{
    public partial class Initiate : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["reckey"] != null && Request.QueryString["reckeytwo"] != null && Request.QueryString["usrid"] != null && Request.QueryString["usridtwo"] != null && Request.QueryString["chksum"] != null)
            {
                string reckey = Request.QueryString["reckey"];
                string reckeytwo = Request.QueryString["reckeytwo"].Substring(2, 6);
                string usrid = Request.QueryString["usrid"];
                string usridtwo = Request.QueryString["usridtwo"].Substring(0, 4);
                string chksum = Request.QueryString["chksum"];

                DataRow drAttempt = DataFunctions.Records.GetDataRow("Select * From Recovery_Attempts Where RecoveryKey = @ParamOne", 0, Request.QueryString["reckey"]);

                if (drAttempt != null)
                {
                    DateTime recTimestamp = DateTime.Parse(drAttempt["RecoveryTimestamp"].ToString());
                    if (recTimestamp > DateTime.Now.AddMinutes(-30))
                    {
                        if (drAttempt["UserID"].ToString() == usrid && string.Format("{0:yyyyddMMHH}", recTimestamp) == reckeytwo + usridtwo)
                        {
                            string NewPassword = StringFunctions.GenerateRandomString(7);

                            divRecoveryPanel.Attributes["class"] = "panel panel-success";
                            litMessage.Text = "<p>Your password has been recovered! Please log in with the new password below.</p><p><strong>" + NewPassword + "</strong></p>";

                            DataFunctions.Updates.UpdateRow("UPDATE Users SET Password = @ParamOne Where UserID = @ParamTwo", NewPassword, usrid);
                        }
                    }
                    else
                    {
                        divRecoveryPanel.Attributes["class"] = "panel panel-danger";
                        litMessage.Text = "<p>The recovery key you provided is no longer valid. Please try again. Make sure you click the link within 30 minutes.</p>";
                    }
                    DataFunctions.Deletes.DeleteRows("Delete From Recovery_Attempts Where RecoveryAttemptID = @ParamOne", drAttempt["RecoveryAttemptID"]);
                }
                else
                {
                    divRecoveryPanel.Attributes["class"] = "panel panel-danger";
                    litMessage.Text = "<p>The recovery attempt was invalid.</p>";
                }
            }
            else
            {
                Response.Redirect("/");
            }
            //[RECOVERYKEY]&reckeytwo=&28[YEARDAY][RAND1]&usrid=[USERID]&usridtwo=[MONTHHOUR][RAND2]&chksum=[RAND3]
            //4, 6, 15
        }
    }
}