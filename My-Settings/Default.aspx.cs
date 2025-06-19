using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.MySettings
{
    public partial class Default : System.Web.UI.Page
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

            if (Request.QueryString["rsn"] != null)
            {
                switch (Request.QueryString["rsn"])
                {
                    case "NoUsername":
                        pnlMessage.Visible = true;
                        pnlMessage.CssClass = "alert alert-danger";
                        litMessage.Text = "Your profile does not seem to have a username. Account Usernames are now required. Please enter one and save your settings.";
                        break;
                }
            }

            if (!Page.IsPostBack)
            {
                DataRow drUser = DataFunctions.Records.GetDataRow("Select * From Users Where UserID = @ParamOne", 0, UserID);
                chkMatureContent.Checked = (bool)drUser["ShowMatureContent"];
                chkThreadNotifications.Checked = (bool)drUser["ReceivesThreadNotifications"];
                chkImageCommentNotifications.Checked = (bool)drUser["ReceivesImageCommentNotifications"];
                chkWritingCommentNotifications.Checked = (bool)drUser["ReceivesWritingCommentNotifications"];
                chkDevUpdates.Checked = (bool)drUser["ReceivesDevEmails"];
                chkErrors.Checked = (bool)drUser["ReceivesErrorFixEmails"];
                chkEmailBlasts.Checked = (bool)drUser["ReceivesGeneralEmailBlasts"];
                chkShowWhenOnline.Checked = (bool)drUser["ShowWhenOnline"];
                chkShowWriterLinkOnCharacters.Checked = (bool)drUser["ShowWriterLinkOnCharacters"];
                txtUsername.Text = drUser["Username"].ToString();
                txtEmailAddress.Text = drUser["EmailAddress"].ToString();
                chkUseDarkTheme.Checked = (bool)drUser["UseDarkTheme"];

                if (Request.QueryString["ShowReferralInfo"] != null)
                {
                    txtReferralID.Text = drUser["ReferredBy"].ToString();

                    if (txtReferralID.Text.Length > 0 && txtReferralID.Text != "0")
                    {
                        pnlReferralSettings.Visible = false;
                    }
                    else
                    {
                        pnlReferralSettings.Visible = true;

                        pnlReferralMessage.CssClass = "alert alert-danger";
                        pnlReferralMessage.Visible = true;
                        litReferralMessage.Text = "<p>Give credit to the friend who showed RPG! Get your friend's Writer ID, or ask them for it and enter the number here.</p> <p><strong>NOTE: </strong>This setting can not be changed after it is saved, please make sure you have the proper ID number in the field before saving. Using your own ID will result in a forfeit of this privelege.</p>";
                    }
                }
                int MembershipTypeID = DataFunctions.Scalars.GetMembershipTypeID(CookieFunctions.UserID);
                switch (MembershipTypeID)
                {
                    case 1:
                    case 2:
                    case 3:
                        lnkUnsubscribeButton.Visible = true;
                        break;
                    default:
                        lnkSubscribeButton.Visible = true;
                        break;
                }
            }
        }

        protected void btnSaveSettings_Click(object sender, EventArgs e)
        {
            if (Request.QueryString["ShowReferralInfo"] != null)
            {
                int ReferrerUserID;
                if (txtReferralID.Text != null && int.TryParse(txtReferralID.Text, out ReferrerUserID))
                {
                    if (ReferrerUserID == UserID) ReferrerUserID = 1;
                    DataFunctions.RunStatement("Update Users Set ReferredBy = @ParamTwo Where UserID = @ParamOne", UserID, ReferrerUserID);
                    DataFunctions.RunStatement("INSERT INTO User_Badges (UserID, BadgeID, ReasonEarned) VALUES (@ParamOne,@ParamTwo,@ParamThree)", ReferrerUserID, 9, "Referred User " + UserID.ToString() + " to the site.");
                }
                txtReferralID.Enabled = false;
            }

            int CountOfUsersWithUsername = (int)DataFunctions.Scalars.GetSingleValue("Select Count(UserID) from Users Where Username = @ParamOne AND UserID <> @ParamTwo", txtUsername.Text, Session["UserID"]);

            if (CountOfUsersWithUsername == 0)
            {

                DataFunctions.Updates.UpdateRow("UPDATE Users SET " +
                    "ShowMatureContent = @ParamTwo, " +
                    "ReceivesThreadNotifications = @ParamThree, " +
                    "ReceivesImageCommentNotifications = @ParamFour, " +
                    "ReceivesWritingCommentNotifications = @ParamFive, " +
                    "ReceivesDevEmails = @ParamSix, " +
                    "ReceivesErrorFixEmails = @ParamSeven, " +
                    "ReceivesGeneralEmailBlasts = @ParamEight, " +
                    "ShowWhenOnline = @ParamNine, " +
                    "ShowWriterLinkOnCharacters = @ParamTen, " +
                    "Username = @ParamEleven, " +
                    "UseDarkTheme = @ParamTwelve, " +
                    "EmailAddress = @ParamThirteen " +
                    "WHERE (UserID = @ParamOne)",
                    UserID, chkMatureContent.Checked, chkThreadNotifications.Checked, chkImageCommentNotifications.Checked,
                    chkWritingCommentNotifications.Checked, chkDevUpdates.Checked, chkErrors.Checked, chkEmailBlasts.Checked,
                    chkShowWhenOnline.Checked, chkShowWriterLinkOnCharacters.Checked, txtUsername.Text, chkUseDarkTheme.Checked,
                    txtEmailAddress.Text);
                pnlMessage.Visible = true;
                pnlMessage.CssClass = "alert alert-success";
                litMessage.Text = "Your settings have been successfully saved!";

                //CookieFunctions.HideStream = chkHideStream.Checked;

                Response.Cookies["UseDarkTheme"].Value = chkUseDarkTheme.Checked.ToString();
                Response.Cookies["UseDarkTheme"].Expires = DateTime.Now.AddDays(14);
            }
            else
            {
                pnlMessage.Visible = true;
                pnlMessage.CssClass = "alert alert-danger";
                litMessage.Text = "Someone is already using that username!";
            }
        }
    }
}