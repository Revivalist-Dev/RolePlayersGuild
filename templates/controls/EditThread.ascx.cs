using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.templates.controls
{
    public partial class EditThread : System.Web.UI.UserControl
    {
        private int CurrentMessage
        {
            get
            {
                if (ViewState["CurrentMessage"] == null)
                {
                    return 0;
                }
                return ((int)ViewState["CurrentMessage"]);
            }
            set
            {
                ViewState["CurrentMessage"] = value;
            }
        }

        public string ScreenStatus { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {
            litMessage.Text = ScreenStatus;
            switch (ScreenStatus)
            {
                case "NewThread":
                    pnlTitle.Visible = true;
                    litMessageType.Text = "New Thread";
                    if (!Page.IsPostBack)
                    {
                        PopulateRecipientList();
                    }
                    break;
                case "Existing Thread":
                    btnCreateThread.Text = "Save Changes";
                    litMessageType.Text = "Edit Thread";
                    break;
                case "AddPost":
                    DataTable dtThreads = DataFunctions.Tables.GetThreadDetailsForUser(int.Parse(Request.QueryString["ThreadID"]));
                    if (dtThreads.Rows.Count > 0)
                    {

                        pnlTitle.Visible = false;
                        btnCreateThread.Text = "<span class=\"glyphicon glyphicon-plus\"></span>&nbsp;New Post";
                        btnCreateThread.CssClass = "btn btn-success";
                        litMessageType.Visible = false;
                        pnlOtherCharacter.Visible = false;
                        PopulateMyCharacterListOnPost();
                        txtPostContent.Rows = 6;
                        UserSearch.Visible = false;
                        RemoveCharacters.Visible = false;

                    }
                    else {
                        pnlThreadForm.Visible = false; pnlMessage.Visible = true; pnlMessage.CssClass = "alert alert-danger"; litMessage.Text = "You do not have permission to post on this thread.";
                    }
                    break;

                case "EditPost":
                    pnlTitle.Visible = false;
                    btnCreateThread.Text = "Save Changes";
                    litMessageType.Text = "Edit Post";
                    pnlOtherCharacter.Visible = false;
                    if (!Page.IsPostBack)
                    {
                        PopulateMyCharacterListOnPost();

                        var con = new SqlConnection(ConfigurationManager.ConnectionStrings["RolePlayersGuild.Properties.Settings.rpgDBConn"].ToString());
                        con.Open();
                        SqlDataAdapter da = new SqlDataAdapter();
                        da.SelectCommand = new SqlCommand("SELECT Thread_Messages.ThreadID, Thread_Messages.MessageContent, Thread_Messages.CreatorID, Thread_Messages.ThreadMessageID FROM Thread_Messages INNER JOIN Characters ON Thread_Messages.CreatorID = Characters.CharacterID WHERE (Thread_Messages.ThreadMessageID = @MessageID) AND (Characters.UserID = @User)", con);
                        da.SelectCommand.Parameters.AddWithValue("MessageID", Request.QueryString["mid"]);
                        da.SelectCommand.Parameters.AddWithValue("User", Session["UserID"]);
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        con.Close();

                        if (dt.Rows.Count > 0)
                        {
                            txtPostContent.Text = HttpUtility.HtmlDecode(dt.Rows[0]["MessageContent"].ToString());
                            rblMyCharacters.SelectedValue = dt.Rows[0]["CreatorID"].ToString();
                            CurrentMessage = int.Parse(dt.Rows[0]["ThreadMessageID"].ToString());
                        }
                        else
                        { Response.Redirect("/"); }
                    }
                    break;
                default:
                    break;
            }
        }
        protected void PopulateMyCharacterListOnPost()
        {
            if (!Page.IsPostBack)
            {
                lblMyCharacters.InnerHtml = "Post As...";
                sdsMyCharacters.SelectCommand = "SELECT Characters.CharacterDisplayName, Characters.CharacterID FROM Characters INNER JOIN Thread_Users ON Characters.CharacterID = Thread_Users.CharacterID WHERE (Thread_Users.ThreadID = @ThreadID) AND (Characters.UserID = @UserID) ORDER BY Characters.CharacterID;";
                sdsMyCharacters.SelectParameters.Add("ThreadID", Request.QueryString["ThreadID"].ToString());
                //sdsMyCharacters.DataBind();
                rblMyCharacters.DataBind();
                if (rblMyCharacters.Items.Count == 1)
                { rblMyCharacters.Items[0].Selected = true; pnlMyCharacters.Visible = false; }
            }
        }
        protected void PopulateMyCharactersList()
        {

        }
        protected void PopulateRecipientList()
        {
            string ToCharacters = "";
            if (ViewState["ToCharacters"] == null || ViewState["ToCharacters"].ToString().Length < 0)
            {
                if (Request.QueryString["ToCharacters"] != null)
                {
                    ToCharacters = Request.QueryString["ToCharacters"];
                    ViewState["ToCharacters"] = ToCharacters;
                }
            }
            else
            {
                ToCharacters = ViewState["ToCharacters"].ToString();
            }


            litRecipientList.Text = "";
            if (ToCharacters.Length > 0)
            {
                cblRemoveableCharacters.Items.Clear();
                var RecipientList = ToCharacters.Split(new string[] { "|" }, StringSplitOptions.None);
                //var rpgCharacters = new rpgDBTableAdapters.CharactersWithDisplayImagesTableAdapter();
                //rpgDB.CharactersWithDisplayImagesDataTable rpgCharactersFound;
                foreach (string RecipientCharacter in RecipientList)
                {
                    DataTable rpgCharactersFound = DataFunctions.Tables.GetDataTable("Select DisplayImageURL, CharacterDisplayName From CharactersWithDetails Where CharacterID = @ParamOne;", RecipientCharacter);
                    litRecipientList.Text += "<span style=\"background-image: url(" + ConfigurationManager.AppSettings["DisplayCharacterImagesFolder"].ToString() + "thumbimg_" + rpgCharactersFound.Rows[0]["DisplayImageURL"].ToString() + "); \" data-toggle=\"tooltip\" data-placement=\"bottom\" class=\"\" title=\"" + rpgCharactersFound.Rows[0]["CharacterDisplayName"].ToString() + "\"></span>";
                    ListItem RemoveableCharacter = new ListItem(rpgCharactersFound.Rows[0]["CharacterDisplayName"].ToString(), RecipientCharacter);
                    cblRemoveableCharacters.Items.Add(RemoveableCharacter);
                    btnRemoveCharacters.Visible = true;
                }
            }
            else { btnRemoveCharacters.Visible = false; }
        }
        protected void btnUserSearch_Click(object sender, EventArgs e)
        {
            //var rpgCharacters = new rpgDBTableAdapters.CharactersTableAdapter();
            DataTable rpgCharactersFound = DataFunctions.Tables.SearchUsers(txtUserSearch.Text, false);
            if (rpgCharactersFound.Rows.Count > 0)
            {
                //, CharacterDisplayName + ' - ' + CharacterFirstName + ' ' + CharacterMiddleName + ' ' + CharacterLastName + ' - ' + Cast(CharacterID as NVarchar) AS CharacterTextLine
                cblUserSearchResults.DataSource = rpgCharactersFound;
                cblUserSearchResults.DataValueField = "CharacterID";
                cblUserSearchResults.DataTextField = "CharacterDisplayName";
                cblUserSearchResults.DataBind();
                pnlSearchResults.Visible = true;
                pnlSearchMessage.Visible = false;
                btnAddCharacters.Visible = true;
            }
            else
            {
                pnlSearchResults.Visible = false;
                pnlSearchMessage.Visible = true;
                litSearchMessage.Text = "There were no users found.";
            }
        }
        protected void btnAddCharacters_Click(object sender, EventArgs e)
        {
            string ToCharacters = "";
            if (ViewState["ToCharacters"] != null)
            {
                ToCharacters = ViewState["ToCharacters"].ToString();
            }
            //var RecipientList = ToCharacters.Split(new string[] { "|" }, StringSplitOptions.None);
            //var rpgCharacters = new rpgDBTableAdapters.CharactersTableAdapter();
            //rpgDB.CharactersDataTable rpgCharactersFound;
            //string CurrentRecipients = Request.QueryString["ToCharacters"].ToString();
            foreach (ListItem RecipientCharacter in cblUserSearchResults.Items)
            {
                //rpgCharactersFound = rpgCharacters.GetCharacterByCharacterID(int.Parse(RecipientCharacter));
                if (RecipientCharacter.Selected && !ToCharacters.Contains(RecipientCharacter.Value))
                { ToCharacters += "|" + RecipientCharacter.Value; }
            }

            ViewState["ToCharacters"] = ToCharacters.TrimStart(new char[] { Convert.ToChar("|") });
            PopulateRecipientList();
            txtUserSearch.Text = "";
            pnlSearchResults.Visible = false;
            btnAddCharacters.Visible = false;
            //ScriptManager.RegisterStartupScript(this, GetType(), "Close Modal Popup", "Closepopup();", true);
        }
        protected void btnRemoveCharacters_Click(object sender, EventArgs e)
        {
            string ToCharacters = "";
            List<string> RecipientList = new List<string>(ViewState["ToCharacters"].ToString().Split(new string[] { "|" }, StringSplitOptions.None));
            foreach (ListItem RemoveableCharacter in cblRemoveableCharacters.Items)
            {
                if (RemoveableCharacter.Selected)
                {
                    RecipientList.Remove(RemoveableCharacter.Value);
                }
            }
            foreach (string RecipientCharacter in RecipientList)
            { ToCharacters += "|" + RecipientCharacter; }
            ViewState["ToCharacters"] = ToCharacters.TrimStart(new char[] { Convert.ToChar("|") });
            PopulateRecipientList();
        }
        protected void processNewThreadCreation()
        {
            int SendAsID = 0;
            if (txtPostContent.Text.Trim().Length > 0)
            {
                if (int.TryParse(rblMyCharacters.SelectedValue, out SendAsID))
                {
                    if (ViewState["ToCharacters"] != null && ViewState["ToCharacters"].ToString().Length > 0)
                    {
                        var ThreadID = DataFunctions.Inserts.CreateNewThread(txtThreadTitle.Text);
                        DataFunctions.Inserts.InsertMessage(ThreadID, int.Parse(rblMyCharacters.SelectedValue), HttpUtility.HtmlEncode(txtPostContent.Text));
                        DataFunctions.Inserts.InsertThreadUser((int)Session["UserID"], ThreadID, 1, int.Parse(rblMyCharacters.SelectedValue), 1);
                        List<string> RecipientList = new List<string>(ViewState["ToCharacters"].ToString().Split(new string[] { "|" }, StringSplitOptions.None));
                        string InsertThreadUsersString = "";
                        var cmdInsertThreadUsers = new SqlCommand();

                        foreach (string Recipient in RecipientList)
                        {
                            //int ThisUserID = DataFunctions.Scalars.GetUserID(int.Parse(Recipient));
                            //DataFunctions.Inserts.InsertThreadUser(ThisUserID, ThreadID, 2, int.Parse(Recipient), 2);
                            InsertThreadUsersString += "INSERT INTO Thread_Users (UserID, ThreadID, ReadStatusID, CharacterID, PermissionID) VALUES ((Select UserID from Characters Where CharacterID = @CharacterID_" + Recipient.ToString() + "), @ThreadID, 2, @CharacterID_" + Recipient.ToString() + ", 2);";
                            cmdInsertThreadUsers.Parameters.AddWithValue("@CharacterID_" + Recipient.ToString(), Recipient);
                        }
                        cmdInsertThreadUsers.Parameters.AddWithValue("@ThreadID", ThreadID);
                        cmdInsertThreadUsers.CommandText = InsertThreadUsersString;
                        cmdInsertThreadUsers.Connection = DataFunctions.Connections.GetOpenRPGDBConn();
                        cmdInsertThreadUsers.ExecuteNonQuery();
                        cmdInsertThreadUsers.Connection.Close();
                        cmdInsertThreadUsers.Dispose();


                        NotificationFunctions.NewItemAlert(ThreadID.ToString(), rblMyCharacters.SelectedValue, "Message");
                        Session["CurrentThreadPage"] = null;
                        Response.Redirect("/My-Threads/", true);
                    }
                    else
                    {
                        pnlMessage.Visible = true; pnlMessage.CssClass = "alert alert-danger"; litMessage.Text = "You must select other characters to include in this thread. You cannot create a thread with just yourself.";
                    }
                }
                else { pnlMessage.Visible = true; pnlMessage.CssClass = "alert alert-danger"; litMessage.Text = "You must select one of your own characters to create this thread as."; }
            }
            else { pnlMessage.Visible = true; pnlMessage.CssClass = "alert alert-danger"; litMessage.Text = "You cannot create blank messages."; }
        }
        protected void processNewPostAddition()
        {
            int SendAsID = 0;
            if (txtPostContent.Text.Trim().Length > 0)
            {
                if (int.TryParse(rblMyCharacters.SelectedValue, out SendAsID))
                {
                    //var rpgThreadUsers = new rpgDBTableAdapters.Thread_UsersTableAdapter();
                    //rpgDB.Thread_UsersDataTable dtThreadUsers = rpgThreadUsers.GetThreadByThreadIDAndUserID((int) int.Parse());
                    DataTable dtThreads = DataFunctions.Tables.GetThreadDetailsForUser(int.Parse(Request.QueryString["ThreadID"]));
                    if (dtThreads.Rows.Count > 0)
                    {
                        DataFunctions.Inserts.InsertMessage(int.Parse(Request.QueryString["ThreadID"]), SendAsID, HttpUtility.HtmlEncode(txtPostContent.Text));
                        DataFunctions.Updates.MarkUnreadForOthersOnThread(int.Parse(Request.QueryString["ThreadID"]));
                        NotificationFunctions.NewItemAlert(Request.QueryString["ThreadID"].ToString(), SendAsID.ToString(), "Message");
                        Response.Redirect("/My-Threads/View-Thread/?ThreadID=" + Request.QueryString["ThreadID"].ToString(), true);
                    }
                    else { pnlMessage.Visible = true; pnlMessage.CssClass = "alert alert-danger"; litMessage.Text = "You do not have permission to post on this thread."; }
                }
                else { pnlMessage.Visible = true; pnlMessage.CssClass = "alert alert-danger"; litMessage.Text = "You must select a character to post as."; }
            }
            else { pnlMessage.Visible = true; pnlMessage.CssClass = "alert alert-danger"; litMessage.Text = "You cannot create blank messages."; }
        }
        protected void processPostChange()
        {
            int SendAsID = 0;
            if (int.TryParse(rblMyCharacters.SelectedValue, out SendAsID))
            {
                var con = new SqlConnection(ConfigurationManager.ConnectionStrings["RolePlayersGuild.Properties.Settings.rpgDBConn"].ToString());
                con.Open();
                SqlCommand scUpdateMessage = new SqlCommand("UPDATE Thread_Messages SET MessageContent = @Content, CreatorID = @Character, MessageLastEditDate = GETDATE() WHERE (ThreadMessageID = @MessageID)", con);
                scUpdateMessage.Parameters.AddWithValue("MessageID", CurrentMessage);
                scUpdateMessage.Parameters.AddWithValue("Character", rblMyCharacters.SelectedValue);
                scUpdateMessage.Parameters.AddWithValue("Content", HttpUtility.HtmlEncode(txtPostContent.Text));
                scUpdateMessage.ExecuteNonQuery();
                con.Close();
                Response.Redirect("/My-Threads/View-Thread/?ThreadID=" + Request.QueryString["ThreadID"].ToString(), true);
            }
            else { pnlMessage.Visible = true; pnlMessage.CssClass = "alert alert-danger"; litMessage.Text = "You must select a character to post as."; }
        }

        protected void btnCreateThread_Click(object sender, EventArgs e)
        {
            litMessage.Text = ScreenStatus;
            switch (ScreenStatus)
            {
                case "NewThread":
                    processNewThreadCreation();
                    break;
                case "AddPost":
                    processNewPostAddition();
                    break;
                case "EditPost":
                    processPostChange();
                    break;
                default:
                    break;
            }


        }
    }
}