using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.Mailbox.Unread
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Master.PnlLeftCol.CssClass = "col-md-3 col-xl-2";
            Master.PnlRightCol.CssClass = "col-md-9 col-xl-10";
            if (Session["HideAds"] != null && Session["HideAds"].ToString() == "true")
            {
                divThreadAd.Visible = false;
            }
        }
    }
}