using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI;

namespace RolePlayersGuild.Character
{
    public partial class Default : System.Web.UI.Page
    {
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

        protected void DisplayCharacterInfo()
        {
            int ParsedCharaID = 0;
            if (Request.QueryString["id"] == null || int.TryParse(Request.QueryString["id"], out ParsedCharaID) == false)
            { Response.Redirect("/Character/Search"); }
            else
            {
                CharacterID = ParsedCharaID;

                DataRow drCharacter = DataFunctions.Records.GetDataRow("SELECT * FROM [CharactersWithDetails] Where CharacterID = @ParamOne", 0, CharacterID);

                int intBlockID = 0;

                bool UserLoggedInIsBlocked = false;
                bool UserViewedIsBlocked = false;
                if (drCharacter == null)
                {
                    Response.Redirect("/Character/Search");
                }
                else
                {
                    if (drCharacter["CharacterStatusID"].ToString() == "2" && !CookieFunctions.IsStaff)
                    {
                        Response.Redirect("/Character/Search");
                    }

                    if (drCharacter["TypeID"].ToString() == "2")
                    {
                        //if (drCharacter["DisplayImageURL"].ToString().Length > 0)
                        //{
                        imgDisplayImage.ImageUrl = StringFunctions.DisplayImageString(drCharacter["DisplayImageURL"].ToString(), "thumb");
                        imgDisplayImage.Attributes.Add("data-src", StringFunctions.DisplayImageString(drCharacter["DisplayImageURL"].ToString(), "full"));
                        //}
                        pUserOnline.Visible = false;
                        divCharacterControls.Visible = false;
                        divCharacterOOC.Visible = false;
                        btnBlockUser.Visible = false;
                        btnUnblockUser.Visible = false;
                        lnkBlockUser.Visible = false;
                        lnkUnblockUser.Visible = false;
                        divOriginStory.Visible = false;
                        divCharacterDetails.Visible = false;

                        divStaffControls.Visible = true;

                        pnlMessage.Visible = true;
                        //pnlMessage.CssClass = "alert alert-warning";
                        pnlMessage.CssClass = "text-center";
                        litMessage.Text = "<h1>" + drCharacter["CharacterDisplayName"].ToString() + "</h1> <p>This profile belongs to an RPG Staff Member. If you are having problems with RPG or have a concern you want addressed, please use the Contact Staff button on this page. Please include as much detail as possible in your message.</p><p>If you have reached this page to ask a question, it is recommended you first check out our <a href='/FAQ/'>Frequently Asked Questions</a> page before sending a message to the staff.</p>";

                    }
                    else
                    {

                        if (Session["UserID"] != null)
                        {
                            int ViewedUser = int.Parse(drCharacter["UserID"].ToString());
                            int LoggedInUser = (int)Session["UserID"];
                            intBlockID = DataFunctions.Scalars.GetBlockRecordID(ViewedUser, LoggedInUser);
                            UserViewedIsBlocked = (intBlockID != 0); //ViewedUser Is Blocked by LoggedInUser
                            UserLoggedInIsBlocked = (DataFunctions.Scalars.GetBlockRecordID(LoggedInUser, ViewedUser) != 0); //LoggedInUser Is Blocked by ViewedUser
                            if (CookieFunctions.IsStaff)
                            {
                                liAdminConsole.Visible = true;
                                liMarkForReview.Visible = true;
                            }
                        }
                        if (!UserViewedIsBlocked && !UserLoggedInIsBlocked)
                        {

                            if (bool.Parse(drCharacter["CustomProfileEnabled"].ToString()) && (Request.QueryString["DisableCustom"] == null || Request.QueryString["DisableCustom"].ToString() != "1"))
                            {
                                Response.Clear();
                                DataRow sdrProfile = DataFunctions.Records.GetDataRow("SELECT ProfileHTML, ProfileCSS From Characters WHERE (CharacterID = @ParamOne)", 0, CharacterID);
                                StringBuilder pageNewContent = new StringBuilder("<!DOCTYPE html><html xmlns=\"http://www.w3.org/1999/xhtml\"><head>");
                                if (File.Exists(MapPath("/templates/html/ProfilesHead.html")))
                                {
                                    string CharacterBio = GenerateDescription(drCharacter["CharacterBio"].ToString(), drCharacter["CharacterDisplayName"].ToString());
                                    pageNewContent.Append(File.ReadAllText(MapPath("/templates/html/ProfilesHead.html")).Replace("[TITLE]", drCharacter["CharacterDisplayName"].ToString() + " — Role-Players Guild").Replace("[DESCRIPTION]", CharacterBio));
                                }
                                pageNewContent.Append("<style>" + sdrProfile["ProfileCSS"] + "</style></head>");
                                pageNewContent.Append("<body>" + sdrProfile["ProfileHTML"] + "</body></html>");

                                //Placeholders
                                //Character Stuff Goes Here
                                pageNewContent.Replace("[CHARA-BACKGROUND]", drCharacter["CharacterBio"].ToString().Replace(Environment.NewLine, "<br/>"));
                                pageNewContent.Replace("[CHARA-RECENTEVENTS]", drCharacter["RecentEvents"].ToString().Replace(Environment.NewLine, "<br/>"));
                                pageNewContent.Replace("[CHARA-OTHERINFO]", drCharacter["OtherInfo"].ToString().Replace(Environment.NewLine, "<br/>"));
                                pageNewContent.Replace("[CHARA-GENDER]", drCharacter["Gender"].ToString());
                                pageNewContent.Replace("[CHARA-SEXUALITY]", drCharacter["SexualOrientation"].ToString());
                                pageNewContent.Replace("[CHARA-DISPLAYIMAGE]", "<img src=\"" + StringFunctions.DisplayImageString(drCharacter["DisplayImageURL"].ToString(), "thumb") + "\" />");

                                pageNewContent.Replace("[CHARA-FIRSTNAME]", drCharacter["CharacterFirstName"].ToString());
                                pageNewContent.Replace("[CHARA-MIDDLENAME]", drCharacter["CharacterMiddleName"].ToString());
                                pageNewContent.Replace("[CHARA-LASTNAME]", drCharacter["CharacterLastName"].ToString());

                                string FullName = drCharacter["CharacterFirstName"].ToString();
                                if (drCharacter["CharacterMiddleName"].ToString().Length > 0)
                                {
                                    FullName += " " + drCharacter["CharacterMiddleName"].ToString();
                                }
                                if (drCharacter["CharacterLastName"].ToString().Length > 0)
                                {
                                    FullName += " " + drCharacter["CharacterLastName"].ToString();
                                }
                                pageNewContent.Replace("[CHARA-FULLNAME]", FullName);
                                //Links Go Here
                                pageNewContent.Replace("[LINK-HOME]", "<a href=\"/My-Dashboard/\">Home</a>");
                                pageNewContent.Replace("[LINK-SENDMESSAGE]", "<a href=\"/My-Threads/Edit-Thread/?Mode=NewThread&ToCharacters=" + CharacterID.ToString() + "\">Message</a>");
                                pageNewContent.Replace("[LINK-VIEWGALLERY]", "<a href=\"/Gallery/?id=" + CharacterID.ToString() + "\">Gallery</a>");
                                pageNewContent.Replace("[LINK-VIEWWRITER]", "<a href=\"/Writer/?id=" + drCharacter["UserID"].ToString() + "\">Writer</a>");
                                //Other Functions Go Here
                                pageNewContent.Replace("[FUNC-MATURENOTICE]", "<div class=\"MatureContentNotice\">CONTENT WARNING: For Mature Audiences; R18+</div>");
                                DateTime dtLastAction;
                                var ShowWhenOnline = drCharacter["ShowWhenOnline"];
                                if (drCharacter["LastAction"] != null &&
                                    DateTime.TryParse(drCharacter["LastAction"].ToString(), out dtLastAction) &&
                                    dtLastAction > DateTime.Now.AddHours(-3) &&
                                    (bool)ShowWhenOnline)
                                {
                                    pageNewContent.Replace("[FUNC-ONLINE]", "<span class=\"UserOnline\">Currently Online</span>");
                                    pageNewContent.Replace("[FUNC-OFFLINE]", "");
                                }
                                else
                                {
                                    pageNewContent.Replace("[FUNC-OFFLINE]", "<span class=\"UserOffline\"> Currently Offline</span>");
                                    pageNewContent.Replace("[FUNC-ONLINE]", "");
                                }
                                Response.Write(pageNewContent);
                                Response.End();
                            }
                            else
                            {
                                //if (drCharacter["DisplayImageURL"].ToString().Length > 0)
                                //{
                                imgDisplayImage.ImageUrl = StringFunctions.DisplayImageString(drCharacter["DisplayImageURL"].ToString(), "thumb");
                                imgDisplayImage.Attributes.Add("data-src", StringFunctions.DisplayImageString(drCharacter["DisplayImageURL"].ToString(), "full"));
                                //}
                                DateTime dtLastAction;
                                var ShowWhenOnline = drCharacter["ShowWhenOnline"];
                                if (drCharacter["LastAction"] != null &&
                                    DateTime.TryParse(drCharacter["LastAction"].ToString(), out dtLastAction) &&
                                    dtLastAction > DateTime.Now.AddHours(-3) &&
                                    (bool)ShowWhenOnline)
                                {
                                    pUserOnline.Visible = true;
                                }
                                else { pUserOnline.Visible = false; }
                                litCharacterName.Text = drCharacter["CharacterDisplayName"].ToString();
                                aTwitterLink.Attributes["data-text"] = "Check out \"" + litCharacterName.Text + "\" on the Role-Players Guild!";
                                Page.Title = drCharacter["CharacterDisplayName"].ToString() + " — Role-Players Guild";
                                Page.MetaDescription = GenerateDescription(drCharacter["CharacterBio"].ToString(), litCharacterName.Text);
                                lnkAddToThread.NavigateUrl = "/My-Threads/Edit-Thread?Mode=NewThread&ToCharacters=" + CharacterID.ToString();
                                lnkWriterLink.Visible = (bool)drCharacter["ShowWriterLinkOnCharacters"] && !(bool)drCharacter["IsPrivate"];
                                lnkWriterLink.NavigateUrl = "/Writer?id=" + drCharacter["UserID"].ToString();
                                lblGivenName.Text = drCharacter["CharacterFirstName"].ToString();
                                lblAdditionalName.Text = drCharacter["CharacterMiddleName"].ToString();
                                lblFamilyName.Text = drCharacter["CharacterLastName"].ToString();
                                litLFRP.Text = drCharacter["LFRPStatusName"].ToString();
                                litOriginality.Text = drCharacter["CharacterSource"].ToString();
                                pnlMatureContentWarning.Visible = (bool)drCharacter["MatureContent"];
                                pErotica.Visible = (bool)drCharacter["MatureContent"];
                                if (!((bool)drCharacter["DisableLinkify"]))
                                {
                                    divOriginStory.Attributes["data-linkify"] = " ";
                                }

                                litBackground.Text = drCharacter["CharacterBio"].ToString();


                                lblSexualOrientation.Text = drCharacter["SexualOrientation"].ToString();
                                litErotica.Text = drCharacter["EroticaPreference"].ToString();
                                litLastLogin.Text = String.Format("{0:MMMM dd, yyyy}", DateTime.Parse(drCharacter["LastLogin"].ToString()));
                                lblGender.Text = drCharacter["Gender"].ToString();
                                litLiteracyLevel.Text = drCharacter["LiteracyLevel"].ToString();
                                litPostLengthMin.Text = drCharacter["PostLengthMin"].ToString();
                                litPostLengthMax.Text = drCharacter["PostLengthMax"].ToString();
                                int MaximumPostLength = int.Parse(drCharacter["PostLengthMaxID"].ToString());
                                int MinimumPostLength = int.Parse(drCharacter["PostLengthMinID"].ToString());

                                if (MaximumPostLength == 6 || MinimumPostLength == 6)
                                {
                                    if (MaximumPostLength == 6 && MinimumPostLength < 6)
                                    {
                                        litPostLengthMin.Text += " &amp; Up";
                                        litPostLengthMax.Visible = false;
                                    }
                                    else if (MaximumPostLength < 6 && MinimumPostLength == 6)
                                    {
                                        litPostLengthMax.Text += " &amp; Under";
                                        litPostLengthMin.Visible = false;
                                    }
                                    else { litPostLengthMin.Text = "No Preference"; litPostLengthMax.Visible = false; }

                                }
                                else if (MinimumPostLength != MaximumPostLength) { litPostLengthMin.Text += " &mdash; "; }
                                else if (MinimumPostLength == MaximumPostLength) { litPostLengthMax.Visible = false; }


                                DataTable dtCharacterGenres = DataFunctions.Tables.GetDataTable("SELECT Genres.GenreName FROM Character_Genres INNER JOIN Genres ON Character_Genres.GenreID = Genres.GenreID WHERE (Character_Genres.CharacterID = @ParamOne)", CharacterID);

                                string SelectedGenreList = "";
                                foreach (DataRow drGenre in dtCharacterGenres.Rows)
                                {
                                    SelectedGenreList += "<span itemprop=\"genre\">" + drGenre["GenreName"].ToString() + "</span>, ";
                                }
                                if (SelectedGenreList.Length > 3)
                                {
                                    litGenreList.Text = SelectedGenreList.Substring(0, (SelectedGenreList.Length - 2));
                                }

                                lnkBlockUser.Visible = true;
                                lnkUnblockUser.Visible = false;
                                lnkAddToThread.Visible = true;
                            }
                        }
                        else if (UserViewedIsBlocked)
                        {
                            ViewState["intBlockID"] = intBlockID.ToString();
                            lnkBlockUser.Visible = false;
                            lnkUnblockUser.Visible = true;
                            lnkAddToThread.CssClass += " disabled";
                        }
                        else if (UserLoggedInIsBlocked)
                        {
                            lnkAddToThread.NavigateUrl = "#";
                            lnkAddToThread.CssClass = "btn btn-danger col-xs-6";
                            lnkAddToThread.Attributes.Add("data-toggle", "tooltip");
                            lnkAddToThread.Attributes.Add("data-placement", "bottom");
                            lnkAddToThread.Attributes.Add("title", "You do not have permission to message this Writer.");
                        }
                        if (Session["UserID"] != null && int.Parse(drCharacter["UserID"].ToString()) == (int)Session["UserID"])
                        {
                            lnkAddToThread.NavigateUrl = "/My-Characters/Edit-Character/?Mode=Edit&CharID=" + CharacterID;
                            lnkAddToThread.Text = "Edit Character";
                            //lnkAddToThread.CssClass = "btn btn-primary col-xs-6";
                            lnkBlockUser.Visible = false;
                        }
                        else if (Session["UserID"] == null)
                        {
                            lnkBlockUser.Visible = false;
                            lnkAddToThread.NavigateUrl = "#";
                            lnkAddToThread.CssClass = "btn btn-warning col-xs-6";
                            lnkAddToThread.Attributes.Add("data-toggle", "tooltip");
                            lnkAddToThread.Attributes.Add("data-placement", "bottom");
                            lnkAddToThread.Attributes.Add("title", "You must be logged in to send messages.");

                        }
                    }
                }
            }
        }
        protected string GenerateDescription(string CharacterBio, string CharacterName)
        {
            if (CharacterBio.Length > 200)
            { return CharacterBio.Substring(0, 200) + "..."; }
            else if (CharacterBio.Length <= 200)
            { return "Role-Play with " + CharacterName + " on RPG today! The Role-Players Guild is a fast growing, custom-built role-play community open to writers of all types. If you're looking for the absolute best in role-play, join RPG!"; }
            return "Role-Players Guild";
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "linkifyStuffOnNewPage", "$('[data-linkify]').linkify({ target: '_blank', nl2br: true, format: function (value, type) { if (type === 'url' && value.length > 50) { value = value.slice(0, 50) + '…'; } return value; } });", true);
            DisplayCharacterInfo();
        }

        protected void btnBlockUser_Click(object sender, EventArgs e)
        {

            int ViewedUserID = DataFunctions.Scalars.GetUserID(CharacterID);

            if (ViewedUserID > 0)
            {
                if (ViewedUserID != (int)Session["UserID"])
                {
                    DataFunctions.Inserts.BlockUser((int)Session["UserID"], ViewedUserID);
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

            DataFunctions.Deletes.UnblockUser(int.Parse(ViewState["intBlockID"].ToString()));
            pnlMessage.Visible = true; pnlMessage.CssClass = "alert alert-success"; litMessage.Text = "This Writer has been unblocked.";
            DisplayCharacterInfo();
        }

        protected void btnMarkForReview_Click(object sender, EventArgs e)
        {
            MiscFunctions.MarkCharacterForReview(CharacterID);
        }
    }
}
