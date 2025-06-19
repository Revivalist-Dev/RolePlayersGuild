using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.Logout
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] != null)
            {
                DataFunctions.Updates.UpdateRow("UPDATE Users SET LastAction = Null WHERE UserID = @ParamOne;", Session["UserID"]);
                Session.Clear();
                Session.Abandon();
                CookieFunctions.RemoveEncryptedCookie("UserID");
                CookieFunctions.RemoveEncryptedCookie("UserTypeID");
                CookieFunctions.RemoveEncryptedCookie("HideStream");
                CookieFunctions.RemoveEncryptedCookie("IsStaff");
            }
            Response.Redirect("/");
        }
    }
}