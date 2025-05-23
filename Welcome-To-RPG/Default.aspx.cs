using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.Welcome_To_RPG
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (Session["NewMember"] != null && (bool)Session["NewMember"] == true)
            { Session["NewMember"] = null; }
            else
            { Response.Redirect("/"); }
        }
    }
}