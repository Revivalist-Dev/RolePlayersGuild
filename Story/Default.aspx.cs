using System;
using System.Web.UI;

namespace RolePlayersGuild.Story
{
    public partial class Default : System.Web.UI.Page
    {
        private int StoryID
        {
            get
            {
                if (ViewState["StoryID"] == null)
                {
                    return 0;
                }
                return ((int)ViewState["StoryID"]);
            }
            set { ViewState["StoryID"] = value; }
        }

        private void DisplayStoryInfo()
        {
            var parsedStoryId = 0;
            if (Request.QueryString["id"] == null || int.TryParse(Request.QueryString["id"], out parsedStoryId) == false)
            {
                Response.Redirect("/Story/List");
            }
            else
            {
                StoryID = parsedStoryId;

                var drStory = DataFunctions.Records.GetDataRow("SELECT * FROM [StoriesWithDetails] Where StoryID = @ParamOne", 0, StoryID);

                var userLoggedInIsBlocked = false;
                var userViewedIsBlocked = false;
                if (drStory == null)
                {
                    Response.Redirect("/Story/List");
                }
                else
                {
                    //if (bool.Parse(drStory["IsPrivate"].ToString()))
                    //{
                    //    lnkViewWriter.Visible = false;
                    //}
                    //else {
                    UserNav.ItemCreatorID = int.Parse(drStory["UserID"].ToString());

                    //}
                    if (int.Parse(drStory["UniverseID"].ToString()) == 0)
                    {
                        lnkViewUniverse.Visible = false;
                    }
                    else
                    {
                        lnkViewUniverse.NavigateUrl = "/Universe/?id=" + drStory["UniverseID"].ToString();
                    }
                    if (Session["UserID"] != null)
                    {
                        var viewedUserContent = int.Parse(drStory["UserID"].ToString());
                        var loggedInUser = (int)Session["UserID"];
                        var intBlockId = DataFunctions.Scalars.GetBlockRecordID(viewedUserContent, loggedInUser);
                        userViewedIsBlocked = (intBlockId != 0); //ViewedUser Is Blocked by LoggedInUser
                        userLoggedInIsBlocked = (DataFunctions.Scalars.GetBlockRecordID(loggedInUser, viewedUserContent) != 0);
                        if (CookieFunctions.IsStaff)
                        {
                            liAdminConsole.Visible = true;
                        }
                    }

                    if (userViewedIsBlocked)
                    {
                        pnlMessage.Visible = true;
                        pnlMessage.CssClass = "alert alert-danger";
                        litMessage.Text = "It seems you have blocked the owner of this Story. Unfortunately, this means that you will not be able to read it.";
                        pnlContent.Visible = false;
                    }
                    else if (userLoggedInIsBlocked)
                    {
                        pnlMessage.Visible = true;
                        pnlMessage.CssClass = "alert alert-danger";
                        litMessage.Text = "It seems you have been blocked by the owner of this Story. Unfortunately, this means that you will not be able to read it.";
                        pnlContent.Visible = false;
                    }
                    else
                    {
                        switch (drStory["ContentRatingID"].ToString())
                        {
                            case "1":
                                pnlRatingNotice.CssClass = "alert alert-info";
                                litRatingNotice.Text = "The content of this story carries a Teen Rating. Anything done outside of this rating is done at the risk of the deletion of your account.";
                                break;
                            case "2":
                                pnlRatingNotice.CssClass = "alert alert-warning";
                                litRatingNotice.Text = "The content of this story carries a Mature Rating. Anything done outside of this rating is done at the risk of the deletion of your account. If you are not old enough or do not desire to participate in a story with Mature content, please do not join this story.";
                                break;
                            case "3":
                                pnlRatingNotice.CssClass = "alert alert-danger";
                                litRatingNotice.Text = "The content of this story carries an Adults-Only Rating. If you are not old enough or do not desire to participate in a story with Adult content, please do not join this story.";
                                break;

                        }
                        litStoryTitle.Text = drStory["StoryTitle"].ToString();
                        aTwitterLink.Attributes["data-text"] = "Check out \"" + litStoryTitle.Text + "\" on #RPG!";
                        Page.Title = litStoryTitle.Text + " — Role-Players Guild";
                        Page.MetaDescription = "Check out \"" + litStoryTitle.Text + "\" on RPG today! The Role-Players Guild is a fast growing, custom-built role-play community open to writers of all types. If you're looking for the absolute best in role-play, join RPG!";

                        litStoryDescription.Text = drStory["StoryDescription"].ToString();
                    }
                }
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "linkifyStuffOnNewPage", "$('[data-linkify]').linkify({ target: '_blank', nl2br: true, format: function (value, type) { if (type === 'url' && value.length > 50) { value = value.slice(0, 50) + '…'; } return value; } });", true);
            DisplayStoryInfo();
            Master.PnlLeftCol.CssClass = "col-md-3 col-xl-2";
            Master.PnlRightCol.CssClass = "col-md-9 col-xl-10";
            if (Session["HideAds"] != null && Session["HideAds"].ToString() == "true")
            {
                divThreadAd.Visible = false;
            }
            UserNav.CurrentItemID = int.Parse(Request.QueryString["id"]);
        }
    }
}
