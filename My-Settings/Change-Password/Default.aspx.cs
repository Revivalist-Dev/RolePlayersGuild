using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.MySettings
{
    public partial class ChangePassword : System.Web.UI.Page
    {
        private int UserID
        {
            get
            {
                if (Session["UserID"] == null)
                {
                    Response.Redirect("/");
                    return 0;
                }
                return ((int)Session["UserID"]);
            }
            set
            {
                Session["UserID"] = value;
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            Master.PnlLeftCol.CssClass = "col-sm-3 col-xl-2";
            Master.PnlRightCol.CssClass = "col-sm-9 col-xl-10";

            //if (!Page.IsPostBack)
            //{
            //    DataRow drUser = DataFunctions.Records.GetDataRow("Select * From Users Where UserID = @ParamOne", 0, UserID);
            //    chkMatureContent.Checked = (bool)drUser["ShowMatureContent"];
            //    chkThreadNotifications.Checked = (bool)drUser["ReceivesThreadNotifications"];
            //    chkImageCommentNotifications.Checked = (bool)drUser["ReceivesImageCommentNotifications"];
            //    chkWritingCommentNotifications.Checked = (bool)drUser["ReceivesWritingCommentNotifications"];
            //    chkDevUpdates.Checked = (bool)drUser["ReceivesDevEmails"];
            //    chkErrors.Checked = (bool)drUser["ReceivesErrorFixEmails"];
            //    chkEmailBlasts.Checked = (bool)drUser["ReceivesGeneralEmailBlasts"];
            //    chkShowWhenOnline.Checked = (bool)drUser["ShowWhenOnline"];
            //    chkShowWriterLinkOnCharacters.Checked = (bool)drUser["ShowWriterLinkOnCharacters"];
            //    chkHideStream.Checked = (bool)drUser["HideStream"];
            //    txtUsername.Text = drUser["Username"].ToString();
            //    txtEmailAddress.Text = drUser["EmailAddress"].ToString();
            //    chkUseDarkTheme.Checked = (bool)drUser["UseDarkTheme"];
            //}

        }

        protected void btnSaveSettings_Click(object sender, EventArgs e)
        {
            if (txtNewPassword.Text == txtNewPasswordConfirm.Text)
            {
                int CountOfUsersWithPassword = (int)DataFunctions.Scalars.GetSingleValue("Select Count(UserID) from Users Where Password = @ParamOne AND UserID = @ParamTwo", txtCurrentPassword.Text, Session["UserID"]);

                if (CountOfUsersWithPassword > 0)
                {

                    DataFunctions.Updates.UpdateRow("UPDATE Users SET " +
                        "Password = @ParamTwo " +
                        "WHERE (UserID = @ParamOne)",
                        UserID, txtNewPassword.Text);
                    Response.Redirect("/My-Settings/");
                }
                else
                {
                    pnlMessage.Visible = true;
                    pnlMessage.CssClass = "alert alert-danger";
                    litMessage.Text = "Invalid Current Password!";
                }
            }
            else
            {
                pnlMessage.Visible = true;
                pnlMessage.CssClass = "alert alert-danger";
                litMessage.Text = "Your passwords don't match!";
            }
        }
    }
}