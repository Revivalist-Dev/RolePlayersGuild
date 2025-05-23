using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.Mailbox.CreateThread
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Master.PnlLeftCol.CssClass = "col-md-3";
            Master.PnlRightCol.CssClass = "col-md-9";
        }
    }
}