using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.Writer
{
    public partial class Default : System.Web.UI.Page
    {
        private int WriterID
        {
            get
            {
                if (ViewState["WriterID"] == null)
                {
                    return 0;
                }
                return ((int)ViewState["WriterID"]);
            }
            set
            {
                ViewState["WriterID"] = value;
            }
        }

        protected void DisplayCharacterInfo()
        {
            if (Request.QueryString["id"] == null)
            { Response.Redirect("/"); }
            else
            {
                WriterID = int.Parse(Request.QueryString["id"]);
                DataRow drUser = DataFunctions.Records.GetDataRow("SELECT * FROM [Users] Where UserID = @ParamOne", 0, WriterID);

                int intBlockID = 0;

                bool UserLoggedInIsBlocked = false;
                bool UserViewedIsBlocked = false;
                if (drUser == null)
                {
                    Response.Redirect("/Error/BadRequest?type=NoCharacter");
                }
                else
                {
                    if (Session["UserID"] != null)
                    {
                        int ViewedUser = int.Parse(drUser["UserID"].ToString());
                        int LoggedInUser = (int)Session["UserID"];
                        intBlockID = DataFunctions.Scalars.GetBlockRecordID(ViewedUser, LoggedInUser);
                        UserViewedIsBlocked = (intBlockID != 0); //ViewedUser Is Blocked by LoggedInUser
                        UserLoggedInIsBlocked = (DataFunctions.Scalars.GetBlockRecordID(LoggedInUser, ViewedUser) != 0); //LoggedInUser Is Blocked by ViewedUser
                        //if (CookieFunctions.IsStaff)
                        //{
                        //    liAdminConsole.Visible = true;
                        //}
                    }
                    if (!UserViewedIsBlocked && !UserLoggedInIsBlocked)
                    {
                        //if (drCharacter["DisplayImageURL"].ToString().Length > 0)
                        //{
                        //    imgDisplayImage.ImageUrl = StringFunctions.DisplayImageString(drCharacter["DisplayImageURL"].ToString(), "thumb");
                        //    imgDisplayImage.Attributes.Add("data-src", StringFunctions.DisplayImageString(drCharacter["DisplayImageURL"].ToString(), "full"));
                        //}
                        DateTime dtLastAction;
                        var ShowWhenOnline = drUser["ShowWhenOnline"];
                        if (drUser["LastAction"] != null &&
                            DateTime.TryParse(drUser["LastAction"].ToString(), out dtLastAction) &&
                            dtLastAction > DateTime.Now.AddHours(-3) &&
                            (bool)ShowWhenOnline)
                        {
                            pUserOnline.Visible = true;
                        }
                        else { pUserOnline.Visible = false; }
                        //pnlAdminCharacter.Visible = (drCharacter["TypeID"].ToString() == "2");
                        litCharacterName.Text = drUser["Username"].ToString();
                        aTwitterLink.Attributes["data-text"] = "Check out \"" + litCharacterName.Text + "\" on RPG!";
                        Page.Title = drUser["Username"].ToString() + " on RPG";
                        Page.MetaDescription = GenerateDescription("", litCharacterName.Text);
                        //lnkAddToThread.NavigateUrl = "/My-Threads/Edit-Thread?Mode=NewThread&ToCharacters=" + CharacterID.ToString();
                        //litFullName.Text = drCharacter["CharacterFirstName"].ToString();
                        //if (drCharacter["CharacterMiddleName"].ToString().Length > 0)
                        //{
                        //    litFullName.Text += " " + drCharacter["CharacterMiddleName"].ToString();
                        //}
                        //if (drCharacter["CharacterLastName"].ToString().Length > 0)
                        //{
                        //    litFullName.Text += " " + drCharacter["CharacterLastName"].ToString();
                        //}
                        //litLFRP.Text = drCharacter["LFRPStatusName"].ToString();
                        //litOriginality.Text = drCharacter["CharacterSource"].ToString();
                        //pnlMatureContentWarning.Visible = (bool)drCharacter["MatureContent"];
                        //pErotica.Visible = (bool)drCharacter["MatureContent"];

                        //if (drCharacter["CharacterBio"].ToString().Length > 0)
                        //{
                        //    divOriginStory.Visible = true;
                        litAboutMe.Text = drUser["AboutMe"].ToString();
                        //}
                        //if (drCharacter["RecentEvents"].ToString().Length > 0)
                        //{
                        //    divRecentEvents.Visible = true;
                        //    litRecentEvents.Text = drCharacter["RecentEvents"].ToString();
                        //}

                        //litSexualOrientation.Text = drCharacter["SexualOrientation"].ToString();
                        //litErotica.Text = drCharacter["EroticaPreference"].ToString();
                        //litLastLogin.Text = String.Format("{0:MMMM dd, yyyy}", DateTime.Parse(drCharacter["LastLogin"].ToString()));
                        //litGender.Text = drCharacter["Gender"].ToString();
                        //litLiteracyLevel.Text = drCharacter["LiteracyLevel"].ToString();
                        //litPostLengthMin.Text = drCharacter["PostLengthMin"].ToString();
                        //litPostLengthMax.Text = drCharacter["PostLengthMax"].ToString();
                        //int MaximumPostLength = int.Parse(drCharacter["PostLengthMaxID"].ToString());
                        //int MinimumPostLength = int.Parse(drCharacter["PostLengthMinID"].ToString());

                        //if (MaximumPostLength == 6 || MinimumPostLength == 6)
                        //{
                        //    if (MaximumPostLength == 6 && MinimumPostLength < 6)
                        //    {
                        //        litPostLengthMin.Text += " &amp; Up";
                        //        litPostLengthMax.Visible = false;
                        //    }
                        //    else if (MaximumPostLength < 6 && MinimumPostLength == 6)
                        //    {
                        //        litPostLengthMax.Text += " &amp; Under";
                        //        litPostLengthMin.Visible = false;
                        //    }
                        //    else { litPostLengthMin.Text = "No Preference"; litPostLengthMax.Visible = false; }

                        //}
                        //else if (MinimumPostLength != MaximumPostLength) { litPostLengthMin.Text += " &mdash; "; }
                        //else if (MinimumPostLength == MaximumPostLength) { litPostLengthMax.Visible = false; }


                        //DataTable dtCharacterGenres = DataFunctions.Tables.GetDataTable("SELECT Genres.GenreName FROM Character_Genres INNER JOIN Genres ON Character_Genres.GenreID = Genres.GenreID WHERE (Character_Genres.CharacterID = @ParamOne)", CharacterID);

                        //string SelectedGenreList = "";
                        //foreach (DataRow drGenre in dtCharacterGenres.Rows)
                        //{
                        //    SelectedGenreList += drGenre["GenreName"].ToString() + ", ";
                        //}
                        //if (SelectedGenreList.Length > 3)
                        //{
                        //    spnGenreList.InnerText = SelectedGenreList.Substring(0, (SelectedGenreList.Length - 2));
                        //}

                        lnkBlockUser.Visible = true;
                        lnkUnblockUser.Visible = false;
                        //lnkAddToThread.Visible = true;

                    }
                    else if (UserViewedIsBlocked)
                    {
                        ViewState["intBlockID"] = intBlockID.ToString();
                        lnkBlockUser.Visible = false;
                        lnkUnblockUser.Visible = true;
                        //lnkAddToThread.CssClass += " disabled";
                    }
                    else if (UserLoggedInIsBlocked)
                    {
                        //lnkAddToThread.NavigateUrl = "#";
                        //lnkAddToThread.CssClass = "btn btn-danger col-xs-6";
                        //lnkAddToThread.Attributes.Add("data-toggle", "tooltip");
                        //lnkAddToThread.Attributes.Add("data-placement", "bottom");
                        //lnkAddToThread.Attributes.Add("title", "You do not have permission to message this Writer.");
                    }
                    if (Session["UserID"] == null || int.Parse(drUser["UserID"].ToString()) == (int)Session["UserID"])
                    {
                        //lnkAddToThread.NavigateUrl = "#";
                        //lnkAddToThread.CssClass = "btn btn-warning col-xs-6";
                        //lnkAddToThread.Attributes.Add("data-toggle", "tooltip");
                        //lnkAddToThread.Attributes.Add("data-placement", "bottom");
                        //lnkAddToThread.Attributes.Add("title", "You must be logged in to send messages.");

                        if (Session["UserID"] != null && int.Parse(drUser["UserID"].ToString()) == (int)Session["UserID"]) { /*lnkAddToThread.CssClass += " disabled";*/ }

                        lnkBlockUser.Visible = false;
                    }
                }
            }
        }
        protected string GenerateDescription(string WriterAboutMe, string Username)
        {
            if (WriterAboutMe.Length > 200)
            { return WriterAboutMe.Substring(0, 200) + "..."; }
            else if (WriterAboutMe.Length == 0)
            { return "Role-Play with " + Username + " on RPG today!"; }
            else if (WriterAboutMe.Length <= 200)
            { return WriterAboutMe; }
            return "Role-Players Guild";
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "linkifyStuffOnNewPage", "$('[data-linkify]').linkify({ target: '_blank', nl2br: true, format: function (value, type) { if (type === 'url' && value.length > 50) { value = value.slice(0, 50) + '…'; } return value; } });", true);
            DisplayCharacterInfo();
        }

        protected void btnBlockUser_Click(object sender, EventArgs e)
        {
            //var rpgCharacters = new rpgDBTableAdapters.CharactersWithDisplayImagesTableAdapter();
            //var dsCharacters = rpgCharacters.GetCharacterByCharacterID(int.Parse(Request.QueryString["id"]));

            //int ViewedUserID = DataFunctions.Scalars.GetUserID(CharacterID);

            if (WriterID > 0)
            {
                if (WriterID != (int)Session["UserID"])
                {
                    //var rpgBlocking = new rpgDBTableAdapters.User_BlockingTableAdapter();
                    DataFunctions.Inserts.BlockUser((int)Session["UserID"], WriterID);
                    pnlMessage.Visible = true; pnlMessage.CssClass = "alert alert-success"; litMessage.Text = "The Writer who owns this character has been successfully blocked. They will no longer be able to contact you. To unblock them, please use the button below.";
                }
                else
                {
                    pnlMessage.Visible = true; pnlMessage.CssClass = "alert alert-danger"; litMessage.Text = "You can't block yourself. Stahp.";
                }
            }
            DisplayCharacterInfo();
        }

        protected void btnUnblockUser_Click(object sender, EventArgs e)
        {

            //var rpgBlocking = new rpgDBTableAdapters.User_BlockingTableAdapter();
            DataFunctions.Deletes.UnblockUser(int.Parse(ViewState["intBlockID"].ToString()));
            pnlMessage.Visible = true; pnlMessage.CssClass = "alert alert-success"; litMessage.Text = "This Writer has been unblocked.";
            DisplayCharacterInfo();
        }

        protected void rptArticles_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView drv = e.Item.DataItem as DataRowView;
                int ArticleID = int.Parse(drv.Row["ArticleID"].ToString());
                Repeater rptGenres = (Repeater)(e.Item.FindControl("rptGenres"));

                sdsGenres.SelectParameters[0].DefaultValue = ArticleID.ToString();
                rptGenres.DataSource = sdsGenres;
                rptGenres.DataBind();
            }
        }
    }
}
