using System;
using System.Data;

namespace RolePlayersGuild.Admin.FundingGoal
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (CookieFunctions.UserTypeID != 3)
            { Response.Redirect("/"); }
            if (!Page.IsPostBack)
            {
                txtWeAreAt.Text = DataFunctions.Scalars.GetSingleValue("Select RPG2FundingGoal From General_Settings").ToString();
            }
        }
        protected void Button1_Click(object sender, EventArgs e)
        {
            if (txtWeAreAt.Text.Length > 0)
            {
                DataFunctions.RunStatement("Update General_Settings Set RPG2FundingGoal = @ParamOne", txtWeAreAt.Text);
                pnlMessage.CssClass = "alert alert-success";
                pnlMessage.Visible = true;
                litMessage.Text = "Yay, you did it. Want a cookie? Too bad, <a href=\"/My-Dashboard/\">go make sure you did it right</a>.";
            }
            else
            {
                pnlMessage.CssClass = "alert alert-danger";
                pnlMessage.Visible = true;
                litMessage.Text = "Stop trying to save a blank page...";
            }
        }
    }
}