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
    public partial class EditUniverse : System.Web.UI.UserControl
    {
        private int UniverseID
        {
            get
            {
                if (ViewState["UniverseID"] == null)
                {
                    return 0;
                }
                return ((int)ViewState["UniverseID"]);
            }
            set
            {
                ViewState["UniverseID"] = value;
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
                            UniverseID = int.Parse(Request.QueryString["id"].ToString());
                            litTitle.Text = "Edit Universe";


                            DataRow TheUniverse = DataFunctions.Records.GetUniverseWithDetails(UniverseID);

                            if (TheUniverse != null && (int)TheUniverse["UniverseOwnerID"] == CookieFunctions.UserID)
                            {
                                txtUniverseName.Text = TheUniverse["UniverseName"].ToString();
                                txtUniverseDescription.Text = TheUniverse["UniverseDescription"].ToString();
                                ddlSource.SelectedValue = TheUniverse["SourceTypeID"].ToString();
                                ddlRating.SelectedValue = TheUniverse["ContentRatingID"].ToString();
                                chkDisableLinkify.Checked = (bool)TheUniverse["DisableLinkify"];
                                lnkViewUniverse.NavigateUrl = "/Universe/?id=" + UniverseID.ToString();
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
                        lnkViewUniverse.Visible = false;
                        lnkDeleteUniverse.Visible = false;
                        litTitle.Text = "New Universe";
                        Page.Title = "New Universe on RPG";


                        break;
                }
            }
        }

        protected void btnCreateUniverse_Click(object sender, EventArgs e)
        {

            HtmlDocument docVerseDesc = new HtmlDocument();
            docVerseDesc.LoadHtml(txtUniverseDescription.Text);
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
                        UpdateUniverse();
                        Response.Redirect("/My-Universes/");
                        break;
                    case "New":
                        int CurrentUserID = CookieFunctions.UserID;
                        UniverseID = DataFunctions.Inserts.CreateNewUniverse(CurrentUserID);
                        NotificationFunctions.SendMessageToStaff("[Staff] - New Universe Submitted", "A new universe has been submitted, <a href=\"/Admin/Universes/\">please review</a>.");
                        UpdateUniverse();
                        DataFunctions.AwardBadgeIfNotExisting(13, CurrentUserID);
                        Response.Redirect("/My-Universes/?msg=submitcomplete&type=" + ddlSource.SelectedValue.ToString());
                        break;
                }
            }
        }
        protected void UpdateUniverse()
        {

            //if (ddlSource.SelectedValue.ToString() == "1")
            //{
            DataFunctions.Updates.UpdateRow("UPDATE Universes SET UniverseName = @ParamTwo, UniverseDescription = @ParamThree, SourceTypeID = @ParamFour, RequiresApprovalOnJoin = @ParamFive, ContentRatingID = @ParamSix, DisableLinkify = @ParamSeven WHERE (UniverseID = @ParamOne)",
                UniverseID, txtUniverseName.Text, txtUniverseDescription.Text, ddlSource.SelectedValue, false, ddlRating.SelectedValue, chkDisableLinkify.Checked);
            //}
            //else if (ddlSource.SelectedValue.ToString() == "2")
            //{
            //    DataFunctions.Updates.UpdateRow("UPDATE Universes SET UniverseName = @ParamTwo, UniverseDescription = @ParamThree, SourceTypeID = @ParamFour, RequiresApprovalOnJoin = @ParamFive, ContentRatingID = @ParamSix, UniverseOwnerID = @ParamSeven, DisableLinkify = @ParamEight WHERE (UniverseID = @ParamOne)",
            //    UniverseID, txtUniverseName.Text, txtUniverseDescription.Text, ddlSource.SelectedValue, false, ddlRating.SelectedValue, 158, chkDisableLinkify.Checked);
            //}
            DataFunctions.Deletes.DeleteRows("Delete From [Universe_Genres] Where UniverseID = @ParamOne", UniverseID);

            SqlCommand scCharaGenreInsert = new SqlCommand();
            int GenreNumber = 0;
            foreach (ListItem chkGenre in cblGenres.Items)
            {
                if (chkGenre.Selected)
                {
                    GenreNumber += 1;
                    scCharaGenreInsert.CommandText += "INSERT INTO Universe_Genres (GenreID, UniverseID) VALUES (@Genre" + GenreNumber.ToString() + ", @UniverseID);";
                    scCharaGenreInsert.Parameters.AddWithValue("Genre" + GenreNumber.ToString(), chkGenre.Value);
                }
            }

            if (scCharaGenreInsert.CommandText.Length > 0)
            {
                scCharaGenreInsert.Parameters.AddWithValue("UniverseID", UniverseID);
                DataFunctions.Inserts.InsertRow(scCharaGenreInsert);
            }
        }
        protected void btnDeleteUniverse_Click(object sender, EventArgs e)
        {
            DataFunctions.Deletes.DeleteUniverse(UniverseID);
            Response.Redirect("/My-Universes/", false);
        }

        protected void cblGenres_DataBound(object sender, EventArgs e)
        {
            switch (ScreenStatus)
            {
                case "Edit":
                    DataTable dtUniverseGenres = DataFunctions.Tables.GetDataTable("Select * From [Universe_Genres] Where UniverseID = @ParamOne", UniverseID);

                    foreach (DataRow drGenre in dtUniverseGenres.Rows)
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