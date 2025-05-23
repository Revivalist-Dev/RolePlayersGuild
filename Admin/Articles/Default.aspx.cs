using HtmlAgilityPack;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.Admin.Articles
{
    public partial class Default : System.Web.UI.Page
    {
        public int SelectedArticleID
        {
            get
            {
                if (ViewState["SelectedArticleID"] != null)
                {
                    return (int)ViewState["SelectedArticleID"];
                }
                return 0;
            }
            set
            {
                ViewState["SelectedArticleID"] = value;
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!Page.IsPostBack)
            {
                int QueryStringValue;
                if (Request.QueryString["id"] != null && int.TryParse(Request.QueryString["id"], out QueryStringValue))
                { SelectedArticleID = QueryStringValue; }
                PopulateTools();
            }
        }
        protected void lbArticles_SelectedIndexChanged(object sender, EventArgs e)
        {
            SelectedArticleID = int.Parse(lbArticles.SelectedValue.ToString());
            PopulateTools();
        }
        void PopulateTools()
        {
            if (SelectedArticleID > 0)
            {
                DataRow TheArticle = DataFunctions.Records.GetArticleWithDetails(SelectedArticleID);

                if (TheArticle != null)
                {
                    divTools.Visible = true;
                    litTitle.Text = TheArticle["ArticleTitle"].ToString();
                    txtArticleTitle.Text = TheArticle["ArticleTitle"].ToString();
                    txtArticleContent.Text = TheArticle["ArticleContent"].ToString();
                    ddlRating.SelectedValue = TheArticle["ContentRatingID"].ToString();
                    ddlCategory.SelectedValue = TheArticle["CategoryID"].ToString();
                    chkDisableLinkify.Checked = (bool)TheArticle["DisableLinkify"];
                    lnkViewArticle.NavigateUrl = "/Article/?id=" + SelectedArticleID.ToString();
                    if (TheArticle["OwnerUserID"].ToString() != "0")
                    {
                        lnkOwnerLink.Visible = true;
                        lnkOwnerLink.NavigateUrl = "/Admin/Users/?id=" + TheArticle["OwnerUserID"].ToString();
                        lnkOwnerLink.Text = "Owned by: " + TheArticle["OwnerUserID"] + " - " + TheArticle["OwnerUserName"] + " &raquo;";
                    }
                }
                else
                {
                    Response.Redirect("/Admin/", true);
                }
            }
            else { divTools.Visible = false; }
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
                UpdateArticle();
                pnlMessage.Visible = true;
                pnlMessage.CssClass = "alert alert-success";
                litMessage.Text = "The changes have been saved.";
            }
        }
        protected void UpdateArticle()
        {
            DataFunctions.Updates.UpdateRow("UPDATE Articles SET ArticleTitle = @ParamTwo, ArticleContent = @ParamThree, ContentRatingID = @ParamFour, CategoryID = @ParamFive, DisableLinkify = @ParamSix WHERE (ArticleID = @ParamOne)",
                SelectedArticleID, txtArticleTitle.Text, txtArticleContent.Text, ddlRating.SelectedValue.ToString(),
                ddlCategory.SelectedValue, chkDisableLinkify.Checked);
            DataFunctions.Deletes.DeleteRows("Delete From [Article_Genres] Where ArticleID = @ParamOne", SelectedArticleID);

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
                scCharaGenreInsert.Parameters.AddWithValue("ArticleID", SelectedArticleID);
                DataFunctions.Inserts.InsertRow(scCharaGenreInsert);
            }

        }
        protected void btnDeleteArticle_Click(object sender, EventArgs e)
        {
            DataFunctions.Deletes.DeleteArticle(SelectedArticleID);
            Response.Redirect("/Admin/Articles/", false);
        }
        protected void cblGenres_DataBound(object sender, EventArgs e)
        {
            DataTable dtArticleGenres = DataFunctions.Tables.GetDataTable("Select * From [Article_Genres] Where ArticleID = @ParamOne", SelectedArticleID);

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

        }
    }
}