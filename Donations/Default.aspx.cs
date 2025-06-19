using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.Donations
{
    public partial class Default : System.Web.UI.Page
    {
        protected string CurrentUserID()
        {
            int returnValue = CookieFunctions.UserID;

            if (returnValue == 0)
            { btnDonate.Text = "Make Anonymous Donation via PayPal"; }

            return returnValue.ToString();
        }
    }
}