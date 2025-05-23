using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.Account_Recovery
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnRecoverPassword_Click(object sender, EventArgs e)
        {
            int UserID = DataFunctions.Scalars.GetUserID(txtEmailAddress.Text);
            if (UserID > 0)
            {
                string AttemptID = DataFunctions.Scalars.GetSingleValue("INSERT INTO Recovery_Attempts (UserID) VALUES (@ParamOne);Select Scope_Identity() as NewID;", UserID).ToString();
                DataRow drAttempt = DataFunctions.Records.GetDataRow("Select * From Recovery_Attempts Where RecoveryAttemptID = @ParamOne", 0, AttemptID);
                //[RECOVERYKEY]&reckeytwo=&28[YEARDAY][RAND1]&usrid=[USERID]&usridtwo=[MONTHHOUR][RAND2]&chksum=[RAND3]

                string RecoveryKey = drAttempt["RecoveryKey"].ToString();
                string YearDay = string.Format("{0:yyyydd}", DateTime.Parse(drAttempt["RecoveryTimestamp"].ToString()));
                string MonthHour = string.Format("{0:MMHH}", DateTime.Parse(drAttempt["RecoveryTimestamp"].ToString()));
                string Rand1 = StringFunctions.GenerateRandomString(4, "1234567890");
                string Rand2 = StringFunctions.GenerateRandomString(6, "1234567890");
                string Rand3 = StringFunctions.GenerateRandomString(20, "-ASDFGHJKLUIOPZXCV1234567890");

                NotificationFunctions.PasswordRecoveryNotification(RecoveryKey, YearDay, MonthHour, UserID.ToString(), Rand1, Rand2, Rand3);

                divRecoveryPanel.Attributes["class"] = "panel panel-success";
                divMessage.Visible = true;
                divPanelBody.Visible = false;
                litMessage.Text = "<p>Your recovery email has been sent!</p>";
            }
            else
            {
                divRecoveryPanel.Attributes["class"] = "panel panel-danger";
                divMessage.Visible = true;
                divPanelBody.Visible = false;
                litMessage.Text = "<p>The email address provided cannot be found!</p>";
            }
        }
    }
}