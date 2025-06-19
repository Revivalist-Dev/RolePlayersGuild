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

namespace RolePlayersGuild.Admin.Universes
{
    public partial class Default : System.Web.UI.Page
    {
        int SelectedUniverseID
        {
            get
            {
                if (ViewState["SelectedUniverseID"] != null)
                {
                    return (int)ViewState["SelectedUniverseID"];
                }
                return 0;
            }
            set
            {
                ViewState["SelectedUniverseID"] = value;
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                int QueryStringValue;
                if (Request.QueryString["id"] != null && int.TryParse(Request.QueryString["id"], out QueryStringValue))
                {
                    SelectedUniverseID = QueryStringValue;
                    lbUniverses.SelectedValue = SelectedUniverseID.ToString();
                }
                PopulateTools();
            }
        }
        protected void Page_LoadComplete()
        {
        }
        protected void lbUniverses_SelectedIndexChanged(object sender, EventArgs e)
        {
            SelectedUniverseID = int.Parse(lbUniverses.SelectedValue.ToString());
            PopulateTools();
        }
        void PopulateTools()
        {
            if (SelectedUniverseID > 0)
            {
                divTools.Visible = true;
                sdsUniverses.DataBind();
                DataRow TheUniverse = DataFunctions.Records.GetUniverseWithDetails(SelectedUniverseID);
                txtUniverseName.Text = TheUniverse["UniverseName"].ToString();
                txtDescription.Text = TheUniverse["UniverseDescription"].ToString();
                chkApproved.Checked = (TheUniverse["StatusID"].ToString() == "1") ? false : true;
                ddlSource.SelectedValue = TheUniverse["SourceTypeID"].ToString();
                ddlRating.SelectedValue = TheUniverse["ContentRatingID"].ToString();

                lnkUniverse.NavigateUrl = "/Universe/?id=" + SelectedUniverseID.ToString();
                if (TheUniverse["UniverseOwnerID"].ToString() != "0")
                {
                    lnkOwnerLink.Visible = true;
                    lnkOwnerLink.NavigateUrl = "/Admin/Users/?id=" + TheUniverse["UniverseOwnerID"].ToString();
                    lnkOwnerLink.Text = "Owned by: " + TheUniverse["UniverseOwnerID"] + " - " + TheUniverse["UniverseOwnerName"] + " &raquo;";
                }
                else { lnkOwnerLink.Visible = false; }
                if (TheUniverse["SubmittedByID"].ToString() != "0")
                {
                    lnkSubmittedBy.Visible = true;
                    lnkSubmittedBy.NavigateUrl = "/Admin/Users/?id=" + TheUniverse["SubmittedByID"].ToString();
                    lnkSubmittedBy.Text = "Submitted by: " + TheUniverse["SubmittedByID"] + " - " + TheUniverse["SubmittedByName"] + " &raquo;";
                }
                else { lnkSubmittedBy.Visible = false; }
            }
            else { divTools.Visible = false; }
        }

        protected void lbUniverses_DataBound(object sender, EventArgs e)
        {
            if (SelectedUniverseID > 0) lbUniverses.SelectedValue = SelectedUniverseID.ToString();
            PopulateTools();
        }

        protected void btnSaveUniverse_Click(object sender, EventArgs e)
        {
            DataFunctions.Updates.UpdateRow("UPDATE Universes SET UniverseName = @ParamTwo, UniverseDescription = @ParamThree, SourceTypeID = @ParamFour, RequiresApprovalOnJoin = @ParamFive, ContentRatingID = @ParamSix, StatusID = @ParamSeven WHERE (UniverseID = @ParamOne)",
                SelectedUniverseID, txtUniverseName.Text, txtDescription.Text, ddlSource.SelectedValue, false, ddlRating.SelectedValue, (chkApproved.Checked) ? 2 : 1);

            DataFunctions.Deletes.DeleteRows("Delete From [Universe_Genres] Where UniverseID = @ParamOne", SelectedUniverseID);

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
                scCharaGenreInsert.Parameters.AddWithValue("UniverseID", SelectedUniverseID);
                DataFunctions.Inserts.InsertRow(scCharaGenreInsert);
            }

            pnlMessage.Visible = true;
            pnlMessage.CssClass = "alert alert-success";
            litMessage.Text = "The changes have been saved.";
            lbUniverses.DataBind();
        }
        protected void cblGenres_DataBound(object sender, EventArgs e)
        {
            DataTable dtUniverseGenres = DataFunctions.Tables.GetDataTable("Select * From [Universe_Genres] Where UniverseID = @ParamOne", SelectedUniverseID);
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
        }
        protected void btnDeleteUniverse_Click(object sender, EventArgs e)
        {
            DataFunctions.Deletes.DeleteUniverse(SelectedUniverseID);
            Response.Redirect("/Admin/Universes/", false);
        }
    }
}