using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.MyGalleries
{
    public partial class Default : System.Web.UI.Page
    {
        protected string DisplayImageString(string imageString, string size)
        {
            return StringFunctions.DisplayImageString(imageString, size);
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            Master.PnlLeftCol.CssClass = "col-sm-3 col-xl-2";
            Master.PnlRightCol.CssClass = "col-sm-9 col-xl-10";
        }

        protected void lvGalleries_ItemDataBound(object sender, ListViewItemEventArgs e)
        {
            if (e.Item.ItemType == ListViewItemType.DataItem)
            {
                DataRowView drv = e.Item.DataItem as DataRowView;
                int UnreadImageCommentsCount = (int)drv["UnreadCommentCount"];
                if (UnreadImageCommentsCount > 0)
                {
                    HtmlGenericControl spanImageCommentBadge = (HtmlGenericControl)(e.Item.FindControl("spanImageCommentBadge"));
                    spanImageCommentBadge.Visible = true; spanImageCommentBadge.InnerText = UnreadImageCommentsCount.ToString();
                }

            }
        }
    }
}