using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.templates.controls
{
    public partial class ViewThread : System.Web.UI.UserControl
    {
        readonly PagedDataSource _pgsource = new PagedDataSource();
        int _firstIndex, _lastIndex;
        private int _pageSize = 10;
        private int CurrentPage
        {
            get
            {
                if (Request.QueryString["pg"] == null || Request.QueryString["pg"].ToString().Length == 0)
                {
                    return 1;
                }
                return (int.Parse(Request.QueryString["pg"].ToString()));
            }
            set
            {
                Response.Redirect(HttpContext.Current.Request.Url.AbsolutePath + "?ThreadID=" + Request.QueryString["ThreadID"].ToString() + "&pg=" + value.ToString());
            }
        }
        private int ThreadID
        {
            get
            {
                if (Request.QueryString["ThreadID"] == null)
                { return 0; }
                return (int.Parse(Request.QueryString["ThreadID"].ToString()));
            }
        }
        //public ListItem OwnerCharacter
        //{
        //    get
        //    {
        //        if (ViewState["OwnerCharacterID"] == null || ViewState["OwnerCharacterName"] == null)
        //        { return null; }
        //        return new ListItem(ViewState["OwnerCharacterName"].ToString(), ViewState["OwnerCharacterID"].ToString());
        //    }
        //    set
        //    {
        //        ViewState["OwnerCharacterID"] = value.Value;
        //        ViewState["OwnerCharacterName"] = value.Text;
        //    }
        //}
        public string ThreadStatus { get; set; }
        //protected void PopulateRecipientList()
        //{
        //    string ToCharacters = "";
        //    if (ViewState["ToCharacters"] == null || ViewState["ToCharacters"].ToString().Length < 0)
        //    {
        //        if (Request.QueryString["ToCharacters"] != null)
        //        {
        //            ToCharacters = Request.QueryString["ToCharacters"];
        //            ViewState["ToCharacters"] = ToCharacters;
        //        }
        //    }
        //    else
        //    {
        //        ToCharacters = ViewState["ToCharacters"].ToString();
        //    }
        //    if (ToCharacters.Length > 0)
        //    {
        //        cblRemoveableCharacters.Items.Clear();
        //        var RecipientList = ToCharacters.Split(new string[] { "|" }, StringSplitOptions.None);
        //        var rpgCharacters = new rpgDBTableAdapters.CharactersWithDisplayImagesTableAdapter();
        //        rpgDB.CharactersWithDisplayImagesDataTable rpgCharactersFound;
        //        foreach (string RecipientCharacter in RecipientList)
        //        {
        //            rpgCharactersFound = rpgCharacters.GetCharacterByCharacterID(int.Parse(RecipientCharacter));
        //            ListItem RemoveableCharacter = new ListItem(rpgCharactersFound.Rows[0]["CharacterDisplayName"].ToString(), RecipientCharacter);
        //            cblRemoveableCharacters.Items.Add(RemoveableCharacter);
        //        }
        //    }
        //}
        protected string DisplayImageString(string imageString, string size)
        {
            return StringFunctions.DisplayImageString(imageString, size);
        }

        protected string ShowTimeAgo(string DateTimeString)
        {
            return StringFunctions.ShowTimeAgo(DateTimeString);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (ThreadID > 0)
            {

                DataTable dtThreadsFound = DataFunctions.Tables.GetThreadDetailsForUser(ThreadID);
                if (dtThreadsFound.Rows.Count != 0)
                {
                    if (!Page.IsPostBack)
                    {
                        switch (ThreadStatus)
                        {
                            case "Active":
                                break;
                            case "Deleted":
                                break;
                            default:
                                break;
                        }
                        litLastUpdate.Text = StringFunctions.ShowTimeAgo(dtThreadsFound.Rows[0]["LastUpdateDate"].ToString());
                        litThreadTitle.Text = dtThreadsFound.Rows[0]["ThreadTitle"].ToString();
                        Page.Title = dtThreadsFound.Rows[0]["ThreadTitle"].ToString() + " on RPG";
                        DataFunctions.Updates.MarkReadForCurrentUser(ThreadID);

                        //var queryThreads = dtThreadsFound.AsEnumerable().Select(thread => new { CharacterID = thread.Field<string>("CharacterID"),
                        //    CharacterDisplayName = thread.Field<string>("CharacterDisplayName"),
                        //    PermissionID = thread.Field<string>("PermissionID")
                        //}).Where(thread => thread.PermissionID == "1");

                        //DataRow OwnerRow = dtThreadsFound.AsEnumerable().SingleOrDefault(thread => (int)thread["PermissionID"] == 1);

                        //if (OwnerRow != null)
                        //{
                            //pnlRemoveableCharacters.Visible = true;
                            //pnlThreadCreatorMessage.Visible = true;
                            //pnlOtherCharacters.Visible = false;
                            pnlUserSearch.Visible = true;
                            //divLookingToAddMessage.Visible = false;
                            btnSaveCharacterSelection.Visible = true;
                            //lnkLeaveThread.Visible = false;
                            //lnkDeleteThread.Visible = true;
                            //lnkChangeOwner.Visible = true;
                            //LeaveThreadModal.Visible = false;
                            //var rpgCharacters = new rpgDBTableAdapters.CharactersWithDisplayImagesTableAdapter();
                            //var dtCharacter = DataFunctions.Tables.GetDataTable("Select CASE WHEN ShowWhenOnline = 1 AND LastAction > DateAdd(hour, -3, GetDate()) THEN CharacterDisplayName + ' - <span class=''UserOnline inline''>Online</span>' ELSE CharacterDisplayName END As CharacterDisplayName From CharactersWithDetails Where CharacterID = @ParamOne;", OwnerRow["CharacterID"].ToString());
                            //OwnerCharacter = new ListItem(dtCharacter.Rows[0]["CharacterDisplayName"].ToString(), OwnerRow["CharacterID"].ToString());
                            //dtCharacter.Dispose();
                            //rpgCharacters.Dispose();
                        //}
                        //else {
                            //DeleteThreadModal.Visible = false;
                            aViewEditCharacters.InnerText = "View Characters";
                        //}
                        BindDataIntoRepeater();
                        //PopulateRecipientList();
                    }
                }
                else
                { Response.Redirect("/", true); }
            }
            else
            { Response.Redirect("/", true); }

            if (Request.QueryString["Msg"] != null && Request.QueryString["Msg"].ToString().Length > 0)
            {
                switch (Request.QueryString["Msg"].ToString())
                {
                    case "CharsEdited":
                        pnlMessage.Visible = true;
                        pnlMessage.CssClass = "alert alert-success";
                        litMessage.Text = "The requested changes have been successfully made!";
                        break;
                }
            }
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "linkifyStuffOnNewPage", "$('[data-linkify]').linkify({ target: '_blank', nl2br: true, format: function (value, type) { if (type === 'url' && value.length > 50) { value = value.slice(0, 50) + '…'; } return value; } });", true);
        }
        // Get data from database/repository

        protected void btnUserSearch_ViewThread_Click(object sender, EventArgs e)
        {
            //int CharacterID = 0;
            //var rpgCharacters = new rpgDBTableAdapters.CharactersTableAdapter();
            //rpgDB.CharactersDataTable rpgCharactersFound;

            //var con = new SqlConnection(ConfigurationManager.ConnectionStrings["RolePlayersGuild.Properties.Settings.rpgDBConn"].ToString());
            //con.Open();
            //var da = new SqlDataAdapter();
            //var scGetCharacters = new SqlCommand();
            //scGetCharacters.Connection = con;
            //var dt = new DataTable();
            //scGetCharacters.CommandText = "SELECT * FROM Characters WHERE";
            //scGetCharacters.CommandText += " ((UserID NOT IN (SELECT UserBlocked FROM User_Blocking WHERE (UserBlockedBy = @SenderID))) AND (UserID NOT IN (SELECT UserBlockedBy FROM User_Blocking AS User_Blocking_1 WHERE (UserBlocked = @SenderID))))";

            //if (int.TryParse(txtUserSearch.Text, out CharacterID))
            //{
            //    scGetCharacters.CommandText += " AND (CharacterID = @CharID)";
            //    scGetCharacters.Parameters.AddWithValue("CharacterID", CharacterID);
            //    //rpgCharactersFound = rpgCharacters.GetPossibleRecipientsByCharacterID((int)Session["UserID"], CharacterID);
            //}
            //else
            //{
            //    scGetCharacters.CommandText += " AND ((CharacterDisplayName LIKE '%' + @SearchTerm + '%') OR (CharacterFirstName LIKE '%' + @SearchTerm + '%') OR (CharacterMiddleName LIKE '%' + @SearchTerm + '%') OR (CharacterLastName LIKE '%' + @SearchTerm + '%'))";
            //    scGetCharacters.Parameters.AddWithValue("SearchTerm", txtUserSearch.Text);
            //    //rpgCharactersFound = rpgCharacters.GetPossibleRecipientsByName((int)Session["UserID"], txtUserSearch.Text);
            //}

            ////scGetCharacters.CommandText += " AND (CharacterID <> @OwnerCharacterID)";

            //scGetCharacters.Parameters.AddWithValue("SenderID", (int)Session["UserID"]);
            ////scGetCharacters.Parameters.AddWithValue("OwnerCharacterID", OwnerCharacterID.Value);

            //da.SelectCommand = scGetCharacters;
            //da.Fill(dt);
            //con.Close();

            DataTable dt = DataFunctions.Tables.SearchCharactersForThread(txtUserSearch.Text, ThreadID);

            if (dt.Rows.Count > 0)
            {
                //, CharacterDisplayName + ' - ' + CharacterFirstName + ' ' + CharacterMiddleName + ' ' + CharacterLastName + ' - ' + Cast(CharacterID as NVarchar) AS CharacterTextLine
                cblUserSearchResults.DataSource = dt;
                cblUserSearchResults.DataValueField = "CharacterID";
                cblUserSearchResults.DataTextField = "CharacterDisplayName";
                cblUserSearchResults.DataBind();
                pnlSearchResults.Visible = true;
                pnlSearchMessage.Visible = false;
                btnSaveCharacterSelection.Visible = true;
            }
            else
            {
                pnlSearchResults.Visible = false;
                pnlSearchMessage.Visible = true;
                litSearchMessage.Text = "There were no users found.";
            }
        }

        protected void btnSaveCharacterSelection_Click(object sender, EventArgs e)
        {
            //string ToCharacters = "";

            //foreach (ListItem RecipientCharacter in cblUserSearchResults.Items)
            //{
            //    if (RecipientCharacter.Selected && !ToCharacters.Contains(RecipientCharacter.Value))
            //    { ToCharacters += "|" + RecipientCharacter.Value; }
            //}

            //ToCharacters = ToCharacters.TrimStart(new char[] { Convert.ToChar("|") });

            //var rpgThreadUsers = new rpgDBTableAdapters.Thread_UsersTableAdapter();
            //var rpgCharacterUsers = new rpgDBTableAdapters.CharactersTableAdapter();
            //var rpgThreadMessages = new rpgDBTableAdapters.Thread_MessagesTableAdapter();
            //List<string> RecipientList = new List<string>(ToCharacters.Split(new string[] { "|" }, StringSplitOptions.None));
            foreach (ListItem AddedCharacter in cblUserSearchResults.Items)
            {
                if (AddedCharacter.Selected)
                {
                    int ThisUserID = DataFunctions.Scalars.GetUserID(int.Parse(AddedCharacter.Value));
                    DataFunctions.Inserts.InsertThreadUser(ThisUserID, ThreadID, 2, int.Parse(AddedCharacter.Value), 2);
                    DataFunctions.Inserts.InsertMessage(ThreadID, 1450, "<div class=\"ThreadAlert alert-success\">" + AddedCharacter.Text.Replace(" - <span class='UserOnline inline'>Online</span>", "") + " has been added to the thread.</div>");
                }
            }
            //foreach (ListItem DeletedCharacter in cblRemoveableCharacters.Items)
            //{
            //    if (DeletedCharacter.Selected)
            //    {
            //        DataFunctions.Deletes.RemoveThreadUser(int.Parse(DeletedCharacter.Value), ThreadID);
            //        DataFunctions.Inserts.InsertMessage(ThreadID, 1450, "<div class=\"ThreadAlert alert-danger\">" + DeletedCharacter.Text.Replace(" - <span class='UserOnline inline'>Online</span>", "") + " has been removed from the thread.</div>");
            //    }
            //}

            //cblRemoveableCharacters.DataBind();
            txtUserSearch.Text = "";
            pnlSearchResults.Visible = false;

            Response.Redirect("/My-Threads/View-Thread/?ThreadID=" + Request.QueryString["ThreadID"].ToString() + "&Msg=CharsEdited", false);

        }
        static DataTable GetDataFromDb()
        {
            var con = new SqlConnection(ConfigurationManager.ConnectionStrings["RolePlayersGuild.Properties.Settings.rpgDBConn"].ToString());
            con.Open();
            var da = new SqlDataAdapter("Select * From ThreadMessagesWithCharacterInfo Where ThreadID = @ThreadID Order By ThreadMessageID DESC", con);
            da.SelectCommand.Parameters.AddWithValue("ThreadID", HttpContext.Current.Request.QueryString["ThreadID"].ToString());
            var dt = new DataTable();
            da.Fill(dt);
            con.Close();
            return dt;
        }
        // Bind PagedDataSource into Repeater
        private void BindDataIntoRepeater()
        {
            var dt = GetDataFromDb();
            _pgsource.DataSource = dt.DefaultView;
            _pgsource.AllowPaging = true;
            // Number of items to be displayed in the Repeater
            _pgsource.PageSize = _pageSize;
            _pgsource.CurrentPageIndex = CurrentPage - 1;
            // Keep the Total pages in View State
            ViewState["TotalPages"] = _pgsource.PageCount;
            // Example: "Page 1 of 10"
            //lblpage.Text = "Page " + (CurrentPage + 1) + " of " + _pgsource.PageCount;
            // Enable First, Last, Previous, Next buttons
            //lbPrevious.Enabled = !_pgsource.IsFirstPage;
            //lbNext.Enabled = !_pgsource.IsLastPage;
            lbFirst.Enabled = !_pgsource.IsFirstPage;
            lbLast.Enabled = !_pgsource.IsLastPage;

            // Bind data into repeater
            rptMessages.DataSource = _pgsource;
            rptMessages.DataBind();

            // Call the function to do paging
            HandlePaging();
        }
        private void HandlePaging()
        {
            var dt = new DataTable();
            dt.Columns.Add("PageIndex"); //Start from 1
            dt.Columns.Add("PageText"); //Start from 1

            _firstIndex = CurrentPage - 2;
            if (CurrentPage > 2)
                _lastIndex = CurrentPage + 3;
            else
                _lastIndex = 5;

            // Check last page is greater than total page then reduced it 
            // to total no. of page is last index
            if (_lastIndex > Convert.ToInt32(ViewState["TotalPages"]))
            {
                _lastIndex = Convert.ToInt32(ViewState["TotalPages"]);
                _firstIndex = _lastIndex - 5;
            }

            if (_firstIndex < 0)
                _firstIndex = 0;

            //Now creating page number based on above first and last page index
            for (var i = _firstIndex; i < _lastIndex; i++)
            {
                var dr = dt.NewRow();
                dr[0] = i + 1;
                dr[1] = i + 1;
                dt.Rows.Add(dr);
            }

            rptPaging.DataSource = dt;
            rptPaging.DataBind();
        }
        protected void lbFirst_Click(object sender, EventArgs e)
        {
            CurrentPage = 1;
        }
        protected void lbLast_Click(object sender, EventArgs e)
        {
            CurrentPage = Convert.ToInt32(ViewState["TotalPages"]);
        }
        //protected void lbPrevious_Click(object sender, EventArgs e)
        //{
        //    CurrentPage -= 1;
        //    BindDataIntoRepeater();
        //}
        //protected void lbNext_Click(object sender, EventArgs e)
        //{
        //    CurrentPage += 1;
        //    BindDataIntoRepeater();
        //}
        protected void rptPaging_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (!e.CommandName.Equals("newPage")) return;
            CurrentPage = Convert.ToInt32(e.CommandArgument.ToString());
            BindDataIntoRepeater();
        }

        protected void btnDeleteThread_Click(object sender, EventArgs e)
        {
            //var rpgThreads = new rpgDBTableAdapters.ThreadsTableAdapter();

            DataFunctions.Deletes.NukeThread(ThreadID);

            Response.Redirect("/My-Threads/", false);
        }

        //protected void cblRemoveableCharacters_DataBound(object sender, EventArgs e)
        //{
        //    cblRemoveableCharacters.Items.Remove(OwnerCharacter);
        //}

        protected void btnLeaveThread_Click(object sender, EventArgs e)
        {

            //var rpgThreadUsers = new rpgDBTableAdapters.Thread_UsersTableAdapter();
            //var rpgThreadMessages = new rpgDBTableAdapters.Thread_MessagesTableAdapter();

            int NumberOfCharacters = cblMyCharacters.Items.Count;
            int NumberOfCharactersRemoved = 0;

            foreach (ListItem RemovedCharacter in cblMyCharacters.Items)
            {
                if (RemovedCharacter.Selected)
                {
                    DataFunctions.Deletes.RemoveThreadCharacter(int.Parse(RemovedCharacter.Value), ThreadID);
                    DataFunctions.Inserts.InsertMessage(ThreadID, 1450, "<div class=\"ThreadAlert alert-danger\">" + RemovedCharacter.Text + " has left the thread.</div>");
                    NumberOfCharactersRemoved += 1;
                }
            }

            if (NumberOfCharacters == NumberOfCharactersRemoved)
            {
                Response.Redirect("/My-Threads/", false);
            }
            else {
                cblMyCharacters.DataBind();
                Response.Redirect("/My-Threads/View-Thread/?ThreadID=" + Request.QueryString["ThreadID"].ToString() + "&Msg=CharsEdited", false);
            }
        }

        protected void btnMarkUnread_Click(object sender, EventArgs e)
        {
            DataFunctions.Updates.ChangeReadStatusForCurrentUser(ThreadID, 2);
            Response.Redirect("/My-Threads/", true);
        }

        protected void rptMessages_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView drv = e.Item.DataItem as DataRowView;
                int UserID = int.Parse(drv.Row["UserID"].ToString());
                int CharacterID = int.Parse(drv.Row["CharacterID"].ToString());
                HtmlGenericControl liUserImage = (HtmlGenericControl)(e.Item.FindControl("liUserImage"));
                if (CharacterID == 1450)
                {
                    liUserImage.Visible = false;
                }
                else
                {
                    DateTime dtLastAction;
                    var ShowWhenOnline = drv["ShowWhenOnline"];
                    if (drv["LastAction"] != null &&
                        DateTime.TryParse(drv["LastAction"].ToString(), out dtLastAction) &&
                        dtLastAction > DateTime.Now.AddHours(-3) &&
                        (bool)ShowWhenOnline)
                    {
                        HtmlGenericControl liUserOnline = (HtmlGenericControl)(e.Item.FindControl("liUserOnline"));
                        liUserOnline.Visible = true;
                        liUserImage.Attributes["class"] += " Online";
                    }
                    else { liUserImage.Attributes["class"] += " Offline"; }
                }
                if (UserID != int.Parse(Session["UserID"].ToString()))
                {
                    HtmlGenericControl liEditMessage = (HtmlGenericControl)(e.Item.FindControl("liEditMessage"));
                    liEditMessage.Visible = false;
                }
            }
        }

        //protected void cblUserSearchResults_ViewThread_DataBound(object sender, EventArgs e)
        //{
        //    //cblUserSearchResults.Items.Remove(OwnerCharacter);
        //    foreach (ListItem Character in cblRemoveableCharacters.Items)
        //    {
        //        cblUserSearchResults.Items.Remove(Character);
        //    }
        //}

        //protected void rblOwnerCapableCharacters_DataBound(object sender, EventArgs e)
        //{
        //    rblOwnerCapableCharacters.Items.Remove(OwnerCharacter);
        //}

        //protected void btnSaveNewOwner_Click(object sender, EventArgs e)
        //{
        //    var con = new SqlConnection(ConfigurationManager.ConnectionStrings["RolePlayersGuild.Properties.Settings.rpgDBConn"].ToString());
        //    con.Open();
        //    var scReassignOwnership = new SqlCommand("UPDATE Thread_Users SET PermissionID = 2 WHERE (PermissionID = 1) AND (ThreadID = @ThreadID); UPDATE Thread_Users SET PermissionID = 1 WHERE (CharacterID = @CharacterID) AND (ThreadID = @ThreadID);", con);

        //    scReassignOwnership.Parameters.AddWithValue("CharacterID", rblOwnerCapableCharacters.SelectedValue);
        //    scReassignOwnership.Parameters.AddWithValue("ThreadID", Request.QueryString["ThreadID"].ToString());

        //    scReassignOwnership.ExecuteNonQuery();
        //    con.Close();

        //    DataFunctions.Inserts.InsertMessage(ThreadID, 1450, "<div class=\"ThreadAlert alert-info\">" + rblOwnerCapableCharacters.SelectedItem.Text.Replace(" - <span class='UserOnline inline'>Online</span>", "") + " is the new thread owner.</div>");

        //    Response.Redirect("/My-Threads/View-Thread/?ThreadID=" + Request.QueryString["ThreadID"].ToString() + "&Msg=CharsEdited", false);
        //}

        protected void rptPaging_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            var lnkPage = (LinkButton)e.Item.FindControl("lbPaging");
            if (lnkPage.CommandArgument != CurrentPage.ToString()) return;
            lnkPage.Enabled = false;
            lnkPage.CssClass = "CurrentPage";
        }
        //protected string ColorName(object TypeID)
        //{
        //    return StringFunctions.NameColorClass((int)TypeID);
        //}

    }
}