using HtmlAgilityPack;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.templates.controls
{
    public partial class EditStory : System.Web.UI.UserControl
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
            set
            {
                ViewState["StoryID"] = value;
            }
        }
        public string ScreenStatus { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                switch (ScreenStatus)
                {
                    case "Edit":
                        if (Request.QueryString["id"] != null)
                        {
                            StoryID = int.Parse(Request.QueryString["id"].ToString());
                            litTitle.Text = "Edit Story";


                            DataRow TheStory = DataFunctions.Records.GetStoryWithDetails(StoryID);

                            if (TheStory != null && (int)TheStory["UserID"] == CookieFunctions.UserID)
                            {
                                txtStoryTitle.Text = TheStory["StoryTitle"].ToString();
                                txtStoryDescription.Text = TheStory["StoryDescription"].ToString();
                                ddlRating.SelectedValue = TheStory["ContentRatingID"].ToString();
                                chkPrivateStory.Checked = (bool)TheStory["IsPrivate"];
                                ddlUniverse.SelectedValue = TheStory["UniverseID"].ToString();
                                lnkViewStory.NavigateUrl = "/Story/?id=" + StoryID.ToString();
                            }
                            else
                            {
                                Response.Redirect("/", true);
                            }
                        }
                        else
                        {
                            Response.Redirect("/", true);
                        }
                        break;
                    case "New":
                        lnkViewStory.Visible = false;
                        lnkDeleteStory.Visible = false;
                        litTitle.Text = "New Story";
                        Page.Title = "New Story on RPG";


                        break;
                }
            }
        }

        protected void btnCreateStory_Click(object sender, EventArgs e)
        {
            HtmlDocument docVerseDesc = new HtmlDocument();
            docVerseDesc.LoadHtml(txtStoryDescription.Text);
            bool containsScript = docVerseDesc.DocumentNode.Descendants()
                .Where(node => node.Name == "script")
                .Any();
            if (containsScript)
            {
                pnlMessage.Visible = true;
                pnlMessage.CssClass = "alert alert-danger";
                litMessage.Text = "Script tags are not allowed.";
            }
            else
            {

                switch (ScreenStatus)
                {
                    case "Edit":
                        UpdateStory();
                        Response.Redirect("/My-Stories/");
                        break;
                    case "New":
                        int CurrentUserID = CookieFunctions.UserID;
                        StoryID = DataFunctions.Inserts.CreateNewStory(CurrentUserID);
                        UpdateStory();
                        DataFunctions.AwardBadgeIfNotExisting(34, CurrentUserID);
                        Response.Redirect("/My-Stories/?msg=submitcomplete");
                        break;
                }
            }
        }

        private void UpdateStory()
        {
            DataFunctions.Updates.UpdateRow("UPDATE Stories SET StoryTitle = @ParamTwo, StoryDescription = @ParamThree, ContentRatingID = @ParamFour, IsPrivate = @ParamFive, UniverseID = @ParamSix WHERE (StoryID = @ParamOne)",
                StoryID, txtStoryTitle.Text, txtStoryDescription.Text, ddlRating.SelectedValue.ToString(),
                chkPrivateStory.Checked, ddlUniverse.SelectedValue);
            DataFunctions.Deletes.DeleteRows("Delete From [Story_Genres] Where StoryID = @ParamOne", StoryID);

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
                scCharaGenreInsert.Parameters.AddWithValue("StoryID", StoryID);
                DataFunctions.Inserts.InsertRow(scCharaGenreInsert);
            }
        }
        protected void btnDeleteStory_Click(object sender, EventArgs e)
        {
            DataFunctions.Deletes.DeleteStory(StoryID);
            Response.Redirect("/My-Stories/", false);
        }
        protected void cblGenres_DataBound(object sender, EventArgs e)
        {
            switch (ScreenStatus)
            {
                case "Edit":
                    DataTable dtStoryGenres = DataFunctions.Tables.GetDataTable("Select * From [Story_Genres] Where StoryID = @ParamOne", StoryID);

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
                    break;
            }
        }
    }
}