using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.MyQuickLinks
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Master.PnlLeftCol.CssClass = "col-sm-3 col-xl-2";
            Master.PnlRightCol.CssClass = "col-sm-9 col-xl-10";

            sdsQuickLinks.SelectParameters[0].DefaultValue = CookieFunctions.UserID.ToString();
            sdsQuickLinks.DataBind();
        }
        protected void btnAddQuickLink_Click(object sender, EventArgs e)
        {
            int orderNumber;
            if (int.TryParse(txtOrderNumber.Text, out orderNumber))
            {
                DataFunctions.Inserts.InsertRow("Insert Into QuickLinks (UserID, LinkName, LinkAddress, OrderNumber) Values (@ParamOne, @ParamTwo, @ParamThree, @ParamFour)", CookieFunctions.UserID, txtLinkName.Text, txtLinkURL.Text, txtOrderNumber.Text);
                pnlMessage.Visible = true;
                pnlMessage.CssClass = "alert alert-success";
                litMessage.Text = "<p>Your new Quick Link has been added!</p>";
                txtLinkName.Text = string.Empty;
                txtLinkURL.Text = string.Empty;
                txtOrderNumber.Text = string.Empty;
                rptQuickLinks.DataBind();
            }
            else
            {
                pnlMessage.Visible = true;
                pnlMessage.CssClass = "alert alert-success";
                litMessage.Text = "<p>Order Numbers must be numeric and can be positive or negative. Decimals are not allowed.</p>";
            }
        }

        protected void rptQuickLinks_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "DeleteQuickLink")
            {
                DataFunctions.Deletes.DeleteRows("Delete from QuickLinks Where QuickLinkID = @ParamOne", e.CommandArgument);
                rptQuickLinks.DataBind();
                pnlMessage.Visible = true;
                pnlMessage.CssClass = "alert alert-success";
                litMessage.Text = "The Quick Link has been removed.";
            }
        }
    }
}