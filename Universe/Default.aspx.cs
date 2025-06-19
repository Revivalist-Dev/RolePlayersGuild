using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.Universe
{
    public partial class Default : System.Web.UI.Page
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
        private int UniverseOwnerID
        {
            get
            {
                if (ViewState["UniverseOwnerID"] == null)
                {
                    return 0;
                }
                return ((int)ViewState["UniverseOwnerID"]);
            }
            set
            {
                ViewState["UniverseOwnerID"] = value;
            }
        }
        private int SearchByUniverseID
        {
            get
            {
                if (Session["SearchByUniverseID"] == null)
                {
                    return 0;
                }
                return ((int)Session["SearchByUniverseID"]);
            }
            set
            {
                Session["SearchByUniverseID"] = value;
            }
        }

        protected void DisplayUniverseInfo()
        {
            int ParsedUniverseID = 0;
            if (Request.QueryString["id"] == null || int.TryParse(Request.QueryString["id"], out ParsedUniverseID) == false)
            { Response.Redirect("/Universe/List"); }
            else
            {
                UniverseID = ParsedUniverseID;

                DataRow drUniverse = DataFunctions.Records.GetDataRow("SELECT * FROM [UniversesWithDetails] Where UniverseID = @ParamOne", 0, UniverseID);

                int intBlockID = 0;

                bool UserLoggedInIsBlocked = false;
                bool UserViewedIsBlocked = false;
                if (drUniverse == null || drUniverse["StatusID"].ToString() == "1")
                { Response.Redirect("/Universe/List"); }
                else
                {
                    UniverseOwnerID = int.Parse(drUniverse["UniverseOwnerID"].ToString());
                    if (Session["UserID"] != null)
                    {
                        int LoggedInUser = (int)Session["UserID"];
                        intBlockID = DataFunctions.Scalars.GetBlockRecordID(UniverseOwnerID, LoggedInUser);
                        UserViewedIsBlocked = (intBlockID != 0); //ViewedUser Is Blocked by LoggedInUser
                        UserLoggedInIsBlocked = (DataFunctions.Scalars.GetBlockRecordID(LoggedInUser, UniverseOwnerID) != 0); //LoggedInUser Is Blocked by ViewedUser
                    }
                    if (!UserViewedIsBlocked && !UserLoggedInIsBlocked)
                    {
                        litUniverseName.Text = drUniverse["UniverseName"].ToString();
                        aTwitterLink.Attributes["data-text"] = "#Roleplay with the " + litUniverseName.Text + " #Universe!";
                        Page.Title = drUniverse["UniverseName"].ToString() + " — Role-Players Guild";
                        Page.MetaDescription = "Role-Play in the " + drUniverse["UniverseName"].ToString() + " Universe on RPG today! The Role-Players Guild is a fast growing, custom-built role-play community open to writers of all types. If you're looking for the absolute best in role-play, join RPG!";

                        if (drUniverse["SourceTypeID"].ToString() == "2")
                        {
                            pnlMessage.Visible = true;
                            pnlMessage.CssClass = "alert alert-info";
                            litMessage.Text = "Since this is a Fan-Fic Universe, it is maintained by the RPG Staff. If you feel the information on this Universe can be improved, please <a href=\"/Report/\">submit a report</a>!";
                        }

                        litUniverse.Text = drUniverse["UniverseDescription"].ToString();

                        if (!((bool)drUniverse["DisableLinkify"]))
                        {
                            divUniverseDescriptionContainer.Attributes["data-linkify"] = " ";
                            divUniverseDescriptionContainer.Attributes["class"] = "StyledUniverse";
                        }

                        DataTable dtUniverseGenres = DataFunctions.Tables.GetDataTable("SELECT Genres.GenreName FROM Universe_Genres INNER JOIN Genres ON Universe_Genres.GenreID = Genres.GenreID WHERE (Universe_Genres.UniverseID = @ParamOne) Order By Genres.GenreName", UniverseID);

                        string SelectedGenreList = "";
                        foreach (DataRow drGenre in dtUniverseGenres.Rows)
                        {
                            SelectedGenreList += "<span itemprop=\"genre\">" + drGenre["GenreName"].ToString() + "</span>, ";
                        }
                        if (SelectedGenreList.Length > 3)
                        {
                            litGenreList.Text = SelectedGenreList.Substring(0, (SelectedGenreList.Length - 2));
                        }

                        //}
                    }
                    else if (UserViewedIsBlocked)
                    {
                        pnlMessage.Visible = true;
                        pnlMessage.CssClass = "alert alert-danger";
                        litMessage.Text = "It seems you have blocked the owner of this Universe. Unfortunately, this means that you will not be able to join this universe.";
                        pnlContent.Visible = false;
                        aLeaveWhenBlocked.Visible = true;
                        btnOwnerWhenBlocked.Visible = true;
                    }
                    else if (UserLoggedInIsBlocked)
                    {
                        pnlMessage.Visible = true;
                        pnlMessage.CssClass = "alert alert-danger";
                        litMessage.Text = "It seems you have been blocked by the owner of this Universe. Unfortunately, this means that you will not be able to join this universe.";
                        pnlContent.Visible = false;
                        aLeaveWhenBlocked.Visible = true;
                    }
                }
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "linkifyStuffOnNewPage", "$('[data-linkify]').linkify({ target: '_blank', nl2br: true, format: function (value, type) { if (type === 'url' && value.length > 50) { value = value.slice(0, 50) + '…'; } return value; } });", true);
            DisplayUniverseInfo();
            if (Session["HideAds"] != null && Session["HideAds"].ToString() == "true")
            {
                divUniverseAd.Visible = false;
            }
        }

        protected void btnAddCharacters_Click(object sender, EventArgs e)
        {
            int ItemCount = 0;
            string CommandToRun = "";
            var scInsertCommand = new SqlCommand();
            foreach (ListItem li in cblYourCharacters.Items)
            {
                if (li.Selected)
                {
                    ItemCount += 1;
                    CommandToRun += "Insert Into Character_Universes (CharacterID, UniverseID) Values (@Character" + ItemCount.ToString() + ", @UniverseID);";
                    scInsertCommand.Parameters.AddWithValue("Character" + ItemCount.ToString(), li.Value);
                }
            }
            if (ItemCount > 0)
            {
                scInsertCommand.CommandText = CommandToRun;
                scInsertCommand.Connection = DataFunctions.Connections.GetOpenRPGDBConn();
                scInsertCommand.Parameters.AddWithValue("UniverseID", UniverseID);
                scInsertCommand.ExecuteNonQuery();
                scInsertCommand.Connection.Close();
                scInsertCommand.Connection.Dispose();
            }
            scInsertCommand.Dispose();

            Response.Redirect("/Universe/?id=" + UniverseID.ToString());
        }

        protected void btnRemoveCharacters_Click(object sender, EventArgs e)
        {
            int ItemCount = 0;
            string CommandToRun = "";
            var scInsertCommand = new SqlCommand();
            foreach (ListItem li in cblYourJoinedCharacters.Items)
            {
                if (li.Selected)
                {
                    ItemCount += 1;
                    CommandToRun += "Delete From Character_Universes Where CharacterID = @Character" + ItemCount.ToString() + " And UniverseID = @UniverseID;";
                    scInsertCommand.Parameters.AddWithValue("Character" + ItemCount.ToString(), li.Value);
                }
            }
            if (ItemCount > 0)
            {
                scInsertCommand.CommandText = CommandToRun;
                scInsertCommand.Connection = DataFunctions.Connections.GetOpenRPGDBConn();
                scInsertCommand.Parameters.AddWithValue("UniverseID", UniverseID);
                scInsertCommand.ExecuteNonQuery();
                scInsertCommand.Connection.Close();
                scInsertCommand.Connection.Dispose();
            }
            scInsertCommand.Dispose();

            Response.Redirect("/Universe/?id=" + UniverseID.ToString());
        }

        protected void btnViewCharacters_Click(object sender, EventArgs e)
        {
            SearchByUniverseID = UniverseID;
            Session["UniverseName"] = litUniverseName.Text;
            Response.Redirect("/Character/Search/");
        }
        protected void btnViewChatRooms_Click(object sender, EventArgs e)
        {
            //SearchByUniverseID = UniverseID;
            //Session["UniverseName"] = litUniverseName.Text;
            Response.Redirect("/Chat-Rooms/?UniverseID=" + UniverseID.ToString());
        }

        protected void btnViewOwner_Click(object sender, EventArgs e)
        {
            Response.Redirect("/Writer/?id=" + UniverseOwnerID.ToString());
        }
        protected void btnViewStories_Click(object sender, EventArgs e)
        {
            SearchByUniverseID = UniverseID;
            Session["UniverseName"] = litUniverseName.Text;
            Response.Redirect("/Story/List?UniverseID=" + UniverseID.ToString());
        }
    }
}
