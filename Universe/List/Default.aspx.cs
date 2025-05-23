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

namespace RolePlayersGuild.Universe.List
{
    public partial class Default : System.Web.UI.Page
    {
        private string UniverseSearchString
        {
            get
            {
                if (Session["UniverseSearchString"] == null)
                {
                    return "";
                }
                return ((string)Session["UniverseSearchString"]);
            }
            set
            {
                Session["UniverseSearchString"] = value;
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
            txtLikeField.Text = UniverseSearchString;
            cblGenres.DataBind();
            foreach (var Genre in SharedSessionObjects.SelectedSearchGenres)
            {
                cblGenres.Items.FindByValue(Genre.ToString()).Selected = true;
            }
            BindDataIntoRepeater();
        }
        protected void rptUniverses_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView drv = e.Item.DataItem as DataRowView;
                if (drv != null)
                {
                    int UniverseID = int.Parse(drv.Row["UniverseID"].ToString());
                    Repeater rptGenres = (Repeater)(e.Item.FindControl("rptGenres"));

                    sdsUniverseGenres.SelectParameters[0].DefaultValue = UniverseID.ToString();
                    rptGenres.DataSource = sdsUniverseGenres;
                    rptGenres.DataBind();
                }
            }
        }
        private DataTable GetDataFromDb()
        {
            var con = new SqlConnection(ConfigurationManager.ConnectionStrings["RolePlayersGuild.Properties.Settings.rpgDBConn"].ToString());
            con.Open();
            var da = new SqlDataAdapter(); //("Select * From RecentUserThreads Where UserID = @userID Order By LastUpdateDate DESC", con);
            var daSelectCommand = new SqlCommand("SELECT * FROM [UniversesForListing] WHERE ([StatusID] = 2) ");
            if (UniverseSearchString.Length > 0)
            {
                daSelectCommand.CommandText += " AND (UniverseName Like '%' + @SearchText + '%' OR UniverseID = @UniverseID)    ";
                daSelectCommand.Parameters.AddWithValue("SearchText", UniverseSearchString.Trim());

                try
                {
                    var UniverseID = int.Parse(UniverseSearchString);
                    daSelectCommand.Parameters.AddWithValue("UniverseID", UniverseID);
                }
                catch
                {
                    daSelectCommand.Parameters.AddWithValue("UniverseID", 0);
                }
            }
            if (cblGenres.SelectedItem != null)
            {
                int GenreCount = 0;
                foreach (var Genre in cblGenres.Items.Cast<ListItem>().Where(Genre => Genre.Selected))
                {
                    GenreCount += 1;
                    daSelectCommand.CommandText += "AND UniverseID In (Select UniverseID From Universe_Genres Where GenreID = @Genre" + GenreCount + ")";
                    daSelectCommand.Parameters.AddWithValue("Genre" + GenreCount, Genre.Value);
                }
            }

            daSelectCommand.CommandText += " Order By UniverseName";

            daSelectCommand.Connection = con;
            da.SelectCommand = daSelectCommand;

            var dt = new DataTable();
            da.Fill(dt);
            con.Close();
            return dt;
            //return DataFunctions.Tables.GetDataTable("SELECT * FROM [UniversesForListing] WHERE ([StatusID] = 2) Order By UniverseName");
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
            rptUniverses.DataSource = _pgsource;
            rptUniverses.DataBind();

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
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            //ShowOnlineUsersOnly = chkShowOnlyOnline.Checked;
            UniverseSearchString = txtLikeField.Text;
            //SearchOrderByID = int.Parse(ddlSortOrders.SelectedValue);
            //SearchForSourceID = int.Parse(ddlSource.SelectedValue);
            //SearchForSexualityID = int.Parse(ddlOrientation.SelectedValue);
            //SearchForPostLengthID = int.Parse(ddlPostLength.SelectedValue);
            //SearchForLiteracyID = int.Parse(ddlLiteracy.SelectedValue);
            //SearchForLFRPID = int.Parse(ddlContactPref.SelectedValue);
            //SearchForGenderID = int.Parse(ddlGender.SelectedValue);
            //SearchForEroticaID = int.Parse(ddlERP.SelectedValue);
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
    }
}