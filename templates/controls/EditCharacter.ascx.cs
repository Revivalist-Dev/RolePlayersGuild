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
    public partial class EditCharacter : System.Web.UI.UserControl
    {
        private int CurrentAssignedUserBadge
        {
            get
            {
                if (ViewState["CurrentAssignedUserBadge"] == null)
                {
                    return 0;
                }
                return ((int)ViewState["CurrentAssignedUserBadge"]);
            }
            set
            {
                ViewState["CurrentAssignedUserBadge"] = value;
            }
        }
        private int CharacterID
        {
            get
            {
                if (ViewState["CharacterID"] == null)
                {
                    return 0;
                }
                return ((int)ViewState["CharacterID"]);
            }
            set
            {
                ViewState["CharacterID"] = value;
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
                        if (Request.QueryString["CharID"] != null)
                        {
                            aCustomizeProfile.Visible = true;
                            aCustomizeProfile.HRef = "/My-Characters/Edit-Character/Custom-Profile?CharID=" + Request.QueryString["CharID"].ToString();

                            lnkAddPhoto.NavigateUrl = "/My-Galleries/Edit-Gallery?Mode=New&GalleryID=" + Request.QueryString["CharID"].ToString();
                            lnkAddPhoto.Visible = true;

                            CharacterID = int.Parse(Request.QueryString["CharID"].ToString());
                            litTitle.Text = "Edit Character";

                            DataRow drCharacter = DataFunctions.Records.GetDataRow("SELECT * FROM [Characters] Where CharacterID = @ParamOne", 0, CharacterID);

                            if (drCharacter != null && (int)drCharacter["UserID"] == CookieFunctions.UserID)
                            {
                                txtDisplayName.Text = drCharacter["CharacterDisplayName"].ToString();
                                txtCharacterFirstName.Text = drCharacter["CharacterFirstName"].ToString();
                                txtCharacterMiddleName.Text = drCharacter["CharacterMiddleName"].ToString();
                                txtCharacterLastName.Text = drCharacter["CharacterLastName"].ToString();
                                txtBackground.Text = drCharacter["CharacterBio"].ToString();
                                //txtRecentEvents.Text = drCharacter["RecentEvents"].ToString();
                                //txtOtherInfo.Text = drCharacter["OtherInfo"].ToString();
                                ddlGender.SelectedValue = drCharacter["CharacterGender"].ToString();
                                ddlLiteracyLevel.SelectedValue = drCharacter["LiteracyLevel"].ToString();
                                ddlPostLengthMaximum.SelectedValue = drCharacter["PostLengthMax"].ToString();
                                ddlPostLengthMinimum.SelectedValue = drCharacter["PostLengthMin"].ToString();
                                ddlEroticaPreferences.SelectedValue = drCharacter["EroticaPreferences"].ToString();
                                ddlSexualOrientation.SelectedValue = drCharacter["SexualOrientation"].ToString();
                                ddlSource.SelectedValue = drCharacter["CharacterSourceID"].ToString();
                                chkMatureContent.Checked = (bool)drCharacter["MatureContent"];
                                ddlLFRP.SelectedValue = drCharacter["LFRPStatus"].ToString();
                                chkPrivateCharacter.Checked = (bool)drCharacter["IsPrivate"];
                                chkDisableLinkify.Checked = (bool)drCharacter["DisableLinkify"];

                                Page.Title = "Editing " + drCharacter["CharacterDisplayName"].ToString() + " on RPG";

                                pnlProfileImage.Visible = false;
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
                        lnkDeleteCharacter.Visible = false;
                        litTitle.Text = "New Character";
                        Page.Title = "New Character on RPG";


                        break;
                }
            }
        }

        protected void btnCreateCharacter_Click(object sender, EventArgs e)
        {
            //bool containsHTML = false;
            //HtmlDocument badDoc = new HtmlDocument();
            //badDoc.LoadHtml(txtBackground.Text + txtRecentEvents.Text);
            //containsHTML = badDoc.DocumentNode.Descendants()
            //                                        .Where(node => node.NodeType == HtmlNodeType.Element)
            //                                        .Select(node => node.Name)
            //                                        .Any();

            HtmlDocument otherBioDoc = new HtmlDocument();
            otherBioDoc.LoadHtml(txtBackground.Text);
            bool containsScript = otherBioDoc.DocumentNode.Descendants()
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
                        //int CurrentCharacterID = CharacterID;
                        //DataFunctions.Updates.UpdateCharacter(txtDisplayName.Text, txtBackground.Text, int.Parse(ddlGender.SelectedValue), int.Parse(ddlLiteracyLevel.SelectedValue), MaximumPostLength, MinimumPostLength, chkMatureContent.Checked, txtCharacterFirstName.Text, txtCharacterMiddleName.Text, txtCharacterLastName.Text, int.Parse(ddlSexualOrientation.SelectedValue), int.Parse(ddlEroticaPreferences.SelectedValue), CurrentCharacterID);
                        UpdateCharacter();
                        Response.Redirect("/My-Characters/");
                        break;
                    case "New":
                        //var rpgCharacters = new rpgDBTableAdapters.CharactersTableAdapter();
                        int CurrentUserID = CookieFunctions.UserID;
                        CharacterID = DataFunctions.Inserts.CreateNewCharacter(CurrentUserID);
                        //DataFunctions.Updates.UpdateCharacter(txtDisplayName.Text, txtBackground.Text, int.Parse(ddlGender.SelectedValue), int.Parse(ddlLiteracyLevel.SelectedValue), MaximumPostLength, MinimumPostLength, chkMatureContent.Checked, txtCharacterFirstName.Text, txtCharacterMiddleName.Text, txtCharacterLastName.Text, int.Parse(ddlSexualOrientation.SelectedValue), int.Parse(ddlEroticaPreferences.SelectedValue), NewCharacterID);
                        UpdateCharacter();
                        DataFunctions.AwardBadgeIfNotExisting(27, CurrentUserID);
                        string ImagePath = ImageFunctions.UploadImage(fuCharacterProfileImage);
                        if (ImagePath.Length > 0)
                        {
                            //var rpgCharacterImages = new rpgDBTableAdapters.Character_ImagesTableAdapter();
                            DataFunctions.Inserts.AddImage(ImagePath, CharacterID, true, false, "");
                        }
                        Response.Redirect("/My-Characters/");
                        break;
                }
            }
        }
        protected void UpdateCharacter()
        {
            int MaximumPostLength = int.Parse(ddlPostLengthMaximum.SelectedValue);
            int MinimumPostLength = int.Parse(ddlPostLengthMinimum.SelectedValue);

            if (MaximumPostLength == 0 || MinimumPostLength == 0)
            {
                //Do Nothing
            }
            else if (MinimumPostLength > MaximumPostLength)
            {
                MaximumPostLength = int.Parse(ddlPostLengthMinimum.SelectedValue);
                MinimumPostLength = int.Parse(ddlPostLengthMaximum.SelectedValue);
            }

            DataFunctions.Updates.UpdateRow("UPDATE Characters SET CharacterDisplayName = @ParamTwo, CharacterBio = @ParamThree, CharacterGender = @ParamFour, LiteracyLevel = @ParamFive, PostLengthMax = @ParamSix, PostLengthMin = @ParamSeven, MatureContent = @ParamEight, CharacterFirstName = @ParamNine, CharacterMiddleName = @ParamTen, CharacterLastName = @ParamEleven, SexualOrientation = @ParamTwelve, EroticaPreferences = @ParamThirteen, CharacterSourceID = @ParamFourteen, LFRPStatus = @ParamFifteen, IsPrivate = @ParamSixteen, DisableLinkify = @ParamSeventeen WHERE (CharacterID = @ParamOne)",
                CharacterID, txtDisplayName.Text, txtBackground.Text, int.Parse(ddlGender.SelectedValue),
                int.Parse(ddlLiteracyLevel.SelectedValue), MaximumPostLength, MinimumPostLength,
                chkMatureContent.Checked, txtCharacterFirstName.Text, txtCharacterMiddleName.Text,
                txtCharacterLastName.Text, int.Parse(ddlSexualOrientation.SelectedValue),
                int.Parse(ddlEroticaPreferences.SelectedValue), int.Parse(ddlSource.SelectedValue),
                int.Parse(ddlLFRP.SelectedValue), chkPrivateCharacter.Checked, chkDisableLinkify.Checked);

            DataFunctions.Deletes.DeleteRows("Delete From [Character_Genres] Where CharacterID = @ParamOne", CharacterID);

            SqlCommand scCharaGenreInsert = new SqlCommand();
            int GenreNumber = 0;
            foreach (ListItem chkGenre in cblGenres.Items)
            {
                if (chkGenre.Selected)
                {
                    GenreNumber += 1;
                    scCharaGenreInsert.CommandText += "INSERT INTO Character_Genres (GenreID, CharacterID) VALUES (@Genre" + GenreNumber.ToString() + ", @CharacterID);";
                    scCharaGenreInsert.Parameters.AddWithValue("Genre" + GenreNumber.ToString(), chkGenre.Value);
                }
            }

            if (ddlBadgesToAssign.SelectedValue != CurrentAssignedUserBadge.ToString())
            {
                DataFunctions.RunStatement("Update User_Badges Set AssignedToCharacterID = 0 Where AssignedToCharacterID = @ParamTwo; Update User_Badges Set AssignedToCharacterID = @ParamTwo Where UserBadgeID = @ParamOne", ddlBadgesToAssign.SelectedValue, CharacterID);
            }

            if (scCharaGenreInsert.CommandText.Length > 0)
            {
                scCharaGenreInsert.Parameters.AddWithValue("CharacterID", CharacterID);
                DataFunctions.Inserts.InsertRow(scCharaGenreInsert);
            }
        }
        protected void btnDeleteCharacter_Click(object sender, EventArgs e)
        {
            var con = new SqlConnection(ConfigurationManager.ConnectionStrings["RolePlayersGuild.Properties.Settings.rpgDBConn"].ToString());
            con.Open();
            var scGetCharacterImages = new SqlCommand("Select * From Character_Images Where CharacterID = @CharacterID", con);
            scGetCharacterImages.Parameters.AddWithValue("CharacterID", CharacterID);
            SqlDataReader drCharacterImages = scGetCharacterImages.ExecuteReader();

            if (drCharacterImages.HasRows)
            {
                while (drCharacterImages.Read())
                {
                    ImageFunctions.DeleteImage(drCharacterImages["CharacterImageURL"].ToString());
                }
            }
            drCharacterImages.Close();

            var scDeleteCharacter = new SqlCommand();
            scDeleteCharacter.Connection = con;

            scDeleteCharacter.CommandText = "DELETE FROM Characters Where CharacterID = @CharacterID;";
            scDeleteCharacter.CommandText += "DELETE FROM Thread_Users Where CharacterID = @CharacterID;";
            scDeleteCharacter.CommandText += "DELETE FROM Thread_Messages Where CreatorID = @CharacterID;";
            scDeleteCharacter.CommandText += "DELETE FROM Character_Images Where CharacterID = @CharacterID;";
            scDeleteCharacter.CommandText += "UPDATE User_Badges SET AssignedToCharacterID = 0 WHERE AssignedToCharacterID = @CharacterID;";
            scDeleteCharacter.Parameters.AddWithValue("CharacterID", CharacterID);

            scDeleteCharacter.ExecuteNonQuery();

            con.Close();
            Response.Redirect("/My-Characters/", false);
            //pnlMessage.Visible = true;
            //pnlMessage.CssClass = "alert alert-success";
            //litMessage.Text = "The changes to your character have been saved!";
        }

        protected void cblGenres_DataBound(object sender, EventArgs e)
        {
            switch (ScreenStatus)
            {
                case "Edit":
                    DataTable dtCharacterGenres = DataFunctions.Tables.GetDataTable("Select * From [Character_Genres] Where CharacterID = @ParamOne", CharacterID);

                    foreach (DataRow drGenre in dtCharacterGenres.Rows)
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
                    //if (SelectedGenreList.Length > 3)
                    //{
                    //    spnGenreList.InnerText = SelectedGenreList.Substring(0, (SelectedGenreList.Length - 2));
                    //}
                    break;
            }
        }

        protected void ddlBadgesToAssign_DataBound(object sender, EventArgs e)
        {
            //UserBadgeID
            switch (ScreenStatus)
            {
                case "Edit":
                    DataTable dtUserBadges = DataFunctions.Tables.GetDataTable("Select * From [User_Badges] Where UserID = @ParamOne", CookieFunctions.UserID, CharacterID);

                    var queryBadges = dtUserBadges.AsEnumerable().Select(badge => new
                    {
                        CharacterID = badge.Field<int>("AssignedToCharacterID"),
                        BadgeID = badge.Field<int>("BadgeID"),
                        UserBadgeID = badge.Field<int>("UserBadgeID")
                    }).Where(badge => badge.CharacterID == CharacterID).FirstOrDefault();

                    if (queryBadges != null)
                    {
                        ddlBadgesToAssign.Items.FindByValue(queryBadges.UserBadgeID.ToString()).Selected = true;
                        CurrentAssignedUserBadge = queryBadges.UserBadgeID;
                    }

                    if (ddlBadgesToAssign.Items.Count == 1)
                    {
                        ddlBadgesToAssign.Items[0].Text = "No assignable badges available.";
                        ddlBadgesToAssign.Enabled = false;
                    }

                    //foreach (DataRow drBadge in dtUserBadges.Rows)
                    //{
                    //    ddlBadgesToAssign.Items.FindByValue(drBadge["UserBadgeID"].ToString()).Selected = true;
                    //}
                    //string SelectedGenreList = "";
                    //foreach (ListItem chkGenre in cblGenres.Items)
                    //{
                    //    if (chkGenre.Selected)
                    //    {
                    //        SelectedGenreList += chkGenre.Text + ", ";
                    //    }
                    //}
                    //if (SelectedGenreList.Length > 3)
                    //{
                    //    spnGenreList.InnerText = SelectedGenreList.Substring(0, (SelectedGenreList.Length - 2));
                    //}
                    break;
            }
        }
    }
}