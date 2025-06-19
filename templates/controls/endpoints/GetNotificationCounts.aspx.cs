using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.templates.controls.endpoints
{
    public partial class GetNotificationCounts : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.Form["UserID"] == null)
            {
                Response.StatusDescription = "Bad Request";
                Response.StatusCode = 500;
            }
            else
            {
                int UnreadThreadsCount = DataFunctions.Scalars.GetUnreadThreadCount(Request.Form["UserID"]);
                if (UnreadThreadsCount > 0)
                { spanThreadBadge.Visible = true; spanThreadBadge.InnerText = UnreadThreadsCount.ToString(); }

                int UnreadImageCommentsCount = DataFunctions.Scalars.GetUnreadImageCommentCountByUserID(Request.Form["UserID"]);
                if (UnreadImageCommentsCount > 0)
                { spanImageCommentBadge.Visible = true; spanImageCommentBadge.InnerText = UnreadImageCommentsCount.ToString(); }
            }
        }
    }
}