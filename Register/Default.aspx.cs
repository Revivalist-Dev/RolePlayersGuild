using System;

namespace RolePlayersGuild.Register
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (CookieFunctions.UserID != 0)
            {
                Response.Redirect("/My-Dashboard/");
            }

            //Panel divLeftCol = (Panel)Master.FindControl("divLeftCol");
            //Panel divRightCol = (Panel)Master.FindControl("divRightCol");
            //divLeftCol.CssClass = "col-md-5";
            //divRightCol.CssClass = "col-md-7";            

            //foreach (var control in Master.Controls)
            //{
            //    if (control.ToString().Contains("Literal"))
            //    {
            //        System.Web.UI.LiteralControl MahControl = (System.Web.UI.LiteralControl)control;
            //        Response.Write("=" + MahControl.ID);
            //    }
            //    Response.Write(control.ToString() + "<br/>" );
            //}

            Master.PnlLeftCol.CssClass = "col-sm-5";
            Master.PnlRightCol.CssClass = "col-sm-7";

            divMoblFriendlyAgreementText.InnerHtml = divAgreementText.InnerHtml;

            if (Request.QueryString["rsn"] != null)
            {
                if (Request.QueryString["rsn"] == "NoAccess")
                {
                    pnlMessage.Visible = true;
                    pnlMessage.CssClass = "alert alert-warning";
                    litMessage.Text = "<p>Thank you for your interest in RPG! Unfortunately, it seems you have found your way to a section of the site that you do not have permission to access. Worry not, however! Using the form below, you can join RPG and start reading and writing all you want!</p>";
                }
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            //if (txtSecretCode.Text == "For The Villanite Family!")
            //{
            string EncodedResponse = Request.Form["g-Recaptcha-Response"];
            bool IsCaptchaValid = (ReCaptcha.Validate(EncodedResponse) == "true" ? true : false);

            if (IsCaptchaValid)
            {
                //var adapterUsers = new rpgDBTableAdapters.UsersTableAdapter();
                var ExistingUserID = DataFunctions.Scalars.GetUserID(txtEmailAddress.Text);
                if (ExistingUserID == 0)
                {
                    ExistingUserID = DataFunctions.Scalars.GetUserIDByUsername(txtUsername.Text);
                    if (ExistingUserID == 0)
                    {
                        int NewUserID = DataFunctions.Inserts.CreateNewUser(txtEmailAddress.Text, txtPassword.Text, txtUsername.Text);
                        pnlMessage.Visible = true;
                        pnlMessage.CssClass = "alert alert-success";
                        litMessage.Text = "<strong>Done!</strong> Please go ahead and use your new credentials to log in. Thank you!";
                        pnlRegistrationForm.Visible = false;

                        if (Session["ReferralID"] != null)
                        {
                            DataFunctions.RunStatement("Update Users Set ReferredBy = @ParamTwo Where UserID = @ParamOne", NewUserID, Session["ReferralID"]);
                            DataFunctions.RunStatement("INSERT INTO User_Badges (UserID, BadgeID, ReasonEarned) VALUES (@ParamOne,@ParamTwo,@ParamThree)", Session["ReferralID"], 9, "Referred User " + NewUserID.ToString() + " to the site.");
                        }

                        MiscFunctions.SetUserInfo(DataFunctions.Records.GetUser(NewUserID));
                        Session["NewMember"] = true;
                        Response.Redirect("/Welcome-To-RPG/");
                    }
                    else
                    {
                        pnlMessage.Visible = true;
                        pnlMessage.CssClass = "alert alert-danger";
                        litMessage.Text = "The username you provided is already being used.";
                    }
                }
                else
                {
                    pnlMessage.Visible = true;
                    pnlMessage.CssClass = "alert alert-danger";
                    litMessage.Text = "The email you provided is already being used.";
                }
            }
            else
            {
                pnlMessage.Visible = true;
                pnlMessage.CssClass = "alert alert-danger";
                litMessage.Text = "The robo-person check didn't go through properly! Please make sure you wait for the checkmark!";
            }
            //}
            //else
            //{
            //    pnlMessage.Visible = true;
            //    pnlMessage.CssClass = "alert alert-danger";
            //    litMessage.Text = "That code isn't right...";
            //}
        }
    }
}