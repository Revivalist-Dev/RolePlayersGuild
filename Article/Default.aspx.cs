using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.Article
{
    public partial class Default : System.Web.UI.Page
    {
        private int ArticleID
        {
            get
            {
                if (ViewState["ArticleID"] == null)
                {
                    return 0;
                }
                return ((int)ViewState["ArticleID"]);
            }
            set
            {
                ViewState["ArticleID"] = value;
            }
        }
        private void DisplayArticleInfo()
        {
            int ParsedArticleID = 0;
            if (Request.QueryString["id"] == null || int.TryParse(Request.QueryString["id"], out ParsedArticleID) == false)
            {
                Response.Redirect("/Article/List");
            }
            else
            {
                ArticleID = ParsedArticleID;

                DataRow drArticle = DataFunctions.Records.GetDataRow("SELECT * FROM [ArticlesWithDetails] Where ArticleID = @ParamOne", 0, ArticleID);

                int intBlockID = 0;

                bool UserLoggedInIsBlocked = false;
                bool UserViewedIsBlocked = false;
                if (drArticle == null)
                {
                    Response.Redirect("/Article/List");
                }
                else
                {
                    if (bool.Parse(drArticle["IsPrivate"].ToString()))
                    {
                        lnkViewWriter.Visible = false;
                    }
                    else {
                        lnkViewWriter.NavigateUrl = "/Writer/?id=" + drArticle["OwnerUserID"].ToString();
                    }
                    if (int.Parse(drArticle["UniverseID"].ToString()) == 0)
                    {
                        lnkViewUniverse.Visible = false;
                    }
                    else
                    {
                        lnkViewUniverse.NavigateUrl = "/Universe/?id=" + drArticle["UniverseID"].ToString();
                    }
                    if (Session["UserID"] != null)
                    {
                        int ViewedUserContent = int.Parse(drArticle["OwnerUserID"].ToString());
                        int LoggedInUser = (int)Session["UserID"];
                        intBlockID = DataFunctions.Scalars.GetBlockRecordID(ViewedUserContent, LoggedInUser);
                        UserViewedIsBlocked = (intBlockID != 0); //ViewedUser Is Blocked by LoggedInUser
                        UserLoggedInIsBlocked = (DataFunctions.Scalars.GetBlockRecordID(LoggedInUser, ViewedUserContent) != 0);
                        if (CookieFunctions.IsStaff)
                        {
                            liAdminConsole.Visible = true;
                        }
                    }
                    if (!UserViewedIsBlocked && !UserLoggedInIsBlocked)
                    {
                        litArticleTitle.Text = drArticle["ArticleTitle"].ToString();
                        aTwitterLink.Attributes["data-text"] = "Check out \"" + litArticleTitle.Text + "\" on #RPG!";
                        Page.Title = litArticleTitle.Text + " — Role-Players Guild";
                        Page.MetaDescription = "Check out \"" + litArticleTitle.Text + "\" on RPG today! The Role-Players Guild is a fast growing, custom-built role-play community open to writers of all types. If you're looking for the absolute best in role-play, join RPG!";

                        litArticleContent.Text = drArticle["ArticleContent"].ToString();

                        if (!((bool)drArticle["DisableLinkify"]))
                        {
                            divArticleContentContainer.Attributes["data-linkify"] = " ";
                            divArticleContentContainer.Attributes["class"] = "StyledArticle";
                        }
                    }
                    else if (UserViewedIsBlocked)
                    {
                        pnlMessage.Visible = true;
                        pnlMessage.CssClass = "alert alert-danger";
                        litMessage.Text = "It seems you have blocked the owner of this Article. Unfortunately, this means that you will not be able to read it.";
                        pnlContent.Visible = false;
                    }
                    else if (UserLoggedInIsBlocked)
                    {
                        pnlMessage.Visible = true;
                        pnlMessage.CssClass = "alert alert-danger";
                        litMessage.Text = "It seems you have been blocked by the owner of this Article. Unfortunately, this means that you will not be able to read it.";
                        pnlContent.Visible = false;
                    }
                }
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "linkifyStuffOnNewPage", "$('[data-linkify]').linkify({ target: '_blank', nl2br: true, format: function (value, type) { if (type === 'url' && value.length > 50) { value = value.slice(0, 50) + '…'; } return value; } });", true);
            DisplayArticleInfo();

        }
    }
}
