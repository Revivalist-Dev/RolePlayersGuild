using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.About_Us
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            int CurrentUserID = CookieFunctions.UserID;
            if (CurrentUserID != 0)
            {
                litBanner1.Text = "?ReferralID=" + CurrentUserID.ToString();
                litBanner2.Text = "?ReferralID=" + CurrentUserID.ToString();
                litBanner3.Text = "?ReferralID=" + CurrentUserID.ToString();
                litBanner4.Text = "?ReferralID=" + CurrentUserID.ToString();

                pPlainURL.Visible = true;
                prePlainURL.Visible = true;
                litPlainURL.Text = "?ReferralID=" + CurrentUserID.ToString();
            }
        }
        protected string CurrentUserID()
        {
            int returnValue = CookieFunctions.UserID;

            if (returnValue == 0)
            { btnDonate.Text = "Make Anonymous Donation via PayPal"; }

            return returnValue.ToString();
        }
    }
}