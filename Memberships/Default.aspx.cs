using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.Memberships
{
    public partial class Default : System.Web.UI.Page
    {
        protected string CurrentUserID()
        {
            return CookieFunctions.UserID.ToString();
        }
    }
}