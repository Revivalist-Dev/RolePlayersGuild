using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net; // ADDED for the URL check
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.MyQuickLinks
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Hide the message panel on each page load
            pnlMessage.Visible = false;

            if (!IsPostBack)
            {
                Master.PnlLeftCol.CssClass = "col-sm-3 col-xl-2";
                Master.PnlRightCol.CssClass = "col-sm-9 col-xl-10";
                sdsQuickLinks.SelectParameters[0].DefaultValue = CookieFunctions.UserID.ToString();
                sdsQuickLinks.DataBind();
            }
        }

        // START: NEW HELPER METHOD FOR URL VALIDATION
        private bool IsUrlValid(string url)
        {
            // Treat internal site URLs starting with "/" as valid without making a web request.
            if (url.StartsWith("/"))
            {
                // A more advanced check could use Server.MapPath to see if a file exists,
                // but this is sufficient for preventing basic 404s on broken links.
                return true;
            }

            // For external URLs, ensure they have a protocol and are reachable.
            if (!url.ToLower().StartsWith("http://") && !url.ToLower().StartsWith("https://"))
            {
                url = "http://" + url; // Assume http for the validation check
            }

            if (!Uri.IsWellFormedUriString(url, UriKind.Absolute))
            {
                return false;
            }

            try
            {
                HttpWebRequest request = WebRequest.Create(url) as HttpWebRequest;
                request.Method = "HEAD"; // Use HEAD for an efficient check
                using (HttpWebResponse response = request.GetResponse() as HttpWebResponse)
                {
                    return response.StatusCode == HttpStatusCode.OK;
                }
            }
            catch (WebException)
            {
                // URL is not reachable (404, DNS error, etc.)
                return false;
            }
        }
        // END: NEW HELPER METHOD

        protected void btnAddQuickLink_Click(object sender, EventArgs e)
        {
            int orderNumber;
            if (int.TryParse(txtOrderNumber.Text, out orderNumber))
            {
                // *** START: URL VALIDATION LOGIC ***
                if (!IsUrlValid(txtLinkURL.Text))
                {
                    pnlMessage.Visible = true;
                    pnlMessage.CssClass = "alert alert-danger"; // Use danger class for errors
                    litMessage.Text = "<p>The provided URL is invalid or unreachable. Please correct it and try again.</p>";
                    return; // Stop the process
                }
                // *** END: URL VALIDATION LOGIC ***

                // If validation passes, proceed with saving the link
                DataFunctions.Inserts.InsertRow("Insert Into QuickLinks (UserID, LinkName, LinkAddress, OrderNumber) Values (@ParamOne, @ParamTwo, @ParamThree, @ParamFour)", CookieFunctions.UserID, txtLinkName.Text, txtLinkURL.Text, orderNumber);
                pnlMessage.Visible = true;
                pnlMessage.CssClass = "alert alert-success";
                litMessage.Text = "<p>Your new Quick Link has been added!</p>";
                
                // Clear inputs and refresh the list
                txtLinkName.Text = string.Empty;
                txtLinkURL.Text = string.Empty;
                txtOrderNumber.Text = "0"; // Reset order number to default
                rptQuickLinks.DataBind();
            }
            else
            {
                pnlMessage.Visible = true;
                pnlMessage.CssClass = "alert alert-danger"; // Use danger class for errors
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