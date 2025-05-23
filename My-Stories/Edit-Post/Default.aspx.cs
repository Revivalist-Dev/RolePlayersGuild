using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
// ReSharper disable Html.PathError
// ReSharper disable ArrangeAccessorOwnerBody

namespace RolePlayersGuild.My_Stories.Edit_Post
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
        private int PostID
        {
            get
            {
                if (ViewState["PostID"] == null)
                {
                    return 0;
                }
                return ((int)ViewState["PostID"]);
            }
            set { ViewState["PostID"] = value; }
        }
        private int OwnerUserID
        {
            get
            {
                if (ViewState["OwnerUserID"] == null)
                {
                    return 0;
                }
                return ((int)ViewState["OwnerUserID"]);
            }
            set { ViewState["OwnerUserID"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Page.IsPostBack) return;
            var parsedPostId = 0;
            if (Request.QueryString["PostID"] == null || int.TryParse(Request.QueryString["PostID"], out parsedPostId) == false)
            {
                Response.Redirect("/Story/List");
            }
            PostID = parsedPostId;
            var drStoryPost = DataFunctions.Records.GetDataRow("Select * From Story_Posts Where StoryPostID = @ParamOne", 0, PostID);

            if (drStoryPost == null)
            {
                Response.Redirect("/Story/List");
            }

            var characterCount =
                DataFunctions.Scalars.GetSingleValue(
                    "Select Count(CharacterID) From Characters Where CharacterID = @ParamOne AND UserID = @ParamTwo",
                    drStoryPost["CharacterID"], Session["UserID"]);

            if (int.Parse(characterCount.ToString()) == 0) Response.Redirect("/Story/List/");

            StoryID = int.Parse(drStoryPost["StoryID"].ToString());
            var drStory = DataFunctions.Records.GetDataRow("Select * From Stories Where StoryID = @ParamOne", 0, drStoryPost["StoryID"]);

            if (drStory == null)
            {
                Response.Redirect("/Story/List");
            }
            Master.PnlLeftCol.CssClass = "col-md-3 col-xl-2";
            Master.PnlRightCol.CssClass = "col-md-9 col-xl-10";
            if (Session["HideAds"] != null && Session["HideAds"].ToString() == "true")
            {
                divThreadAd.Visible = false;
            }

            txtPostContent.Text = drStoryPost["PostContent"].ToString();
            DataFunctions.CurrentSendAsCharacterID = int.Parse(drStoryPost["CharacterID"].ToString());
            UserNav.CurrentItemID = int.Parse(drStoryPost["StoryID"].ToString());
            UserNav.ItemCreatorID = int.Parse(drStory["UserID"].ToString());
        }
        protected void btnSubmitPost_Click(object sender, EventArgs e)
        {
            if (txtPostContent.Text.Trim().Length > 0)
            {
                DataFunctions.Updates.UpdateRow("UPDATE Story_Posts SET CharacterID = @ParamOne, PostContent = @ParamTwo WHERE (StoryPostID = @ParamThree)", DataFunctions.CurrentSendAsCharacterID, txtPostContent.Text, PostID);
            }
            txtPostContent.Text = "";

            Response.Redirect("/Story/Posts/?storyid=" + StoryID);
        }
    }
}