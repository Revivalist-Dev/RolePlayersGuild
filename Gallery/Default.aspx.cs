using System;
using System.Data;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.Gallery
{
    public partial class Default : System.Web.UI.Page
    {
        readonly PagedDataSource _pgsource = new PagedDataSource();
        int _firstIndex, _lastIndex;
        private int _pageSize = 24;
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
                Response.Redirect(Request.Url.AbsolutePath + "?id=" + Request.QueryString["id"].ToString() + "&pg=" + value.ToString());
            }
        }
        protected string DisplayImageString(string imageString, string size, object IsMature)
        {
            return StringFunctions.DisplayImageString(imageString, size, (bool)IsMature);
        }
        protected string MatureContentWarning(object IsMature)
        {
            if ((bool)IsMature)
            {
                return "data-target=\"#confirm-ViewMatureContent\" data-";
            }
            else
            {
                return "";
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["id"] != null && Request.QueryString["id"].ToString().Length > 0)
            {
                var CharacterRecord = DataFunctions.Records.GetCharacter(int.Parse(Request.QueryString["id"]));

                if (CharacterRecord == null)
                {
                    Response.Redirect("/Error/BadRequest?type=NoGallery");
                }
                Page.Title = "Viewing Gallery for " + CharacterRecord["CharacterDisplayName"] + " on RPG";
                //var rpgUsers = new rpgDBTableAdapters.CharactersTableAdapter();
                if (Session["UserID"] != null)
                {
                    var OwnerUser = DataFunctions.Scalars.GetUserID(int.Parse(Request.QueryString["id"].ToString()));
                    if (OwnerUser == (int)Session["UserID"])
                    {
                        lnkAddPhoto.Visible = true;
                        lnkAddPhoto.NavigateUrl = "/My-Galleries/Edit-Gallery?Mode=New&GalleryID=" + Request.QueryString["id"].ToString();
                    }
                }
                //lnkBackToProfile.NavigateUrl = "/Character?id=" + Request.QueryString["id"].ToString();
                BindDataIntoRepeater();
            }
            else { Response.Redirect("/", true); }
        }
        protected void lvImages_DataBound(object sender, EventArgs e)
        {
         
        }

        protected void lvImages_ItemDataBound(object sender, ListViewItemEventArgs e)
        {
            if (e.Item.ItemType == ListViewItemType.DataItem)
            {
                DataRowView drv = e.Item.DataItem as DataRowView;
                if (CookieFunctions.UserID == 0)
                {
                    e.Item.Visible = !(bool)drv["IsMature"];
                }

                int UnreadImageCommentsCount = (int)drv["UnreadCommentCount"];
                if (UnreadImageCommentsCount > 0 && lnkAddPhoto.Visible)
                {
                    HtmlGenericControl spanImageCommentBadge = (HtmlGenericControl)(e.Item.FindControl("spanImageCommentBadge"));
                    spanImageCommentBadge.Visible = true; spanImageCommentBadge.InnerText = UnreadImageCommentsCount.ToString();
                }

            }
        }
        DataTable GetDataFromDb()
        {
            return DataFunctions.Tables.GetDataTable("SELECT [CharacterImageID], [CharacterImageURL], [IsMature], [IsPrimary], (Select Count(ImageCommentID) From ImageCommentsWithDetails Where IsRead = 0 And ImageID = Character_Images.CharacterImageID) As UnreadCommentCount FROM [Character_Images] WHERE ([CharacterID] = @ParamOne) ORDER BY [CharacterImageID]", Request.QueryString["id"].ToString());
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
            lvImages.DataSource = _pgsource;
            lvImages.DataBind();

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
    }
}
