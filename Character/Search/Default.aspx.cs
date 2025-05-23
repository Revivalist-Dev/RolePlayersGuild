using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI.WebControls;
using RolePlayersGuild.App_Code;

namespace RolePlayersGuild.Character.Search
{
    public partial class Default : System.Web.UI.Page
    {
        readonly PagedDataSource _pgsource = new PagedDataSource();
        int _firstIndex, _lastIndex;
        private int _pageSize = 36;

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
        private string CharacterSearchString
        {
            get
            {
                if (Session["CharacterSearchString"] == null)
                {
                    return "";
                }
                return ((string)Session["CharacterSearchString"]);
            }
            set
            {
                Session["CharacterSearchString"] = value;
            }
        }
        private int UserID
        {
            get
            {
                if (Session["UserID"] == null)
                {
                    return 0;
                }
                return ((int)Session["UserID"]);
            }
            set
            {
                Session["UserID"] = value;
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

        private int SearchForGenderID
        {
            get
            {
                if (Session["SearchForGenderID"] == null)
                {
                    return 0;
                }
                return ((int)Session["SearchForGenderID"]);
            }
            set
            {
                Session["SearchForGenderID"] = value;
            }
        }
        private int SearchForSexualityID
        {
            get
            {
                if (Session["SearchForSexualityID"] == null)
                {
                    return 0;
                }
                return ((int)Session["SearchForSexualityID"]);
            }
            set
            {
                Session["SearchForSexualityID"] = value;
            }
        }
        private int SearchForEroticaID
        {
            get
            {
                if (Session["SearchForEroticaID"] == null)
                {
                    return 0;
                }
                return ((int)Session["SearchForEroticaID"]);
            }
            set
            {
                Session["SearchForEroticaID"] = value;
            }
        }
        private int SearchForPostLengthID
        {
            get
            {
                if (Session["SearchForPostLengthID"] == null)
                {
                    return 0;
                }
                return ((int)Session["SearchForPostLengthID"]);
            }
            set
            {
                Session["SearchForPostLengthID"] = value;
            }
        }
        private int SearchForLiteracyID
        {
            get
            {
                if (Session["SearchForLiteracyID"] == null)
                {
                    return 0;
                }
                return ((int)Session["SearchForLiteracyID"]);
            }
            set
            {
                Session["SearchForLiteracyID"] = value;
            }
        }
        private int SearchForSourceID
        {
            get
            {
                if (Session["SearchForSourceID"] == null)
                {
                    return 0;
                }
                return ((int)Session["SearchForSourceID"]);
            }
            set
            {
                Session["SearchForSourceID"] = value;
            }
        }
        private int SearchForLFRPID
        {
            get
            {
                if (Session["SearchForLFRPID"] == null)
                {
                    return 0;
                }
                return ((int)Session["SearchForLFRPID"]);
            }
            set
            {
                Session["SearchForLFRPID"] = value;
            }
        }
        private int SearchOrderByID
        {
            get
            {
                if (Session["SearchOrderByID"] == null)
                {
                    return 0;
                }
                return ((int)Session["SearchOrderByID"]);
            }
            set
            {
                Session["SearchOrderByID"] = value;
            }
        }
        private bool ShowOnlineUsersOnly
        {
            get
            {
                if (Session["ShowOnlineUsersOnly"] == null)
                {
                    return false;
                }
                return ((bool)Session["ShowOnlineUsersOnly"]);
            }
            set
            {
                Session["ShowOnlineUsersOnly"] = value;
            }
        }
        
        private int CurrentPage
        {
            get
            {
                if (ViewState["CurrentPage"] != null)
                { return int.Parse(ViewState["CurrentPage"].ToString()); }
                if (Request.QueryString["pg"] == null || Request.QueryString["pg"].ToString().Length == 0)
                {
                    return 1;
                }
                return (int.Parse(Request.QueryString["pg"].ToString()));
            }
            set
            {
                ViewState["CurrentPage"] = value;
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["HideAds"] != null && Session["HideAds"].ToString() == "true")
            {
                divSidebarAd.Visible = false;
            }
            if (!Page.IsPostBack)
            {
                chkShowOnlyOnline.Checked = ShowOnlineUsersOnly;
                txtLikeField.Text = CharacterSearchString;
                ddlSortOrders.SelectedValue = SearchOrderByID.ToString();
                ddlPostLength.SelectedValue = SearchForPostLengthID.ToString();
                ddlSource.SelectedValue = SearchForSourceID.ToString();
                ddlOrientation.SelectedValue = SearchForSexualityID.ToString();
                ddlLiteracy.SelectedValue = SearchForLiteracyID.ToString();
                ddlGender.SelectedValue = SearchForGenderID.ToString();
                ddlERP.SelectedValue = SearchForEroticaID.ToString();
                ddlContactPref.SelectedValue = SearchForLFRPID.ToString();
                cblGenres.DataBind();
                foreach (int Genre in SharedSessionObjects.SelectedSearchGenres)
                {
                    cblGenres.Items.FindByValue(Genre.ToString()).Selected = true;
                }
                litListingType.Text = "All Characters";
                navPagingControls.Visible = true;
                BindDataIntoRepeater();
                pnlSearchBar.Visible = true;
                litListingType.Text = "Character Search";
                if (SearchByUniverseID > 0)
                {
                    btnUniverseFilter.Text = "View All Universes";
                    litListingType.Text = "Characters in the \"" + Session["UniverseName"].ToString() + "\" Universe";
                }
                else {
                    btnUniverseFilter.Text = "Search By Universe";
                }
            }
        }
        protected DataTable GetDataFromDb()
        {
            var con = new SqlConnection(ConfigurationManager.ConnectionStrings["RolePlayersGuild.Properties.Settings.rpgDBConn"].ToString());
            con.Open();
            var da = new SqlDataAdapter(); //("Select * From RecentUserThreads Where UserID = @userID Order By LastUpdateDate DESC", con);
            var daSelectCommand = new SqlCommand("SELECT c.CharacterNameClass, c.DisplayImageURL, c.CharacterID, c.CharacterDisplayName, c.LastAction, c.ShowWhenOnline FROM [CharactersForListing] AS c ");
            if (SearchByUniverseID > 0)
            {
                daSelectCommand.CommandText += "INNER JOIN Character_Universes AS cu ON c.CharacterID = cu.CharacterID WHERE (cu.UniverseID = @UniverseID)";
                daSelectCommand.Parameters.AddWithValue("UniverseID", SearchByUniverseID);
            }
            else {
                daSelectCommand.CommandText += "WHERE 9=9";
            }
            if (UserID > 0)
            {
                daSelectCommand.CommandText += " AND (c.UserID NOT IN (SELECT ub.UserBlocked FROM User_Blocking as ub WHERE (ub.UserBlockedBy = @UserID)) AND c.UserID NOT IN (SELECT ubb.UserBlockedBy FROM User_Blocking AS ubb WHERE (ubb.UserBlocked = @UserID)))";
                daSelectCommand.Parameters.AddWithValue("UserID", UserID);
            }
            if (CharacterSearchString.Length > 0)
            {
                var CharacterID = 0;
                if (int.TryParse(CharacterSearchString, out CharacterID))
                {
                    daSelectCommand.CommandText += " AND (c.CharacterID = @CharacterID)";
                    daSelectCommand.Parameters.AddWithValue("CharacterID", CharacterID);
                }
                else
                {
                    daSelectCommand.CommandText += " AND (c.CharacterDisplayName Like '%' + @SearchText + '%'";
                    daSelectCommand.CommandText += " OR c.CharacterFirstName Like '%' + @SearchText + '%'    ";
                    daSelectCommand.CommandText += " OR c.CharacterMiddleName Like '%' + @SearchText + '%'   ";
                    daSelectCommand.CommandText += " OR c.CharacterLastName Like '%' + @SearchText + '%')    ";
                    daSelectCommand.Parameters.AddWithValue("SearchText", CharacterSearchString.Trim());
                }
            }
            if (cblGenres.SelectedItem != null)
            {
                int GenreCount = 0;
                foreach (ListItem Genre in cblGenres.Items)
                {
                    if (Genre.Selected)
                    {
                        GenreCount += 1;
                        daSelectCommand.CommandText += "AND c.CharacterID In (Select cg.CharacterID From Character_Genres as cg Where cg.GenreID = @Genre" + GenreCount.ToString() + ")";
                        daSelectCommand.Parameters.AddWithValue("Genre" + GenreCount.ToString(), Genre.Value);
                    }
                }
            }
            if (ddlGender.SelectedValue != "0")
            {
                daSelectCommand.CommandText += " AND c.GenderID = @GenderID";
                daSelectCommand.Parameters.AddWithValue("GenderID", ddlGender.SelectedValue);
            }
            if (ddlContactPref.SelectedValue != "0")
            {
                daSelectCommand.CommandText += " AND c.LFRPStatus = @LFRPStatusID";
                daSelectCommand.Parameters.AddWithValue("LFRPStatusID", ddlContactPref.SelectedValue);
            }
            if (ddlSource.SelectedValue != "0")
            {
                daSelectCommand.CommandText += " AND c.CharacterSourceID = @SourceID";
                daSelectCommand.Parameters.AddWithValue("SourceID", ddlSource.SelectedValue);
            }
            if (ddlOrientation.SelectedValue != "0")
            {
                daSelectCommand.CommandText += " AND c.SexualOrientationID = @OrientationID";
                daSelectCommand.Parameters.AddWithValue("OrientationID", ddlOrientation.SelectedValue);
            }
            if (ddlERP.SelectedValue != "0")
            {
                if (ddlERP.SelectedValue == "2")
                {
                    daSelectCommand.CommandText += " AND (c.EroticaPreferenceID = 2 OR c.EroticaPreferenceID = 5)";
                }
                else {
                    daSelectCommand.CommandText += " AND c.EroticaPreferenceID = @ERPID";
                    daSelectCommand.Parameters.AddWithValue("ERPID", ddlERP.SelectedValue);
                }
            }

            if (ddlPostLength.SelectedValue != "0")
            {
                daSelectCommand.CommandText += " AND (c.PostLengthMinID <= @PostLength OR c.PostLengthMinID = 6) AND (c.PostLengthMaxID >= @PostLength OR c.PostLengthMaxID = 6)";
                daSelectCommand.Parameters.AddWithValue("PostLength", ddlPostLength.SelectedValue);
            }
            if (ddlLiteracy.SelectedValue != "0")
            {
                daSelectCommand.CommandText += " AND (c.LiteracyLevelID = @LiteracyID)";
                daSelectCommand.Parameters.AddWithValue("LiteracyID", ddlLiteracy.SelectedValue);
            }
            if (ShowOnlineUsersOnly)
            {
                daSelectCommand.CommandText += " AND (c.LastAction >= DateAdd(hour, -3, GetDate()) AND c.ShowWhenOnline = 1)";
            }

            switch (ddlSortOrders.SelectedValue)
            {
                case "1":
                    daSelectCommand.CommandText += " Order By c.CharacterID;";
                    break;
                //case "2":
                //    daSelectCommand.CommandText += " Order By LastLogin DESC, CharacterID DESC;";
                //    break;
                default:
                    daSelectCommand.CommandText += " Order By c.CharacterID DESC;";
                    break;
            }
            daSelectCommand.Connection = con;
            da.SelectCommand = daSelectCommand;

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
            rptCharacters.DataSource = _pgsource;
            rptCharacters.DataBind();

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
            //CurrentPage = 1;
            Response.Redirect(HttpContext.Current.Request.Url.AbsolutePath + "?pg=1");
        }
        protected void lbLast_Click(object sender, EventArgs e)
        {
            //CurrentPage = Convert.ToInt32(ViewState["TotalPages"]);
            Response.Redirect(HttpContext.Current.Request.Url.AbsolutePath + "?pg=" + ViewState["TotalPages"].ToString());
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

        protected string DisplayImageString(string imageString, string size)
        {
            return StringFunctions.DisplayImageString(imageString, size);
        }
        protected void rptPaging_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (!e.CommandName.Equals("newPage")) return;
            //CurrentPage = Convert.ToInt32(e.CommandArgument.ToString());
            //BindDataIntoRepeater();
            Response.Redirect(HttpContext.Current.Request.Url.AbsolutePath + "?pg=" + e.CommandArgument);
        }
        protected void rptPaging_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            var lnkPage = (LinkButton)e.Item.FindControl("lbPaging");
            if (lnkPage.CommandArgument != CurrentPage.ToString()) return;
            lnkPage.Enabled = false;
            lnkPage.CssClass = "CurrentPage";
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            ShowOnlineUsersOnly = chkShowOnlyOnline.Checked;
            CharacterSearchString = txtLikeField.Text;
            SearchOrderByID = int.Parse(ddlSortOrders.SelectedValue);
            SearchForSourceID = int.Parse(ddlSource.SelectedValue);
            SearchForSexualityID = int.Parse(ddlOrientation.SelectedValue);
            SearchForPostLengthID = int.Parse(ddlPostLength.SelectedValue);
            SearchForLiteracyID = int.Parse(ddlLiteracy.SelectedValue);
            SearchForLFRPID = int.Parse(ddlContactPref.SelectedValue);
            SearchForGenderID = int.Parse(ddlGender.SelectedValue);
            SearchForEroticaID = int.Parse(ddlERP.SelectedValue);
            List<int> ListForGenres = new List<int>();
            foreach (ListItem Genre in cblGenres.Items)
            {
                if (Genre.Selected)
                {
                    ListForGenres.Add(int.Parse(Genre.Value));
                }
            }
            SharedSessionObjects.SelectedSearchGenres = ListForGenres;
            CurrentPage = 1;
            BindDataIntoRepeater();
        }

        protected void cblGenres_DataBound(object sender, EventArgs e)
        {
            foreach (ListItem item in cblGenres.Items)
            {
                item.Attributes["title"] = item.Text;
            }
        }

        protected void rptCharacters_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
            {
                Panel pnlCharacter = (Panel)e.Item.FindControl("pnlCharacter");
                DataRowView CurrentRow = (DataRowView)e.Item.DataItem;
                DateTime dtLastAction;
                var ShowWhenOnline = CurrentRow["ShowWhenOnline"];
                if (CurrentRow["LastAction"] != null &&
                    DateTime.TryParse(CurrentRow["LastAction"].ToString(), out dtLastAction) &&
                    dtLastAction > DateTime.Now.AddHours(-3) &&
                    (bool)ShowWhenOnline)
                {
                    pnlCharacter.CssClass += " Online";
                    //if ((int)CurrentRow["TypeID"] == 2) { pnlCharacter.CssClass += " staff"; }
                }
                else { pnlCharacter.CssClass += " Offline"; }
            }
        }

        protected void btnUniverseFilter_Click(object sender, EventArgs e)
        {
            if (SearchByUniverseID > 0)
            {
                SearchByUniverseID = 0;
                Response.Redirect("/Character/Search/");
            }
            else {
                Response.Redirect("/Universe/List/");
            }
        }

        //protected string ColorName(object TypeID)
        //{
        //    return StringFunctions.NameColorClass((int)TypeID);
        //}

    }
}
