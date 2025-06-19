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
    public partial class CharacterListing : System.Web.UI.UserControl
    {
        readonly PagedDataSource _pgsource = new PagedDataSource();
        int _firstIndex, _lastIndex;
        private int _pageSize = 18;

        public string OnlineStatus(object LastAction, object ShowWhenOnline)
        {
            DateTime dtLastAction;
            if (LastAction != null && DateTime.TryParse(LastAction.ToString(), out dtLastAction) &&
                dtLastAction > DateTime.Now.AddHours(-3) &&
                (bool)ShowWhenOnline)
            {
                return "<span class=\"UserOnline\">Online</span>";
            }
            return "<span class=\"UserOffline\">&nbsp;</span>";
        }
        private int UserID
        {
            get
            {
                return CookieFunctions.UserID;
            }
            set
            {
                CookieFunctions.UserID = value;
            }
        }
        public string DisplaySize { get; set; }
        public string RecordCount { get; set; }
        public string ScreenStatus { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                switch (ScreenStatus)
                {
                    //case "AllCharacters":
                    //case "SearchCharacters":
                    //    litListingType.Text = "All Characters";
                    //    navPagingControls.Visible = true;
                    //    BindDataIntoRepeater();
                    //    if (ScreenStatus == "SearchCharacters")
                    //    {
                    //        pnlSearchBar.Visible = true;
                    //        litListingType.Text = "Character Search";
                    //        chkShowOnlyOnline.Checked = ShowOnlineUsersOnly;
                    //        txtLikeField.Text = CharacterSearchString;
                    //    }
                    //    break;
                    case "CharactersByUser":
                        if (Request.QueryString["id"] != null && Request.QueryString["id"].ToString().Length > 0)
                        {
                            litListingType.Text = "Writer's Characters";
                            //sdsNewCharacters.SelectParameters[0].DefaultValue = RecordCount;
                            rptCharacters.DataSource = DataFunctions.Tables.GetDataTable("SELECT DisplayImageURL, CharacterID, CharacterDisplayName, LastAction, ShowWhenOnline, CharacterNameClass, UserTypeID FROM CharactersForListing WHERE IsPrivate = 0 AND UserID = @ParamOne ORDER BY CharacterID", Request.QueryString["id"]);
                            rptCharacters.DataBind();
                        }
                        break;
                    case "CharactersByUniverse":
                        if (Request.QueryString["id"] != null && Request.QueryString["id"].ToString().Length > 0)
                        {
                            litListingType.Text = "Characters in Universe";
                            rptCharacters.DataSource = DataFunctions.Tables.GetDataTable("SELECT c.DisplayImageURL, c.CharacterID, c.CharacterDisplayName, c.LastAction, c.ShowWhenOnline, c.CharacterNameClass, c.UserTypeID, cu.UniverseID FROM CharactersForListing AS c INNER JOIN Character_Universes AS cu ON c.CharacterID = cu.CharacterID WHERE (cu.UniverseID = @ParamOne) ORDER BY c.CharacterID", Request.QueryString["id"]);
                            rptCharacters.DataBind();
                        }
                        break;
                    //case "Administrators":
                    //    litListingType.Text = "Administrators";
                    //    //sdsNewCharacters.SelectParameters[0].DefaultValue = RecordCount;
                    //    rptCharacters.DataSource = DataFunctions.Tables.GetDataTable("SELECT DisplayImageURL, CharacterID, CharacterDisplayName, LastAction, ShowWhenOnline, CharacterNameClass, UserTypeID FROM CharactersForListing WHERE BadgeID = 3 AND CharacterDisplayName NOT LIKE '%[[]RPG:%' AND UserTypeID = @ParamOne ORDER BY CharacterID", 3);
                    //    rptCharacters.DataBind();
                    //    break;
                    //case "Moderators":
                    //    litListingType.Text = "Moderators";
                    //    //sdsNewCharacters.SelectParameters[0].DefaultValue = RecordCount;
                    //    rptCharacters.DataSource = DataFunctions.Tables.GetDataTable("SELECT DisplayImageURL, CharacterID, CharacterDisplayName, LastAction, ShowWhenOnline, CharacterNameClass, UserTypeID FROM CharactersForListing WHERE BadgeID = 3 AND CharacterDisplayName NOT LIKE '%[[]RPG:%' AND UserTypeID = @ParamOne ORDER BY CharacterID", 2);
                    //    rptCharacters.DataBind();
                    //    break;
                    //case "LTModerators":
                    //    litListingType.Text = "Lieutenant Moderators";
                    //    //sdsNewCharacters.SelectParameters[0].DefaultValue = RecordCount;
                    //    rptCharacters.DataSource = DataFunctions.Tables.GetDataTable("SELECT DisplayImageURL, CharacterID, CharacterDisplayName, LastAction, ShowWhenOnline, CharacterNameClass, UserTypeID FROM CharactersForListing WHERE BadgeID = 3 AND CharacterDisplayName NOT LIKE '%[[]RPG:%' AND (UserTypeID = 4 OR UserTypeID = 6) ORDER BY CharacterID");
                    //    rptCharacters.DataBind();
                    //    break;
                    case "NewCharacters":
                        litListingType.Text = "New Characters";
                        sdsNewCharacters.SelectParameters[0].DefaultValue = RecordCount;
                        rptCharacters.DataSource = sdsNewCharacters;
                        rptCharacters.DataBind();
                        pnlOtherOptions.Visible = true;
                        break;
                    case "NewCharactersNoAuth":
                        litListingType.Text = "New Characters";
                        sdsNewCharactersNoAuth.SelectParameters[0].DefaultValue = RecordCount;
                        rptCharacters.DataSource = sdsNewCharactersNoAuth;
                        rptCharacters.DataBind();
                        pnlOtherOptions.Visible = true;
                        break;
                    case "OnlineCharacters":
                        litListingType.Text = "Online Characters";
                        sdsOnlineCharacters.SelectParameters[0].DefaultValue = RecordCount;
                        rptCharacters.DataSource = sdsOnlineCharacters;
                        rptCharacters.DataBind();
                        break;

                }
            }

        }
        //protected DataTable GetDataFromDb()
        //{
        //    var con = new SqlConnection(ConfigurationManager.ConnectionStrings["RolePlayersGuild.Properties.Settings.rpgDBConn"].ToString());
        //    con.Open();
        //    var da = new SqlDataAdapter(); //("Select * From RecentUserThreads Where UserID = @userID Order By LastUpdateDate DESC", con);
        //    var daSelectCommand = new SqlCommand("SELECT DisplayImageURL, CharacterID, CharacterDisplayName, LastAction, ShowWhenOnline FROM [CharactersForListing] ");
        //    daSelectCommand.CommandText += "WHERE 9=9";
        //    if (ScreenStatus == "SearchCharacters")
        //    {
        //        if (UserID > 0)
        //        {
        //            daSelectCommand.CommandText += " AND (UserID NOT IN (SELECT UserBlocked FROM User_Blocking WHERE (UserBlockedBy = @UserID)) AND UserID NOT IN (SELECT UserBlockedBy FROM User_Blocking AS User_Blocking WHERE (UserBlocked = @UserID)))";
        //            daSelectCommand.Parameters.AddWithValue("UserID", UserID);
        //        }
        //        if (CharacterSearchString.Length > 0)
        //        {
        //            var CharacterID = 0;
        //            if (int.TryParse(CharacterSearchString, out CharacterID))
        //            {
        //                daSelectCommand.CommandText += " AND (CharacterID = @CharacterID)";
        //                daSelectCommand.Parameters.AddWithValue("CharacterID", CharacterID);
        //            }
        //            else
        //            {
        //                daSelectCommand.CommandText += " AND (CharacterDisplayName Like '%' + @SearchText + '%'";
        //                daSelectCommand.CommandText += " OR CharacterFirstName Like '%' + @SearchText + '%'    ";
        //                daSelectCommand.CommandText += " OR CharacterMiddleName Like '%' + @SearchText + '%'   ";
        //                daSelectCommand.CommandText += " OR CharacterLastName Like '%' + @SearchText + '%')    ";
        //                daSelectCommand.Parameters.AddWithValue("SearchText", CharacterSearchString);
        //            }
        //        }
        //        if (ddlGender.SelectedValue != "0")
        //        {
        //            daSelectCommand.CommandText += " AND GenderID = @GenderID";
        //            daSelectCommand.Parameters.AddWithValue("GenderID", ddlGender.SelectedValue);
        //        }
        //        if (chkShowOnlyLFRP.Checked)
        //        {
        //            daSelectCommand.CommandText += " AND LFRPStatus = 1";
        //        }
        //        if (ddlOriginality.SelectedValue != "0")
        //        {
        //            daSelectCommand.CommandText += " AND IsOriginal = @IsOriginal";
        //            daSelectCommand.Parameters.AddWithValue("IsOriginal", (ddlOriginality.SelectedValue == "1" ? true : false));
        //        }
        //        if (ddlOrientation.SelectedValue != "0")
        //        {
        //            daSelectCommand.CommandText += " AND SexualOrientationID = @OrientationID";
        //            daSelectCommand.Parameters.AddWithValue("OrientationID", ddlOrientation.SelectedValue);
        //        }
        //        if (ddlERP.SelectedValue != "0")
        //        {
        //            if (ddlERP.SelectedValue == "2")
        //            {
        //                daSelectCommand.CommandText += " AND (EroticaPreferenceID = 2 OR EroticaPreferenceID = 5)";
        //            }
        //            else {
        //                daSelectCommand.CommandText += " AND EroticaPreferenceID = @ERPID";
        //                daSelectCommand.Parameters.AddWithValue("ERPID", ddlERP.SelectedValue);
        //            }
        //        }

        //        if (ddlPostLength.SelectedValue != "0")
        //        {
        //            daSelectCommand.CommandText += " AND (PostLengthMinID <= @PostLength OR PostLengthMinID = 6) AND (PostLengthMaxID >= @PostLength OR PostLengthMaxID = 6)";
        //            daSelectCommand.Parameters.AddWithValue("PostLength", ddlPostLength.SelectedValue);
        //        }
        //        if (ddlLiteracy.SelectedValue != "0")
        //        {
        //            daSelectCommand.CommandText += " AND (LiteracyLevelID = @LiteracyID)";
        //            daSelectCommand.Parameters.AddWithValue("LiteracyID", ddlLiteracy.SelectedValue);
        //        }
        //        if (ShowOnlineUsersOnly)
        //        {
        //            daSelectCommand.CommandText += " AND (LastAction >= DateAdd(hour, -3, GetDate()) AND ShowWhenOnline = 1)";
        //        }
        //        //    daSelectCommand.CommandText += " AND SexualOrientationID = @OrientationID";
        //        //    daSelectCommand.CommandText += " AND  = @ERPID";

        //        //    if (ddlPostLengthMin.SelectedValue == "6")
        //        //    { }
        //        //    else
        //        //    { daSelectCommand.CommandText += " AND (PostLengthMinID >= @PostLengthMinID)"; }

        //        //    if (ddlPostLengthMax.SelectedValue == "6")
        //        //    { }
        //        //    else
        //        //    { daSelectCommand.CommandText += " AND (PostLengthMaxID <= @PostLengthMaxID OR PostLengthMaxID = 6)"; }

        //        //    if (ddlLiteracy.SelectedValue != "5")
        //        //    { daSelectCommand.CommandText += " AND  = @"; }
        //        //    daSelectCommand.Parameters.AddWithValue("", .SelectedValue);
        //        //    daSelectCommand.Parameters.AddWithValue("", .SelectedValue);
        //        //    daSelectCommand.Parameters.AddWithValue("PostLengthMinID", ddlPostLengthMin.SelectedValue);
        //        //    daSelectCommand.Parameters.AddWithValue("PostLengthMaxID", ddlPostLengthMax.SelectedValue);
        //        //    daSelectCommand.Parameters.AddWithValue("LiteracyID", .SelectedValue);
        //    }
        //    switch (ddlSortOrders.SelectedValue)
        //    {
        //        case "1":
        //            daSelectCommand.CommandText += " Order By CharacterID;";
        //            break;
        //        case "2":
        //            daSelectCommand.CommandText += " Order By LastLogin DESC, CharacterID DESC;";
        //            break;
        //        default:
        //            daSelectCommand.CommandText += " Order By CharacterID DESC;";
        //            break;
        //    }
        //    daSelectCommand.Connection = con;
        //    da.SelectCommand = daSelectCommand;

        //    var dt = new DataTable();
        //    da.Fill(dt);
        //    con.Close();
        //    return dt;
        //}
        //// Bind PagedDataSource into Repeater
        //private void BindDataIntoRepeater()
        //{
        //    var dt = GetDataFromDb();
        //    _pgsource.DataSource = dt.DefaultView;
        //    _pgsource.AllowPaging = true;
        //    // Number of items to be displayed in the Repeater
        //    _pgsource.PageSize = _pageSize;
        //    _pgsource.CurrentPageIndex = CurrentPage;
        //    // Keep the Total pages in View State
        //    ViewState["TotalPages"] = _pgsource.PageCount;
        //    // Example: "Page 1 of 10"
        //    //lblpage.Text = "Page " + (CurrentPage + 1) + " of " + _pgsource.PageCount;
        //    // Enable First, Last, Previous, Next buttons
        //    lbPrevious.Enabled = !_pgsource.IsFirstPage;
        //    lbNext.Enabled = !_pgsource.IsLastPage;
        //    //lbFirst.Enabled = !_pgsource.IsFirstPage;
        //    //lbLast.Enabled = !_pgsource.IsLastPage;

        //    // Bind data into repeater
        //    rptCharacters.DataSource = _pgsource;
        //    rptCharacters.DataBind();

        //    // Call the function to do paging
        //    HandlePaging();
        //}
        //private void HandlePaging()
        //{
        //    var dt = new DataTable();
        //    dt.Columns.Add("PageIndex"); //Start from 0
        //    dt.Columns.Add("PageText"); //Start from 1

        //    _firstIndex = CurrentPage - 2;
        //    if (CurrentPage > 2)
        //        _lastIndex = CurrentPage + 3;
        //    else
        //        _lastIndex = 5;

        //    // Check last page is greater than total page then reduced it 
        //    // to total no. of page is last index
        //    if (_lastIndex > Convert.ToInt32(ViewState["TotalPages"]))
        //    {
        //        _lastIndex = Convert.ToInt32(ViewState["TotalPages"]);
        //        _firstIndex = _lastIndex - 5;
        //    }

        //    if (_firstIndex < 0)
        //        _firstIndex = 0;

        //    //Now creating page number based on above first and last page index
        //    for (var i = _firstIndex; i < _lastIndex; i++)
        //    {
        //        var dr = dt.NewRow();
        //        dr[0] = i;
        //        dr[1] = i + 1;
        //        dt.Rows.Add(dr);
        //    }

        //    rptPaging.DataSource = dt;
        //    rptPaging.DataBind();
        //}
        ////protected void lbFirst_Click(object sender, EventArgs e)
        ////{
        ////    CurrentPage = 0;
        ////    BindDataIntoRepeater();
        ////}
        ////protected void lbLast_Click(object sender, EventArgs e)
        ////{
        ////    CurrentPage = (Convert.ToInt32(ViewState["TotalPages"]) - 1);
        ////    BindDataIntoRepeater();
        ////}
        //protected void lbPrevious_Click(object sender, EventArgs e)
        //{
        //    CurrentPage -= 1;
        //    //BindDataIntoRepeater();
        //}
        //protected void lbNext_Click(object sender, EventArgs e)
        //{
        //    CurrentPage += 1;
        //    //BindDataIntoRepeater();
        //}

        protected string DisplayImageString(string imageString, string size)
        {
            return StringFunctions.DisplayImageString(imageString, size);
        }
        //protected void rptPaging_ItemCommand(object source, RepeaterCommandEventArgs e)
        //{
        //    if (!e.CommandName.Equals("newPage")) return;
        //    CurrentPage = Convert.ToInt32(e.CommandArgument.ToString());
        //    //BindDataIntoRepeater();
        //}
        //protected void rptPaging_ItemDataBound(object sender, RepeaterItemEventArgs e)
        //{
        //    var lnkPage = (LinkButton)e.Item.FindControl("lbPaging");
        //    if (lnkPage.CommandArgument != CurrentPage.ToString()) return;
        //    lnkPage.Enabled = false;
        //    lnkPage.CssClass = "CurrentPage";
        //}
        //protected void btnSearch_Click(object sender, EventArgs e)
        //{
        //    ShowOnlineUsersOnly = chkShowOnlyOnline.Checked;
        //    CharacterSearchString = txtLikeField.Text;
        //    CurrentPage = 0;
        //    //BindDataIntoRepeater();
        //}

        protected void rptCharacters_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
            {
                Panel pnlCharacter = (Panel)e.Item.FindControl("pnlCharacter");
                switch (DisplaySize)
                {
                    case "2-Col":
                        pnlCharacter.CssClass = "col-xs-4 col-sm-6 Character";
                        break;
                    default:
                        pnlCharacter.CssClass = "col-xs-4 col-sm-2 col-xl-1 Character";
                        break;
                }
                DataRowView CurrentRow = (DataRowView)e.Item.DataItem;
                DateTime dtLastAction;
                var ShowWhenOnline = CurrentRow["ShowWhenOnline"];
                if (CurrentRow["LastAction"] != null &&
                    DateTime.TryParse(CurrentRow["LastAction"].ToString(), out dtLastAction) &&
                    dtLastAction > DateTime.Now.AddHours(-3) &&
                    (bool)ShowWhenOnline)
                {
                    pnlCharacter.CssClass += " Online";                    
                }
                else { pnlCharacter.CssClass += " Offline"; }
            }
        }
        //protected string ColorName(object TypeID)
        //{
        //    return StringFunctions.NameColorClass((int)TypeID);
        //}

    }
}