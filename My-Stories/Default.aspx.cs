using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.MyStories
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
                litMessage.Text = "Your Story has been created!";                
            }

        }
        protected void rptStories_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView drv = e.Item.DataItem as DataRowView;
                int StoryID = int.Parse(drv.Row["StoryID"].ToString());
                Repeater rptGenres = (Repeater)(e.Item.FindControl("rptGenres"));

                sdsGenres.SelectParameters[0].DefaultValue = StoryID.ToString();
                rptGenres.DataSource = sdsGenres;
                rptGenres.DataBind();
            }
        }
    }
}