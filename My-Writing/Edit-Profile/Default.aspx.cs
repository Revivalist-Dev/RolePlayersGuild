using HtmlAgilityPack;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.MyWriting.EditProfile
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Master.PnlLeftCol.CssClass = "col-sm-3 col-xl-2";
            Master.PnlRightCol.CssClass = "col-sm-9 col-xl-10";
            lnkViewProfile.NavigateUrl = "/Writer?id=" + CookieFunctions.UserID;
            if (!Page.IsPostBack)
            {
                txtAboutMe.Text = DataFunctions.Scalars.GetSingleValue("Select AboutMe From Users Where UserID = @ParamOne", CookieFunctions.UserID).ToString();
            }
        }

        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            HtmlDocument docAboutMe = new HtmlDocument();
            docAboutMe.LoadHtml(txtAboutMe.Text);
            bool containsScript = docAboutMe.DocumentNode.Descendants()
                                                   .Where(node => node.Name == "script")
                                                   .Any();
            if (containsScript)
            {
                pnlMessage.Visible = true;
                pnlMessage.CssClass = "alert alert-danger";
                litMessage.Text = "Script tags are not allowed.";
            }
            else {
                DataFunctions.RunStatement("UPDATE Users SET AboutMe = @ParamTwo WHERE (UserID = @ParamOne)", CookieFunctions.UserID, txtAboutMe.Text);
                litMessage.Text = "Profile Updated";
                pnlMessage.Visible = true;
                pnlMessage.CssClass = "alert alert-success";
            }
        }
    }
}