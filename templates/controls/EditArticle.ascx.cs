using HtmlAgilityPack;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.IO;
using System.Linq;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.templates.controls
{
    public partial class EditArticle : System.Web.UI.UserControl
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
                            ArticleID = int.Parse(Request.QueryString["id"].ToString());
                            litTitle.Text = "Edit Article";


                            DataRow TheArticle = DataFunctions.Records.GetArticleWithDetails(ArticleID);

                            if (TheArticle != null && (int)TheArticle["OwnerUserID"] == CookieFunctions.UserID)
                            {
                                txtArticleTitle.Text = TheArticle["ArticleTitle"].ToString();
                                txtArticleContent.Text = TheArticle["ArticleContent"].ToString();
                                ddlRating.SelectedValue = TheArticle["ContentRatingID"].ToString();
                                chkPrivateArticle.Checked = (bool)TheArticle["IsPrivate"];
                                ddlCategory.SelectedValue = TheArticle["CategoryID"].ToString();
                                ddlUniverse.SelectedValue = TheArticle["UniverseID"].ToString();
                                chkDisableLinkify.Checked = (bool)TheArticle["DisableLinkify"];
                                lnkViewArticle.NavigateUrl = "/Article/?id=" + ArticleID.ToString();
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
                        lnkViewArticle.Visible = false;
                        lnkDeleteArticle.Visible = false;
                        litTitle.Text = "New Article";
                        Page.Title = "New Article on RPG";


                        break;
                }
            }
        }

        protected void btnCreateArticle_Click(object sender, EventArgs e)
        {

            HtmlDocument docVerseDesc = new HtmlDocument();
            docVerseDesc.LoadHtml(txtArticleContent.Text);
            bool containsScript = docVerseDesc.DocumentNode.Descendants()
                                                    .Where(node => node.Name == "script")
                                                    .Any();
            if (containsScript)
            {
                pnlMessage.Visible = true;
                pnlMessage.CssClass = "alert alert-danger";
                litMessage.Text = "Script tags are not allowed.";
            }
            else {
                switch (ScreenStatus)
                {
                    case "Edit":
                        UpdateArticle();
                        Response.Redirect("/My-Articles/");
                        break;
                    case "New":
                        int CurrentUserID = CookieFunctions.UserID;
                        ArticleID = DataFunctions.Inserts.CreateNewArticle(CurrentUserID);
                        UpdateArticle();
                        DataFunctions.AwardBadgeIfNotExisting(28, CurrentUserID);
                        Response.Redirect("/My-Articles/?msg=submitcomplete");
                        break;
                }
            }
        }
        protected void UpdateArticle()
        {
            DataFunctions.Updates.UpdateRow("UPDATE Articles SET ArticleTitle = @ParamTwo, ArticleContent = @ParamThree, ContentRatingID = @ParamFour, IsPrivate = @ParamFive, CategoryID = @ParamSix, DisableLinkify = @ParamSeven, UniverseID = @ParamEight WHERE (ArticleID = @ParamOne)",
                ArticleID, txtArticleTitle.Text, txtArticleContent.Text, ddlRating.SelectedValue.ToString(), 
                chkPrivateArticle.Checked, ddlCategory.SelectedValue, chkDisableLinkify.Checked, ddlUniverse.SelectedValue);
            DataFunctions.Deletes.DeleteRows("Delete From [Article_Genres] Where ArticleID = @ParamOne", ArticleID);

            SqlCommand scCharaGenreInsert = new SqlCommand();
            int GenreNumber = 0;
            foreach (ListItem chkGenre in cblGenres.Items)
            {
                if (chkGenre.Selected)
                {
                    GenreNumber += 1;
                    scCharaGenreInsert.CommandText += "INSERT INTO Article_Genres (GenreID, ArticleID) VALUES (@Genre" + GenreNumber.ToString() + ", @ArticleID);";
                    scCharaGenreInsert.Parameters.AddWithValue("Genre" + GenreNumber.ToString(), chkGenre.Value);
                }
            }

            if (scCharaGenreInsert.CommandText.Length > 0)
            {
                scCharaGenreInsert.Parameters.AddWithValue("ArticleID", ArticleID);
                DataFunctions.Inserts.InsertRow(scCharaGenreInsert);
            }
        }
        protected void btnDeleteArticle_Click(object sender, EventArgs e)
        {
            DataFunctions.Deletes.DeleteArticle(ArticleID);
            Response.Redirect("/My-Articles/", false);
        }
        protected void cblGenres_DataBound(object sender, EventArgs e)
        {
            switch (ScreenStatus)
            {
                case "Edit":
                    DataTable dtArticleGenres = DataFunctions.Tables.GetDataTable("Select * From [Article_Genres] Where ArticleID = @ParamOne", ArticleID);

                    foreach (DataRow drGenre in dtArticleGenres.Rows)
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