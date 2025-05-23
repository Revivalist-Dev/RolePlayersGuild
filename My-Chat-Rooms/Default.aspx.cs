using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.MyChatRooms
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Master.PnlLeftCol.CssClass = "col-sm-3 col-xl-2";
            Master.PnlRightCol.CssClass = "col-sm-9 col-xl-10";
            if (Request.QueryString["msg"] == "submitcomplete")
            {
                pnlMessage.CssClass = "alert alert-success";
                pnlMessage.Visible = true;
                litMessage.Text = "Your chat room has been created. If this is your first chat room, you've also received a Chat Room Creator badge!";
            }

        }
        protected void rptChatRooms_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {

        }
        protected string GetTimeAgo(object TimeToCalculate)
        {
            if (TimeToCalculate.ToString() == "")
            { return "No Posts Made"; }
            return StringFunctions.ShowTimeAgo(TimeToCalculate.ToString());
        }

    }
}