using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.VoteForRPG
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            int CurrentUserID = CookieFunctions.UserID;
            if (CurrentUserID != 0)
            {
                DataFunctions.Updates.UpdateRow("Update Users Set LastVoteDateTime = GetDate() Where UserID = @ParamOne;", CurrentUserID);
                Response.Redirect("http://www.toprpsites.com/index.php?a=in&u=Villanite");
            }
        }
    }
}