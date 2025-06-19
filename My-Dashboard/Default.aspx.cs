using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.ServiceModel.Syndication;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

namespace RolePlayersGuild.MyDashboard
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (CookieFunctions.IsStaff)
            {
                int NumberOfOpenItems = (int)DataFunctions.Scalars.GetSingleValue("Select Count(ItemID) From ToDo_Items Where AssignedToUserID = @ParamOne AND (StatusID = 1)", CookieFunctions.UserID);

                if (NumberOfOpenItems > 0)
                {
                    divAdminNotic.Visible = true;
                    divAdminNotic.InnerHtml = "<p> You have " + NumberOfOpenItems.ToString() + " Open ToDo Items assigned to you. Please review them.</p>";
                }

            }

            Master.PnlLeftCol.CssClass = "col-sm-3 col-xl-2";
            Master.PnlRightCol.CssClass = "col-sm-9 col-xl-10";

            CookieFunctions.RefreshCookies();

            //litTipsAndTricks.Text = DataFunctions.Scalars.GetSingleValue("Select Top 1 TipContent from Tips Order By NewID();").ToString();

            //string url = "http://blog.roleplayersguild.com/feed";
            //XmlReader reader = XmlReader.Create(url);
            //SyndicationFeed feed = SyndicationFeed.Load(reader);
            //reader.Close();

            //rptBlogPosts.DataSource = feed.Items.Take(3).OrderBy(p => p.PublishDate).ToList();
            //rptBlogPosts.DataBind();
            var goalProgress = DataFunctions.Scalars.GetSingleValue("Select RPG2FundingGoal From General_Settings").ToString();

            litAtDollarAmount.Text = goalProgress;
            if (goalProgress != "0.00")
            {
                decimal decOne = 400 / decimal.Parse(goalProgress);
                decimal decTwo = 100 / decOne;
                if (decTwo < 100)
                {
                    divProgressBar.Attributes.Add("style", "height: 2em; width: " + decTwo + "%; background: green;");
                }
                else
                {
                    divProgressBar.Attributes.Add("style", "height: 2em; width: 100%; background: gold;");
                }
            }
        }
        protected string GetTimeAgo(string TimeToCalculate)
        {
            return StringFunctions.ShowTimeAgo(TimeToCalculate);
        }
        protected string CurrentUserID()
        {
            int returnValue = CookieFunctions.UserID;

            if (returnValue == 0)
            { btnDonate.Text = "Make Anonymous Donation via PayPal"; }

            return returnValue.ToString();
        }
    }
}