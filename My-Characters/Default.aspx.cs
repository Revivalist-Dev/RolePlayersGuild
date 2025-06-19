using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.MyCharacters
{
    public partial class Default : System.Web.UI.Page
    {
        protected string DisplayImageString(string img, string size)
        {
            return StringFunctions.DisplayImageString(img, size);
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            Master.PnlLeftCol.CssClass = "col-sm-3 col-xl-2";
            Master.PnlRightCol.CssClass = "col-sm-9 col-xl-10";
        }
    }
}