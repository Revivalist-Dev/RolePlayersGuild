using RolePlayersGuild.App_Code;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.Story.List
{
    public partial class Default : System.Web.UI.Page
    {
        private string StorySearchString
        {
            get
            {
                if (Session["StorySearchString"] == null)
                {
                    return "";
                }
                return ((string)Session["StorySearchString"]);
            }
            set
            {
                Session["StorySearchString"] = value;
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
                Response.Redirect(HttpContext.Current.Request.Url.AbsolutePath + "?pg=" + value.ToString());
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            Master.PnlLeftCol.CssClass = "col-sm-3 col-xl-2";
            Master.PnlRightCol.CssClass = "col-sm-9 col-xl-10";
            if (Page.IsPostBack)
            {
                return;
            }
            txtLikeField.Text = StorySearchString;
            cblGenres.DataBind();
            foreach (var Genre in SharedSessionObjects.SelectedSearchGenres)
            {
                cblGenres.Items.FindByValue(Genre.ToString()).Selected = true;
            }
            foreach (var Rating in SharedSessionObjects.SelectedSearchRatings)
            {
                cblRatings.Items.FindByValue(Rating.ToString()).Selected = true;
            }
            BindDataIntoRepeater();
            if (SearchByUniverseID > 0)
            {
                btnUniverseFilter.Text = "View All Universes";
                litListingType.Text = "Stories in the \"" + Session["UniverseName"].ToString() + "\" Universe";
            }
            else
            {
                btnUniverseFilter.Text = "Search By Universe";
                litListingType.Text = "All Stories";
            }
        }
        protected void rptStories_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView drv = e.Item.DataItem as DataRowView;
                if (drv != null)
                {
                    int StoryID = int.Parse(drv.Row["StoryID"].ToString());
                    Repeater rptGenres = (Repeater)(e.Item.FindControl("rptGenres"));

                    sdsStoryGenres.SelectParameters[0].DefaultValue = StoryID.ToString();
                    rptGenres.DataSource = sdsStoryGenres;
                    rptGenres.DataBind();
                }
            }
        }
        private DataTable GetDataFromDb()
        {
            var con = new SqlConnection(ConfigurationManager.ConnectionStrings["RolePlayersGuild.Properties.Settings.rpgDBConn"].ToString());
            con.Open();
            var da = new SqlDataAdapter(); //("Select * From RecentUserThreads Where UserID = @userID Order By LastUpdateDate DESC", con);

            var daSelectCommand = new SqlCommand("SELECT * FROM [StoriesForListing] Where IsPrivate = 0");
            if (cblRatings.SelectedItem == null)
            {
                daSelectCommand.CommandText += " AND (ContentRatingID <> 3)";
            }
            if (StorySearchString.Length > 0)
            {
                daSelectCommand.CommandText += " AND (StoryTitle Like '%' + @SearchText + '%' OR StoryID = @StoryID)    ";
                daSelectCommand.Parameters.AddWithValue("SearchText", StorySearchString.Trim());

                try
                {
                    var StoryID = int.Parse(StorySearchString);
                    daSelectCommand.Parameters.AddWithValue("StoryID", StoryID);
                }
                catch
                {
                    daSelectCommand.Parameters.AddWithValue("StoryID", 0);
                }
            }


            if (cblGenres.SelectedItem != null)
            {
                int GenreCount = 0;
                foreach (var Genre in cblGenres.Items.Cast<ListItem>().Where(Genre => Genre.Selected))
                {
                    GenreCount += 1;
                    daSelectCommand.CommandText += "AND StoryID In (Select StoryID From Story_Genres Where GenreID = @Genre" + GenreCount + ")";
                    daSelectCommand.Parameters.AddWithValue("Genre" + GenreCount, Genre.Value);
                }
            }

            if (SearchByUniverseID > 0)
            {
                daSelectCommand.CommandText += " AND (UniverseID = @UniverseID)";
                daSelectCommand.Parameters.AddWithValue("UniverseID", SearchByUniverseID);
            }

            daSelectCommand.CommandText += " Order By StoryTitle";

            daSelectCommand.Connection = con;
            da.SelectCommand = daSelectCommand;
            var dt = new DataTable();
            da.Fill(dt);
            con.Close();
            return dt;
            //return DataFunctions.Tables.GetDataTable("SELECT * FROM [StoriesForListing] WHERE ([StatusID] = 2) Order By StoryName");
        }
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
            rptStories.DataSource = _pgsource;
            rptStories.DataBind();

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
        protected void rptPaging_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (!e.CommandName.Equals("newPage")) return;
            CurrentPage = Convert.ToInt32(e.CommandArgument.ToString());
            BindDataIntoRepeater();
        }
        protected void rptPaging_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            var lnkPage = (LinkButton)e.Item.FindControl("lbPaging");
            if (lnkPage.CommandArgument != CurrentPage.ToString()) return;
            lnkPage.Enabled = false;
            lnkPage.CssClass = "CurrentPage";
        }
        protected void cblGenres_DataBound(object sender, EventArgs e)
        {
            foreach (ListItem item in cblGenres.Items)
            {
                item.Attributes["title"] = item.Text;
            }
        }
        protected void btnUniverseFilter_Click(object sender, EventArgs e)
        {
            if (SearchByUniverseID > 0)
            {
                SearchByUniverseID = 0;
                Response.Redirect("/Story/List/");
            }
            else
            {
                Response.Redirect("/Universe/List/");
            }
        }
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            StorySearchString = txtLikeField.Text;

            var listForGenres = (from ListItem Genre in cblGenres.Items where Genre.Selected select int.Parse(Genre.Value)).ToList();
            SharedSessionObjects.SelectedSearchGenres = listForGenres;

            var listForRatings = (from ListItem Rating in cblRatings.Items where Rating.Selected select int.Parse(Rating.Value)).ToList();
            SharedSessionObjects.SelectedSearchRatings = listForRatings;

            CurrentPage = 1;
            //BindDataIntoRepeater();
        }
    }
}