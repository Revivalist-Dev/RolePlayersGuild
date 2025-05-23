using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.Admin.Stories
{
    public partial class Default : System.Web.UI.Page
    {
        public int SelectedStoryID
        {
            get
            {
                if (ViewState["SelectedStoryID"] != null)
                {
                    return (int)ViewState["SelectedStoryID"];
                }
                return 0;
            }
            set
            {
                ViewState["SelectedStoryID"] = value;
            }
        }
        public string ScreenStatus { get; set; }
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            var storyId = 0;

            if (!int.TryParse(txtStoryID.Text, out storyId)) return;
            ViewState["SelectedUserID"] = null;
            SelectedStoryID = storyId;
            PopulateTools();
        }
        void PopulateTools()
        {
            if (SelectedStoryID > 0)
            {
                DataRow TheStory = DataFunctions.Records.GetStoryWithDetails(SelectedStoryID);
                if (TheStory != null)
                {
                    txtStoryTitle.Text = TheStory["StoryTitle"].ToString();
                    txtStoryDescription.Text = TheStory["StoryDescription"].ToString();
                    ddlRating.SelectedValue = TheStory["ContentRatingID"].ToString();
                    chkPrivateStory.Checked = (bool)TheStory["IsPrivate"];
                    ddlUniverse.SelectedValue = TheStory["UniverseID"].ToString();
                    lnkViewStory.NavigateUrl = "/Story/?id=" + SelectedStoryID.ToString();

                    divTools.Visible = true;
                    lnkOwnerLink.NavigateUrl = "/Admin/Users?id=" + TheStory["UserID"].ToString();
                }
                else
                {
                    pnlMessage.Visible = true;
                    pnlMessage.CssClass = "alert alert-danger";
                    litMessage.Text = "No character with that ID.";
                }
                //ddlCharacterType.SelectedValue = SelectedCharacter["TypeID"].ToString();
            }
            else { divTools.Visible = false; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                int QueryStringValue;
                if (Request.QueryString["id"] != null && int.TryParse(Request.QueryString["id"], out QueryStringValue))
                {
                    SelectedStoryID = QueryStringValue;
                    txtStoryID.Text = QueryStringValue.ToString();
                }
                PopulateTools();
            }
        }

        protected void btnCreateStory_Click(object sender, EventArgs e)
        {


            switch (ScreenStatus)
            {
                case "Edit":
                    UpdateStory();
                    Response.Redirect("/My-Stories/");
                    break;
                case "New":
                    int CurrentUserID = CookieFunctions.UserID;
                    SelectedStoryID = DataFunctions.Inserts.CreateNewStory(CurrentUserID);
                    UpdateStory();
                    DataFunctions.AwardBadgeIfNotExisting(34, CurrentUserID);
                    Response.Redirect("/My-Stories/?msg=submitcomplete");
                    break;
            }
        }

        private void UpdateStory()
        {
            DataFunctions.Updates.UpdateRow("UPDATE Stories SET StoryTitle = @ParamTwo, StoryDescription = @ParamThree, ContentRatingID = @ParamFour, IsPrivate = @ParamFive, UniverseID = @ParamSix WHERE (StoryID = @ParamOne)",
                SelectedStoryID, txtStoryTitle.Text, HttpUtility.HtmlEncode(txtStoryDescription.Text), ddlRating.SelectedValue.ToString(),
                chkPrivateStory.Checked, ddlUniverse.SelectedValue);
            DataFunctions.Deletes.DeleteRows("Delete From [Story_Genres] Where StoryID = @ParamOne", SelectedStoryID);

            SqlCommand scCharaGenreInsert = new SqlCommand();
            int GenreNumber = 0;
            foreach (ListItem chkGenre in cblGenres.Items)
            {
                if (chkGenre.Selected)
                {
                    GenreNumber += 1;
                    scCharaGenreInsert.CommandText += "INSERT INTO Story_Genres (GenreID, StoryID) VALUES (@Genre" + GenreNumber.ToString() + ", @StoryID);";
                    scCharaGenreInsert.Parameters.AddWithValue("Genre" + GenreNumber.ToString(), chkGenre.Value);
                }
            }

            if (scCharaGenreInsert.CommandText.Length > 0)
            {
                scCharaGenreInsert.Parameters.AddWithValue("StoryID", SelectedStoryID);
                DataFunctions.Inserts.InsertRow(scCharaGenreInsert);
            }
        }
        protected void btnDeleteStory_Click(object sender, EventArgs e)
        {
            DataFunctions.Deletes.DeleteStory(SelectedStoryID);
            Response.Redirect("/Admin/Stories/", false);
        }
        protected void cblGenres_DataBound(object sender, EventArgs e)
        {
            DataTable dtStoryGenres = DataFunctions.Tables.GetDataTable("Select * From [Story_Genres] Where StoryID = @ParamOne", SelectedStoryID);

            foreach (DataRow drGenre in dtStoryGenres.Rows)
            {
                cblGenres.Items.FindByValue(drGenre["GenreID"].ToString()).Selected = true;
            }
            string SelectedGenreList = "";
            foreach (ListItem chkGenre in cblGenres.Items)
            {
                if (chkGenre.Selected)
                {
                    SelectedGenreList += chkGenre.Text + ", ";
                }
            }
        }
    }
}